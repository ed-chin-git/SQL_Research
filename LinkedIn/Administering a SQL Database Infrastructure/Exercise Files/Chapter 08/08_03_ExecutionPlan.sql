-- switch to the database
USE WideWorldImporters;
GO

SELECT * FROM Sales.Invoices;
GO

SELECT  Sales.Invoices.InvoiceID, Sales.Invoices.CustomerID, Sales.Invoices.InvoiceDate, Sales.Invoices.CustomerPurchaseOrderNumber, Sales.Invoices.Comments, Sales.Invoices.DeliveryInstructions,
            Sales.Customers.CustomerName, Sales.Customers.DeliveryMethodID, Application.Cities.CityName, Sales.Customers.PhoneNumber, Sales.InvoiceLines.StockItemID, Sales.InvoiceLines.InvoiceLineID,
            Sales.InvoiceLines.Description, Sales.InvoiceLines.Quantity, Sales.InvoiceLines.UnitPrice, Sales.InvoiceLines.TaxRate, Sales.InvoiceLines.TaxAmount, Sales.InvoiceLines.LineProfit,
            Sales.InvoiceLines.ExtendedPrice, Warehouse.StockItems.SupplierID, Warehouse.StockItems.ColorID, Warehouse.StockItems.Brand, Warehouse.StockItems.Size, Warehouse.StockItems.QuantityPerOuter,
            Warehouse.StockItems.Barcode, Warehouse.StockItems.Photo
FROM    Sales.Invoices INNER JOIN
            Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID INNER JOIN
            Sales.Customers ON Sales.Invoices.CustomerID = Sales.Customers.CustomerID INNER JOIN
            Warehouse.StockItems ON Sales.InvoiceLines.StockItemID = Warehouse.StockItems.StockItemID INNER JOIN
            Application.Cities ON Sales.Customers.DeliveryCityID = Application.Cities.CityID AND Sales.Customers.DeliveryCityID = Application.Cities.CityID;
GO