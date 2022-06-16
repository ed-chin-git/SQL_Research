-- create a new database
CREATE DATABASE RecoveryModelDB;
GO

USE RecoveryModelDB;
GO

-- set the recovery model in SSMS

-- review the recovery model with T-SQL

SELECT name, recovery_model_desc
   FROM sys.databases
   WHERE name = 'RecoveryModelDB';
GO

SELECT name, recovery_model_desc
   FROM sys.databases
   WHERE name = 'model';
GO

-- change the recovery model
ALTER DATABASE RecoveryModelDB SET RECOVERY SIMPLE;
GO

-- clean up the server
USE TempDB;
GO
DROP DATABASE RecoveryModelDB;
GO