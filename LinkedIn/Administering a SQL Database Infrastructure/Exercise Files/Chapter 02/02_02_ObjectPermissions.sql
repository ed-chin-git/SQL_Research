-- switch to the database
USE WideWorldImporters;
GO

-- create a basic table
CREATE TABLE Warehouse.NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL
);
GO

-- create user and switch security contexts
CREATE USER WarehouseManager WITHOUT LOGIN;
GO
EXECUTE AS USER = 'WarehouseManager';
GO

-- access objects
SELECT * FROM Warehouse.NewProducts;
GO

INSERT Warehouse.NewProducts
    VALUES  ('Salted Cashews');
GO

-- return to dbo
REVERT;
GO
SELECT USER_NAME();
GO

-- assign WarehouseManager some permissions
ALTER ROLE db_datareader ADD MEMBER WarehouseManager;
GO
GRANT INSERT ON Warehouse.NewProducts TO WarehouseManager;
GO

-- test permissions
EXECUTE AS USER = 'WarehouseManager';
GO

INSERT Warehouse.NewProducts
    VALUES  ('Salted Cashews');
GO

SELECT * FROM Warehouse.NewProducts;
GO

SELECT * FROM Application.Cities;
GO

INSERT Application.Cities (CityName)
    VALUES  ('Bellingham');
GO

SELECT * FROM Application.SystemParameters;
GO

-- return to dbo
REVERT;
GO
SELECT USER_NAME();
GO

-- revoke permission granted through group membership
REVOKE SELECT ON Application.SystemParameters TO WarehouseManager;
GO

EXECUTE AS USER = 'WarehouseManager';
GO

SELECT * FROM Application.SystemParameters;
GO

-- return to dbo
REVERT;
GO
SELECT USER_NAME();
GO

-- deny permission granted through group membership
DENY SELECT ON Application.SystemParameters TO WarehouseManager;
GO

EXECUTE AS USER = 'WarehouseManager';
GO

SELECT * FROM Application.SystemParameters;
GO

-- clean up the instance
REVERT;
DROP USER WarehouseManager;
DROP TABLE Warehouse.NewProducts;
GO