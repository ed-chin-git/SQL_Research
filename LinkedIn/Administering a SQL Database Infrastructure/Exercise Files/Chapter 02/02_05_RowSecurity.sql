-- switch to the database
USE WideWorldImporters;
GO

-- explore the data - note IsEmployee column
SELECT * FROM Application.People;
GO

CREATE USER HumanResources WITHOUT LOGIN;
GO

GRANT SELECT ON Application.People TO HumanResources;

-- change security context and check
EXECUTE AS USER = 'HumanResources';
SELECT USER_NAME();
GO
SELECT * FROM Application.People;
GO

REVERT;
GO
SELECT USER_NAME();
GO

-- create a new schema to hold our predicate function
CREATE SCHEMA Security;
GO

-- create predicate function to restrict rows
CREATE FUNCTION Security.EmployeeRLS(@IsEmployee int)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN (SELECT 1 AS AccessResult
        WHERE @IsEmployee = 1 OR USER_NAME() = 'dbo');
GO

-- test the function
SELECT * FROM Security.EmployeeRLS(1);
SELECT * FROM Security.EmployeeRLS(0);
SELECT * FROM Security.EmployeeRLS(7);
GRANT SELECT ON SCHEMA :: Security TO HumanResources;
EXECUTE AS USER = 'HumanResources';
REVERT;

-- create security policy
CREATE SECURITY POLICY FilterPeopleByEmployeeStatus
ADD FILTER PREDICATE Security.EmployeeRLS(IsEmployee)
ON Application.People,
ADD BLOCK PREDICATE Security.EmployeeRLS(IsEmployee)
ON Application.People AFTER UPDATE;
GO

-- change security context and check
EXECUTE AS USER = 'HumanResources';
SELECT USER_NAME();
GO
SELECT * FROM Application.People;
GO

-- toggle the state of the security filter
REVERT;
GO

ALTER SECURITY POLICY FilterPeopleByEmployeeStatus
WITH (STATE = OFF);
GO

ALTER SECURITY POLICY FilterPeopleByEmployeeStatus
WITH (STATE = ON);
GO

-- clean up the server instance
DROP SECURITY POLICY FilterPeopleByEmployeeStatus;
DROP FUNCTION Security.EmployeeRLS;
DROP SCHEMA Security
DROP USER HumanResources;
GO