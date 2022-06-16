CREATE DATABASE PiecemealDB;
GO
USE PiecemealDB;

-- set recovery model
ALTER DATABASE PiecemealDB SET RECOVERY FULL;
GO

-- create an additional filegroup
ALTER DATABASE PiecemealDB
ADD FILEGROUP ColdStorageFG;
GO

ALTER DATABASE PiecemealDB
ADD FILE
(
    NAME = ColdData,
    FILENAME = 'C:\TempSQL\ColdData.ndf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10MB
)
TO FILEGROUP ColdStorageFG;
GO

-- create tables on two filegroups
CREATE TABLE NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL);
GO

CREATE TABLE DiscontinuedProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL)
ON ColdStorageFG;
GO

-- populate with data from wide world importers
INSERT INTO NewProducts
SELECT StockItemName
    FROM WideWorldImporters.Warehouse.StockItems
    WHERE SupplierID = 4;
GO

INSERT INTO DiscontinuedProducts
SELECT StockItemName
    FROM WideWorldImporters.Warehouse.StockItems
    WHERE SupplierID = 5;
GO

-- double check filegroup assignment
SELECT OBJECT_NAME(sys.tables.object_id) AS ObjectName, sys.data_spaces.name AS FileGroup
    FROM sys.data_spaces
        JOIN sys.indexes on sys.indexes.data_space_id = sys.data_spaces.data_space_id
        JOIN sys.tables on sys.tables.object_id = sys.indexes.object_id
    WHERE sys.indexes.index_id < 2
        AND sys.tables.type = 'U';
GO

-- double check data entry
SELECT * FROM NewProducts;
SELECT * FROM DiscontinuedProducts;

-- mark the cold storage filegroup read-only
ALTER DATABASE PiecemealDB
MODIFY FILEGROUP ColdStorageFG READ_ONLY;
GO

-- backup the database
BACKUP DATABASE PiecemealDB
    TO DISK = 'C:\TempSQL\PiecemealDB.bak'
    WITH FORMAT;
GO

-- add a few more products to NewProducts
INSERT INTO NewProducts
SELECT StockItemName
    FROM WideWorldImporters.Warehouse.StockItems
    WHERE SupplierID = 12;
GO

SELECT * FROM NewProducts;

-- make a log backup
BACKUP LOG PiecemealDB
    TO DISK = 'C:\TempSQL\PiecemealDBLog.bak';
GO

-- delete database
USE TempDB;
GO
DROP DATABASE PiecemealDB;
GO

-- restore primary filegroup
RESTORE DATABASE PiecemealDB READ_WRITE_FILEGROUPS
FROM DISK = 'C:\TempSQL\PiecemealDB.bak'
WITH PARTIAL,
NORECOVERY;
GO

RESTORE LOG PiecemealDB
FROM DISK = 'C:\TempSQL\PiecemealDBLog.bak'
WITH RECOVERY;
GO

-- test database
USE PiecemealDB;
GO
SELECT * FROM NewProducts;
SELECT * FROM DiscontinuedProducts;
GO

-- restore the secondary read-only filegroup
RESTORE DATABASE PiecemealDB FILEGROUP='ColdStorageFG'
FROM DISK = 'C:\TempSQL\PiecemealDB.bak'
WITH RECOVERY;
GO

USE master;
GO

-- test database
USE PiecemealDB;
GO
SELECT * FROM NewProducts;
SELECT * FROM DiscontinuedProducts;
GO

-- clean up the server
USE TempDB;
GO
DROP DATABASE PiecemealDB;
GO
-- remove files from C:\TempSQL