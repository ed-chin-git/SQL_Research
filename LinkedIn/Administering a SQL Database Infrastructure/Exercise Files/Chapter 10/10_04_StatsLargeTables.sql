-- switch to the database
USE WideWorldImporters;
GO

-- update stats by scanning all records
UPDATE STATISTICS Application.People IX_Application_People_FullName
WITH FULLSCAN;
GO

-- update stats by sampling records
UPDATE STATISTICS Application.People IX_Application_People_FullName
WITH SAMPLE 10 PERCENT;  -- 50 ROWS
GO