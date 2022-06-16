-- switch to the database
USE WideWorldImporters;
GO

SELECT PersonID, FullName, PhoneNumber, EmailAddress, IsEmployee
INTO NewPeople
FROM Application.People;
GO

DROP TABLE NewPeople;
DROP TABLE NewPeople2;
GO