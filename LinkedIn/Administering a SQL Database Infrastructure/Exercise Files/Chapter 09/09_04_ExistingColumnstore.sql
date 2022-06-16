-- switch to the database
USE WideWorldImporters;
GO

SELECT * FROM sys.indexes;
GO

-- select just the clustered indexes
SELECT * FROM sys.indexes
WHERE type IN(5,6);
GO

-- combine with sys.indexes to get index names
SELECT sys.indexes.name, sys.indexes.type, sys.dm_db_index_usage_stats.*
FROM sys.dm_db_index_usage_stats INNER JOIN sys.indexes
    ON sys.dm_db_index_usage_stats.object_id = sys.indexes.object_id
WHERE sys.indexes.type IN(5,6);
GO

-- view partitions
SELECT * FROM sys.partitions;
GO

SELECT * FROM sys.partitions
WHERE object_id = 510624862;
GO

-- view columnstore segments
SELECT * FROM sys.column_store_segments;
GO

SELECT sys.column_store_segments.*
FROM sys.column_store_segments INNER JOIN sys.partitions ON sys.partitions.partition_id = sys.column_store_segments.partition_id
WHERE sys.partitions.object_id = 510624862;
GO

SELECT * FROM sys.dm_db_column_store_row_group_physical_stats