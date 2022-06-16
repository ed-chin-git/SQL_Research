-- switch to the database
USE WideWorldImporters;
GO

DBCC SHOW_STATISTICS ("Application.People", "IX_Application_People_FullName");
GO

DBCC SHOW_STATISTICS ("Application.People", "IX_Application_People_IsEmployee");
GO

SELECT * FROM sys.dm_db_stats_properties (object_id('Application.People'), 1);
GO

SELECT sp.stats_id, name, filter_definition, last_updated, rows, rows_sampled, steps, unfiltered_rows, modification_counter
FROM sys.stats AS stat
CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
WHERE stat.object_id = object_id('Application.People');

--update all stats in the database
EXEC sp_updatestats;

-- update stats on a specific table
UPDATE STATISTICS Application.People;

-- update stats for a specific index
UPDATE STATISTICS Application.People IX_Application_People_FullName;