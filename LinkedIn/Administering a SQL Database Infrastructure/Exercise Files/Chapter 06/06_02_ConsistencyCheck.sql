-- switch databases
USE WideWorldImporters;
GO

-- run a console command
DBCC CHECKDB;
GO

-- CHECKDB runs the following console commands
DBCC CHECKALLOC;
DBCC CHECKTABLE;
DBCC CHECKCATALOG;

-- if errors are identified, repair options are available
-- database must be in single user mode
DBCC CHECKDB ('WideWorldImporters', REPAIR_ALLOW_DATA_LOSS); -- REPAIR_FAST or REPAIR_REBUILD

DBCC CHECKFILEGROUP (0, NOINDEX)
    WITH PHYSICAL_ONLY,
         ESTIMATEONLY;
GO