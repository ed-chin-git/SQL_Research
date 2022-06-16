-- switch to the database
USE WideWorldImporters;
GO

-- perform a variety of actions on the database
SELECT * INTO dbo.InvoiceDetails FROM (
SELECT  Sales.Invoices.InvoiceID, Sales.Invoices.CustomerID, Sales.Invoices.InvoiceDate, Sales.Invoices.CustomerPurchaseOrderNumber, Sales.Invoices.Comments, Sales.Invoices.DeliveryInstructions,
            Sales.Customers.CustomerName, Sales.Customers.DeliveryMethodID, Application.Cities.CityName, Sales.Customers.PhoneNumber, Sales.InvoiceLines.StockItemID, Sales.InvoiceLines.InvoiceLineID,
            Sales.InvoiceLines.Description, Sales.InvoiceLines.Quantity, Sales.InvoiceLines.UnitPrice, Sales.InvoiceLines.TaxRate, Sales.InvoiceLines.TaxAmount, Sales.InvoiceLines.LineProfit,
            Sales.InvoiceLines.ExtendedPrice, Warehouse.StockItems.SupplierID, Warehouse.StockItems.ColorID, Warehouse.StockItems.Brand, Warehouse.StockItems.Size, Warehouse.StockItems.QuantityPerOuter,
            Warehouse.StockItems.Barcode, Warehouse.StockItems.Photo
FROM    Sales.Invoices INNER JOIN
            Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID INNER JOIN
            Sales.Customers ON Sales.Invoices.CustomerID = Sales.Customers.CustomerID INNER JOIN
            Warehouse.StockItems ON Sales.InvoiceLines.StockItemID = Warehouse.StockItems.StockItemID INNER JOIN
            Application.Cities ON Sales.Customers.DeliveryCityID = Application.Cities.CityID AND Sales.Customers.DeliveryCityID = Application.Cities.CityID) AS temp;
GO
SELECT * FROM dbo.InvoiceDetails;
GO
DROP TABLE dbo.InvoiceDetails;
GO
CREATE USER WarehouseManager WITHOUT LOGIN;
GO
ALTER ROLE db_datareader ADD MEMBER WarehouseManager;
GO
EXECUTE AS USER = 'WarehouseManager';
GO
SELECT * FROM Application.People;
GO
SELECT * FROM Application.Cities;
GO
SELECT FullName INTO DuplicatePeople FROM Application.People;
GO
REVERT;
GO
DROP USER WarehouseManager;
GO

-- clean up the server
   -- disable data collection
   -- clean up data collectors
   -- delete data collection database