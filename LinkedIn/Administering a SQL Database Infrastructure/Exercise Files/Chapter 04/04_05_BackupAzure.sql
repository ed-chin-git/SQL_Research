-- create a new database and certificate
USE master;
GO
CREATE DATABASE LandonHotelDB;
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1$trongPassword';
GO

CREATE CERTIFICATE BackupDBCert
    WITH SUBJECT = 'LandonHotelDB Backup Certificate';
GO

-- clean up the server
DROP CERTIFICATE BackupDBCert;
GO
DROP MASTER KEY;
GO
DROP DATABASE LandonHotelDB;
GO