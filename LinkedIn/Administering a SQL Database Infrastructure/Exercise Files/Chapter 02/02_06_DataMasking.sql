-- switch to the database
USE WideWorldImporters;
GO

-- copy the data to a new table
SELECT PersonID, FullName, PhoneNumber, EmailAddress, IsEmployee
INTO NewPeople
FROM Application.People;
GO

SELECT * FROM NewPeople;
GO

CREATE USER SalesManager WITHOUT LOGIN;
GO

GRANT SELECT ON NewPeople TO SalesManager;
GO

-- apply data masking
ALTER TABLE NewPeople ALTER COLUMN FullName
    ADD MASKED WITH (FUNCTION = 'partial(1, "***",3)');
ALTER TABLE NewPeople ALTER COLUMN PhoneNumber
    ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE NewPeople ALTER COLUMN EmailAddress
    ADD MASKED WITH (FUNCTION = 'email()');
ALTER TABLE NewPeople ALTER COLUMN IsEmployee
    ADD MASKED WITH (FUNCTION = 'default()');
GO

-- view results as DBO
SELECT * FROM NewPeople;
GO

-- change security context and check
EXECUTE AS USER = 'SalesManager';
SELECT USER_NAME();
GO
SELECT * FROM NewPeople;
GO
REVERT;
GO

-- give sales manager unmask permission
GRANT UNMASK TO SalesManager;
GO

-- deny unmask to sales manager
DENY UNMASK TO SalesManager;
GO

-- limitations of Dynamic Data Masking
SELECT * FROM Application.People;
GO

ALTER TABLE Application.People ALTER COLUMN FullName
    ADD MASKED WITH (FUNCTION = 'default()');
ALTER TABLE Application.People ALTER COLUMN Searchname
    ADD MASKED WITH (FUNCTION = 'default()');

-- clean up the server instance
ALTER TABLE NewPeople ALTER COLUMN FullName DROP MASKED;
DROP TABLE NewPeople;
DROP USER SalesManager;
GO