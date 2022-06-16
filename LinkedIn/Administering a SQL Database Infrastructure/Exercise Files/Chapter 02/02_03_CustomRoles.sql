-- switch to the database
USE WideWorldImporters;
GO

-- create some basic tables
CREATE TABLE Warehouse.NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL
);
GO

CREATE TABLE Warehouse.NewVendor (
    VendroID int IDENTITY(1,1) PRIMARY KEY,
    VendorName nvarchar(100) NOT NULL
);
GO

-- create user and switch security contexts
CREATE USER WarehouseManager WITHOUT LOGIN;
GO

-- create a user-defined role
CREATE ROLE ProductEntry;
GO

GRANT SELECT ON Warehouse.NewProducts TO ProductEntry;
GRANT SELECT ON Warehouse.NewVendor TO ProductEntry;
GRANT INSERT ON Warehouse.NewProducts TO ProductEntry;
GO

-- assign role membership
ALTER ROLE ProductEntry ADD MEMBER WarehouseManager;
GO

-- test the role
EXECUTE AS USER = 'WarehouseManager';

SELECT * FROM Warehouse.NewProducts;
GO

SELECT * FROM Warehouse.NewVendor;
GO

SELECT * FROM Warehouse.StockItems;
GO

INSERT Warehouse.NewProducts
    VALUES  ('Salted Cashews');
GO

INSERT Warehouse.NewVendor
    VALUES  ('Adams Cashew Farm');
GO

-- add a second member to the role
CREATE USER InventoryManager WITHOUT LOGIN;
GO
ALTER ROLE ProductEntry ADD MEMBER InventoryManager;
GO

-- clean up the instance
REVERT;
DROP ROLE ProductEntry;
ALTER ROLE ProductEntry DROP MEMBER WarehouseManager;
ALTER ROLE ProductEntry DROP MEMBER InventoryManager;
DROP USER WarehouseManager;
DROP USER InventoryManager;
DROP TABLE Warehouse.NewProducts;
DROP TABLE Warehouse.NewVendor;
GO