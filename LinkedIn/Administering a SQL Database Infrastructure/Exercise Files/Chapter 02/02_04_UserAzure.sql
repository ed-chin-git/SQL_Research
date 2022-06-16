-- in Azure Portal

CREATE USER Tabitha WITH PASSWORD = 'Tab1tha9';

SELECT USER_NAME();

EXECUTE AS USER = 'Tabitha';
SELECT USER_NAME();


-- connect to Azure SQL Database via SSMS

-- create some basic tables
CREATE TABLE NewProducts (
    ProductID int IDENTITY(1,1) PRIMARY KEY,
    ProductName nvarchar(100) NOT NULL
);
GO

CREATE TABLE NewVendor (
    VendroID int IDENTITY(1,1) PRIMARY KEY,
    VendorName nvarchar(100) NOT NULL
);
GO

-- grant Tabitha some permissions
GRANT SELECT ON NewProducts TO Tabitha;
GRANT INSERT ON NewProducts TO Tabitha;
GO


EXECUTE AS USER = 'Tabitha';
SELECT USER_NAME();

SELECT * FROM NewProducts;
GO

SELECT * FROM NewVendor;
GO

INSERT NewProducts
    VALUES  ('Salted Cashews');
GO

REVERT;
SELECT USER_NAME();