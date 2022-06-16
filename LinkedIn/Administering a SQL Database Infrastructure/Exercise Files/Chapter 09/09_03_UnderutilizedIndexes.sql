-- switch to the database
USE WideWorldImporters;
GO

SELECT * FROM sys.dm_db_index_usage_stats;
GO

SELECT * FROM sys.indexes;
GO

-- combine with sys.indexes to get index names
SELECT sys.indexes.name, sys.dm_db_index_usage_stats.*
FROM sys.dm_db_index_usage_stats INNER JOIN sys.indexes
    ON sys.dm_db_index_usage_stats.object_id = sys.indexes.object_id;
GO

-- view index statistics on memory optimized tables
SELECT * FROM sys.dm_db_xtp_index_stats;
GO

SELECT sys.indexes.name, sys.dm_db_xtp_index_stats.*
FROM sys.dm_db_xtp_index_stats INNER JOIN sys.indexes
    ON dm_db_xtp_index_stats.object_id = sys.indexes.object_id;
GO