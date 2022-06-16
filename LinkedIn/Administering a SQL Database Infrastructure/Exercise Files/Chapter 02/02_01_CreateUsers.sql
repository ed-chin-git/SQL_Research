-- switch to the database
USE WideWorldImporters;
GO

SELECT	USER_NAME() AS 'Database User Name',
		SUSER_SNAME() AS 'Server Login',
		HOST_NAME() AS 'Computer Name',
		APP_NAME() AS 'Client Application';
GO

-- create user at the SQL Server login level, then add to the database
CREATE USER HR FOR LOGIN HumanResources;
GO

-- create additional loginless users
CREATE USER WarehouseSupervisor WITHOUT LOGIN;
CREATE USER WarehouseManager WITHOUT LOGIN;
CREATE USER SalesAssociate WITHOUT LOGIN;
CREATE USER SalesManager WITHOUT LOGIN;
CREATE USER PurchasingAnalyst WITHOUT LOGIN;
GO

-- switch security contexts
EXECUTE AS USER = 'WarehouseManager';
GO

-- check the current security context
SELECT USER_NAME();

-- switch back to DBO account
REVERT

-- assign schemas and roles through Object Explorer

-- check permissions of a user
EXECUTE AS USER = 'WarehouseSupervisor';
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');
REVERT;
GO

EXECUTE AS USER = 'WarehouseSupervisor';
SELECT * FROM fn_my_permissions ('Warehouse.StockItems', 'OBJECT');
REVERT;
GO

EXECUTE AS USER = 'WarehouseManager';
SELECT * FROM fn_my_permissions ('Warehouse.StockItems', 'OBJECT');
REVERT;
GO

-- remove the user account and reset the database
ALTER AUTHORIZATION ON SCHEMA::Warehouse to dbo 
DROP USER HR;
DROP USER WarehouseSupervisor;
DROP USER WarehouseManager;
DROP USER SalesAssociate;
DROP USER SalesManager;
DROP USER PurchasingAnalyst;
GO

-- remove the HumanResources server login