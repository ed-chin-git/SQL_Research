-- create a database master key (DMK)
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$trongPassw0rd';
GO

-- create certificate
CREATE CERTIFICATE TDECertificate
    WITH SUBJECT = 'Encryption Certificate';
GO

-- backup everything
BACKUP SERVICE MASTER KEY
    TO FILE = 'C:\TempSQL\SMK.key'
    ENCRYPTION BY PASSWORD = 'BackupPa$$word1';
GO
BACKUP MASTER KEY
    TO FILE = 'C:\TempSQL\DMK.key'
    ENCRYPTION BY PASSWORD = 'BackupPa$$word2';
GO
BACKUP CERTIFICATE TDECertificate
    TO FILE = 'C:\TempSQL\EncryptionCert.cert'
    WITH PRIVATE KEY (
        FILE = 'C:\TempSQL\EncryptionCert.key',
        ENCRYPTION BY PASSWORD = 'BackupPa$$word3'
        );
GO

-- create database and a database encryption key
CREATE DATABASE SampleDB;
GO
USE SampleDB;
GO

CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_128
    ENCRYPTION BY SERVER CERTIFICATE TDECertificate;
GO

-- enable Transparent Data Encryption
ALTER DATABASE SampleDB
SET ENCRYPTION ON;
GO

-- check the state of encrypted databases on the server
SELECT  DB_NAME(Database_id) AS database_name,
        key_algorithm,
        key_length,
        encryption_state,
        percent_complete
FROM sys.dm_database_encryption_keys;
GO

-- verify that data is accessible
SELECT PersonID, FullName, EmailAddress
INTO Employees
FROM WideWorldImporters.Application.People
WHERE IsEmployee = 1;
GO

SELECT *
FROM Employees;
GO

-- backup the database using Object Explorer, then
-- delete the database and clean the server instance
USE master;
GO
DROP DATABASE SampleDB;
GO
DROP CERTIFICATE TDECertificate;
GO
DROP MASTER KEY;
GO

-- restore the database from backup using Object Explorer
-- restore the DMK and Certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$trongPassw0rd';
GO

CREATE CERTIFICATE TDECertificate
    FROM FILE ='C:\TempSQL\EncryptionCert.cert'
    WITH PRIVATE KEY(
            FILE = 'C:\TempSQL\EncryptionCert.key',
            DECRYPTION BY PASSWORD = 'BackupPa$$word3');
GO

-- attempt restoration again using Object Explorer

-- delete the database and clean the server instance
USE master;
GO
DROP DATABASE SampleDB;
GO
DROP CERTIFICATE TDECertificate;
GO
DROP MASTER KEY;
GO