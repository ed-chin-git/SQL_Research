-- switch to the database
USE WideWorldImporters;
GO

-- use the tuning advisor on the following query
SELECT  Purchasing.PurchaseOrderLines.PurchaseOrderID,
        Purchasing.PurchaseOrderLines.PurchaseOrderLineID,
        Warehouse.StockItems.StockItemName,
        Warehouse.Colors.ColorName
FROM    Purchasing.PurchaseOrderLines INNER JOIN
        Purchasing.PurchaseOrders ON Purchasing.PurchaseOrderLines.PurchaseOrderID = Purchasing.PurchaseOrders.PurchaseOrderID INNER JOIN
        Warehouse.StockItems ON Purchasing.PurchaseOrderLines.StockItemID = Warehouse.StockItems.StockItemID INNER JOIN
        Warehouse.Colors ON Warehouse.StockItems.ColorID = Warehouse.Colors.ColorID AND Warehouse.StockItems.ColorID = Warehouse.Colors.ColorID
WHERE   ColorName = 'Black'
;
GO