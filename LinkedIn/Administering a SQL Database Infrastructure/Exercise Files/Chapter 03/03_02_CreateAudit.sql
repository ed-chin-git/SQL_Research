-- switch to the master database
USE master ;
GO

-- create server audit
CREATE SERVER AUDIT NewSQLAudit
    TO FILE (FILEPATH = 'C:\TempSQL', MAXSIZE = 10MB) -- TO APPLICATION_LOG or TO SECURITY_LOG
    WITH (QUEUE_DELAY = 5000,
         ON_FAILURE = SHUTDOWN -- CONTINUE or FAIL_OPERATION
      -- AUDIT_GUID = uniqueidentifier
        );
GO

-- enable server audit.
ALTER SERVER AUDIT NewSQLAudit
    WITH (STATE = ON);
GO

-- switch to wide world importers
USE WideWorldImporters;
GO

-- create database audit specification.
CREATE DATABASE AUDIT SPECIFICATION AuditWideWorldImporters
    FOR SERVER AUDIT NewSQLAudit
    ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP)
    WITH (STATE = ON);
GO


-- no server clean up for this movie
-- we will examine the log and clean up in the next movie