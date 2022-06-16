-- switch to the database
USE WideWorldImporters;
GO

-- add a column to hold encrypted data
ALTER TABLE Sales.Customers
ADD CreditCard Varbinary(max);
GO

SELECT CustomerID, CustomerName, CreditCard
FROM Sales.Customers
WHERE CustomerID = 1;
GO

-- create symmetric key
CREATE SYMMETRIC KEY CreditCardKey
WITH ALGORITHM = AES_128
ENCRYPTION BY PASSWORD = '$trongPassw0rd';
GO

-- add an encrypted credit card, then view data
UPDATE Sales.Customers
SET CreditCard = (EncryptByKey(Key_GUID('CreditCardKey'),'5555-1234-5678-0000'))
WHERE CustomerID = 1;
GO

-- open the key, then add the card again
OPEN SYMMETRIC KEY CreditCardKey
DECRYPTION BY PASSWORD = '$trongPassw0rd';
GO

-- view the data
SELECT CustomerID, CustomerName, CreditCard
FROM Sales.Customers
WHERE CustomerID = 1;
GO

-- view the decrypted data
SELECT CustomerID, CustomerName,
    CONVERT (char(19), DecryptByKey(CreditCard)) AS CreditCardNumber
FROM Sales.Customers
WHERE CustomerID = 1;
GO

-- close the key and view decrypted data
CLOSE SYMMETRIC KEY CreditCardKey;
GO

-- create key with a certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'NewPa$sw0rd';
GO
CREATE CERTIFICATE EncryptionCertificate
    WITH SUBJECT = 'Encryption Certificate';
GO
CREATE SYMMETRIC KEY CreditCardKeyCert
    WITH ALGORITHM = AES_128
    ENCRYPTION BY CERTIFICATE EncryptionCertificate;
GO

-- open the new key
OPEN SYMMETRIC KEY CreditCardKeyCert
DECRYPTION BY CERTIFICATE EncryptionCertificate;
GO

-- close the key
CLOSE SYMMETRIC KEY CreditCardKeyCert;
GO

-- remove certificate
DROP CERTIFICATE EncryptionCertificate;
GO

-- reset the database to its original state
ALTER TABLE Sales.Customers
DROP COLUMN CreditCard;
GO
DROP SYMMETRIC KEY CreditCardKey;
GO
DROP SYMMETRIC KEY CreditCardKeyCert;
GO
DROP CERTIFICATE EncryptionCertificate;
GO
DROP MASTER KEY;
GO