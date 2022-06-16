-- view status of statistics maintenance
SELECT name, is_auto_create_stats_on, is_auto_update_stats_on
FROM sys.databases;

-- enable statistics maintenance
ALTER DATABASE WideWorldImporters
SET AUTO_CREATE_STATISTICS ON;
GO

-- view status of asynchronous statistics update
SELECT name, is_auto_update_stats_async_on
FROM sys.databases;