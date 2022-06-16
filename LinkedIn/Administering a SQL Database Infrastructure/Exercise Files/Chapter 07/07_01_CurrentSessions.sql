-- switch to the database
USE WideWorldImporters;
GO

-- explore active sessions
EXEC sp_who;

EXEC sp_who 'ACTIVE' -- or login name or session ID

-- view sessions through dynamic management views
SELECT * FROM sys.dm_exec_sessions;

SELECT * FROM sys.dm_exec_connections;

-- report on acitve sessions