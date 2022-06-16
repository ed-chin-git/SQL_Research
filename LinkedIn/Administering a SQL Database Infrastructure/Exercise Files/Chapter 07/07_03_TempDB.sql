-- switch to the database
USE WideWorldImporters;
GO

-- create and populate a temporary table
SELECT * INTO #InvoiceDetails FROM (
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
SELECT * FROM #InvoiceDetails;
GO

-- view file space usage per database
SELECT * FROM sys.dm_db_file_space_usage;

-- find tempdb database id
SELECT DB_ID('tempdb') AS 'Database Name';
GO

USE tempdb;
GO
SELECT * FROM sys.dm_db_file_space_usage;
GO

-- view active task tempdb usage by session
SELECT * FROM sys.dm_db_task_space_usage;
GO

-- drop table and recreate. Be quick!
USE WideWorldImporters;
GO
DROP TABLE #InvoiceDetails;
GO

--
SELECT * FROM sys.dm_db_session_space_usage
ORDER BY user_objects_alloc_page_count DESC;
GO

-- clear tempdb
DROP TABLE #InvoiceDetails;
GO