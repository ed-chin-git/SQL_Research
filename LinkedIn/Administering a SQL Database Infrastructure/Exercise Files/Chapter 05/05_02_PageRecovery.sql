-- create a new database
CREATE DATABASE PageDB;
GO
USE PageDB;

-- set the recovery model if needed
ALTER DATABASE PageDB SET RECOVERY FULL;
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
BACKUP DATABASE PageDB
    TO DISK = 'C:\TempSQL\PageDB.bak'
    WITH FORMAT;
GO

-- check suspect_pages table in msdb
SELECT * FROM msdb.dbo.suspect_pages;
GO

-- identify the pages used in the database
DBCC IND ('PageDB', 'Warehouse.NewProducts', -1);
GO

-- clean up the server
USE TempDB;
GO
DROP DATABASE PageDB;
GO

-- also remove the backup file from C:\TempSQL