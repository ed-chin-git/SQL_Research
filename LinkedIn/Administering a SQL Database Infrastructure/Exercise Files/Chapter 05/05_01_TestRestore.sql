-- create a new database
CREATE DATABASE ProductionDB;
GO
USE ProductionDB;

-- set the recovery model if needed
ALTER DATABASE ProductionDB SET RECOVERY FULL;
GO

-- add a table and some records
CREATE SCHEMA Warehouse;
GO
CREATE TABLE Warehouse.NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL
);
GO
INSERT Warehouse.NewProducts
    VALUES  ('Salted Cashews'),
            ('Roasted Peanuts'),
            ('Honey Almonds');
GO
SELECT * FROM Warehouse.NewProducts;
GO

-- create full backup
BACKUP DATABASE ProductionDB
    TO DISK = 'C:\TempSQL\ProductionDB.bak'
    WITH FORMAT;
GO

-- get the list of filenames within the backup set
RESTORE FILELISTONLY
   FROM DISK = 'C:\TempSQL\ProductionDB.bak';

-- restore the backup to a new database
RESTORE DATABASE TestServerDB
   FROM DISK = 'C:\TempSQL\ProductionDB.bak'
   WITH MOVE 'ProductionDB' TO 'C:\TempSQL\TestServerDB.mdf',
        MOVE 'ProductionDB_log' TO 'C:\TempSQL\TestServerDB.ldf',
        RECOVERY;
GO

-- test it out
SELECT * FROM ProductionDB.Warehouse.NewProducts
SELECT * FROM TestServerDB.Warehouse.NewProducts

-- clean up the server
-- drop maintenance plan and job
USE master;
GO
DROP DATABASE ProductionDB;
GO
DROP DATABASE TestServerDB;
GO

-- also remove the backup files from C:\TempSQL