-- create a new database
CREATE DATABASE TransactionLogDB;
GO

USE TransactionLogDB;
GO

-- review the recovery model with T-SQL
SELECT name, recovery_model_desc
   FROM sys.databases
   WHERE name = 'TransactionLogDB';
GO
-- set the recovery model if needed
ALTER DATABASE TransactionLogDB SET RECOVERY FULL;
GO

-- add a table and some records to the database
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
BACKUP DATABASE TransactionLogDB
    TO DISK = 'C:\TempSQL\TransactionLogDB.bak'
    WITH FORMAT;
GO

-- add additional records
INSERT Warehouse.NewProducts
    VALUES  ('Toasted Macadamia'),
            ('Shelled Pistachios'),
            ('Whole Walnuts');
GO

SELECT GetDate();
GO

-- add additional record
INSERT Warehouse.NewProducts
    VALUES  ('Dried Raisins');
GO

SELECT * FROM Warehouse.NewProducts;
GO

-- create transaction log backup
BACKUP LOG TransactionLogDB
   TO DISK = 'C:\TempSQL\TransactionLogDB.log';
GO

-- remove the database
USE TempDB;
GO
DROP DATABASE TransactionLogDB;
GO

-- restore from backup with transaction log

-- check the results
USE TransactionLogDB;
GO
SELECT * FROM Warehouse.NewProducts;
GO

-- clean up the server
USE TempDB;
GO
DROP DATABASE TransactionLogDB;
GO

-- also remove the backup file from C:\TempSQL