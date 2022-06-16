-- create a sample database from existing Wide World Importers data
CREATE DATABASE AlwaysEncryptDB;
GO
USE AlwaysEncryptDB;
GO

SELECT CustomerID, CustomerName, PhoneNumber
INTO Customers
FROM WideWorldImporters.Sales.Customers;
GO

-- explore the data
SELECT *
FROM Customers
ORDER BY CustomerID;
GO

-- enable Always Encrypted
-- view the results of Always Encrypted
SELECT *
FROM Customers
ORDER BY CustomerID;
GO

-- utilize the certificate and view decrypted data
SELECT *
FROM Customers
ORDER BY CustomerID;
GO

-- insert values
INSERT INTO Customers
VALUES ('2000', 'Adam Wilbert', '(206)555-1234');
GO

-- enable parameterized value entry in SSMS
-- insert parameterized values
DECLARE @varPhone nvarchar(20) = '(206) 555-1234'
INSERT INTO Customers
VALUES ('2000', 'Adam Wilbert', @varPhone);
GO

SELECT *
FROM Customers
ORDER BY CustomerID;
GO

-- clean up the server instance and remove certificate
USE tempdb;
GO
DROP DATABASE AlwaysEncryptDB;
GO