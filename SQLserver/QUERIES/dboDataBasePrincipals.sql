 /* https://blog.sqlauthority.com/2019/03/04/sql-server-fix-database-diagram-error-15517-cannot-execute-as-the-database-principal-because-the-principal-dbo-does-not-exist/ */
USE AdventureWorks2019
GO
SELECT SUSER_SNAME(sid), * from sys.database_principals