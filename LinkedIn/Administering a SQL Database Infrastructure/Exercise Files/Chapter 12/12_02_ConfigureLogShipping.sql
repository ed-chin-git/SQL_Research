CREATE DATABASE KinetecoIncDB;
GO
USE KinetecoIncDB;

-- create a table
CREATE TABLE NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL);
GO

-- populate with data from wide world importers
INSERT INTO NewProducts
SELECT StockItemName
    FROM WideWorldImporters.Warehouse.StockItems
    WHERE SupplierID = 4;
GO

SELECT * FROM NewProducts;
GO

-- set up log shipping
-- set recovery model
ALTER DATABASE KinetecoIncDB SET RECOVERY FULL;
GO

-- populate with data from wide world importers
INSERT INTO NewProducts
SELECT StockItemName
    FROM WideWorldImporters.Warehouse.StockItems
    WHERE SupplierID = 5;
GO

-- view history details
SELECT * FROM msdb.dbo.log_shipping_monitor_history_detail;
SELECT * FROM msdb.dbo.log_shipping_monitor_primary;