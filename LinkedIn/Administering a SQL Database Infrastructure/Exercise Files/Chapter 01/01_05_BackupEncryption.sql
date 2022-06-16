-- create a new database for this example
CREATE DATABASE BackupExampleDB;
GO
USE master;
GO

-- create master key and certificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1$trongPassword';
GO

CREATE CERTIFICATE BackupDBCert
    WITH SUBJECT = 'ExampleDB Backup Certificate';
GO

-- export backup certificate to a file
BACKUP CERTIFICATE BackupDBCert TO FILE = 'C:\TempSQL\BackupDBCert.cert'
    WITH PRIVATE KEY (
        FILE = 'C:\TempSQL\BackupDBCert.key',
        ENCRYPTION BY PASSWORD = 'AnotherPassw0rd'
        );
GO

-- backup database with encryption
BACKUP DATABASE BackupExampleDB
    TO DISK = 'C:\TempSQL\BackupExampleDB.bak'
    WITH ENCRYPTION (
        ALGORITHM = AES_256,
        SERVER CERTIFICATE = BackupDBCert
        );
GO

-- clean up the instance
DROP DATABASE BackupExampleDB;
GO
DROP CERTIFICATE BackupDBCert;
GO

-- restore the database from backup
RESTORE DATABASE BackupExampleDB
    FROM DISK = 'C:\TempSQL\BackupExampleDB.bak';
GO

-- restore the certificate
CREATE CERTIFICATE BackupDBCert
    FROM FILE = 'C:\TempSQL\BackupDBCert.cert'
    WITH PRIVATE KEY (FILE = 'C:\TempSQL\BackupDBCert.key',
    DECRYPTION BY PASSWORD = 'AnotherPassw0rd');
GO

-- attempt the restore again

-- clean up the instance
DROP DATABASE BackupExampleDB;
GO
DROP CERTIFICATE BackupDBCert;
GO
DROP MASTER KEY;
GO
