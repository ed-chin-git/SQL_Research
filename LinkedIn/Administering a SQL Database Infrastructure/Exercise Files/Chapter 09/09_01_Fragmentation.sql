-- switch to the database
USE WideWorldImporters;
GO

-- copy the data to a new table
SELECT PersonID, FullName, PhoneNumber, EmailAddress, IsEmployee
INTO dbo.NewPeople
FROM Application.People;
GO

ALTER TABLE dbo.NewPeople
ADD CONSTRAINT PK_PersonID PRIMARY KEY CLUSTERED (PersonID);
GO

SELECT * FROM dbo.NewPeople;
GO

CREATE INDEX IX_FullName on dbo.NewPeople(FullName);
GO

-- detect fragmentation on an index
SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID('WideWorldImporters'), OBJECT_ID('dbo.NewPeople'), NULL, NULL , 'DETAILED');
GO

SELECT * FROM sys.indexes
WHERE object_id = <object_id>;
GO

-- for fragmentation between 5% and 30%:
ALTER INDEX IX_FullName
ON dbo.NewPeople
REORGANIZE;

-- for fragmentation above 30%
-- rebuild index to remove fragmentation
-- ALTER INDEX IX_FullName
-- ON dbo.NewPeople
-- REBUILD WITH (ONLINE = ON);

-- review fragmentation stats
SELECT * FROM sys.dm_db_index_physical_stats
    (DB_ID('WideWorldImporters'), OBJECT_ID('dbo.NewPeople'), NULL, NULL , 'DETAILED');
GO

-- clean up the server instance
DROP TABLE dbo.NewPeople;
GO