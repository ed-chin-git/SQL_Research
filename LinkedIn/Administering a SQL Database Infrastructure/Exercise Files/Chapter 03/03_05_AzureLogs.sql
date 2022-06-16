-- switch to the Azure database
USE AzureSQLDatabase;
GO

-- trigger audit events
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

SELECT * FROM Warehouse.NewProducts
WHERE ProductID = 2;
GO