-- switch databases
USE WideWorldImporters;
GO

-- rebuild a nonclustered index
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders DISABLE;
GO
ALTER INDEX FK_Sales_Orders_CustomerID ON Sales.Orders REBUILD WITH (ONLINE = ON);
GO