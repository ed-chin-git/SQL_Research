-- switch to the database
CREATE DATABASE QueryStoreDB;
GO
USE QueryStoreDB;
GO

-- enable query store
ALTER DATABASE QueryStoreDB SET QUERY_STORE = ON;
GO

USE WideWorldImporters;
GO

-- query the status of query store
SELECT * FROM sys.database_query_store_options;
GO

-- clean up the instance
USE tempDB;
GO
DROP DATABASE QueryStoreDB;
GO