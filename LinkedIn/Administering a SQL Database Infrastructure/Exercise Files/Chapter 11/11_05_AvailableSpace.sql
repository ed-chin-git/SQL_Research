SELECT * FROM sys.master_files;
GO

SELECT name, database_id, file_id, physical_name, size
FROM sys.master_files
ORDER BY database_id, file_id;
GO

SELECT * FROM sys.dm_os_volume_stats (database_id, file_id);
GO

SELECT DISTINCT DB_NAME(v.database_id) DBName,
                v.database_id AS DatabaseID,
                v.file_id AS FileID,
                m.physical_name FilePath,
                CONVERT(INT,m.size*8/1024) AS CurrentSizeMB,
                CONVERT(INT,v.available_bytes/1048576) AS AvailableMB
FROM sys.master_files m
CROSS APPLY sys.dm_os_volume_stats(m.database_id, m.FILE_ID) v
ORDER BY DBName;
GO