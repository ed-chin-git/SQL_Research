-- switch to the Azure database
USE AzureSQLDatabase;
GO

-- try to create database audit specification
CREATE DATABASE AUDIT SPECIFICATION AuditAzureSQLDatabase
    FOR SERVER AUDIT NewSQLAudit
    ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP)
    WITH (STATE = ON);
GO

-- create audit in Azure Portal