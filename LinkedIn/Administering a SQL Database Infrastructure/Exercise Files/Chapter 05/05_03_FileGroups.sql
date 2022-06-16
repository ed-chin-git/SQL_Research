CREATE DATABASE FGRestoreDB;
GO
USE FGRestoreDB;

-- set recovery model
ALTER DATABASE FGRestoreDB SET RECOVERY FULL;
GO

-- create an additional filegroup
ALTER DATABASE FGRestoreDB
ADD FILEGROUP ColdStorageFG;
GO

ALTER DATABASE FGRestoreDB
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

-- view the current location of data and log files
SELECT name, physical_name, state_desc
    FROM sys.master_files
    WHERE database_id = DB_ID('FGRestoreDB');
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

-- backup the database
BACKUP DATABASE FGRestoreDB
    TO DISK = 'C:\TempSQL\FGRestoreDB.bak'
    WITH FORMAT;
GO

-- delete database
USE TempDB;
GO
DROP DATABASE FGRestoreDB;
GO

-- restore from the full backup
RESTORE DATABASE FGRestoreDB
   FROM DISK = 'C:\TempSQL\FGRestoreDB.bak'
   WITH RECOVERY
GO

-- test database
USE FGRestoreDB;
GO
SELECT * FROM NewProducts;
SELECT * FROM DiscontinuedProducts;
GO

-- backup the secondary filegroup by itself
BACKUP DATABASE FGRestoreDB
   FILEGROUP = 'ColdStorageFG'
   TO DISK = 'C:\TempSQL\ColdData.bak'
GO

-- simulate a catastrophic event
USE TempDB;
GO
-- shut down the server, and delete the secondary .ndf data file
-- restart server

-- test database
USE FGRestoreDB;
GO

-- restore only the secondary filegroups
RESTORE DATABASE FGRestoreDB
   FILE = 'ColdData',
   FILEGROUP = 'ColdStorageFG'
   FROM DISK = 'C:\TempSQL\ColdData.bak'
   WITH RECOVERY
GO

-- need a tail log backup first
BACKUP LOG FGRestoreDB
   TO DISK = 'C:\TempSQL\Taillog.bak'
   WITH NO_TRUNCATE;
GO

-- now restore the secondary filegroup
RESTORE DATABASE FGRestoreDB
   FILE = 'ColdData',
   FILEGROUP = 'ColdStorageFG'
   FROM DISK = 'C:\TempSQL\ColdData.bak'
   WITH NORECOVERY
GO

-- restore the tail log
RESTORE LOG FGRestoreDB
   FROM DISK = 'C:\TempSQL\TailLog.bak'
   WITH RECOVERY
GO

-- test database
USE FGRestoreDB;
GO
SELECT * FROM NewProducts;
SELECT * FROM DiscontinuedProducts;
GO

-- clean up the server
USE TempDB;
GO
DROP DATABASE FGRestoreDB;
GO
-- remove files from C:\TempSQL