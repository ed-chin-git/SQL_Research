-- switch to WideWorldImporters
USE WideWorldImporters;
GO

-- select data
SELECT * FROM Warehouse.Stockitems;
GO

SELECT * FROM Warehouse.Stockitems
WHERE LeadTimeDays = 3;
GO

CREATE USER WarehouseStockPicker WITHOUT LOGIN;
GO
GRANT SELECT ON Warehouse.Stockitems TO WarehouseStockPicker;
GO

EXECUTE AS USER = 'WarehouseStockPicker';
GO
SELECT USER_NAME();
GO

SELECT * FROM Warehouse.Stockitems
WHERE SupplierID = 1;
GO

-- switch back to DBO
REVERT;
GO

-- check the audit log
SELECT * FROM fn_get_audit_file('C:\TempSQL\*',default,default);
GO

-- filter the log
SELECT * FROM fn_get_audit_file('C:\TempSQL\*',default,default)
WHERE action_id = 'IMP';
GO

-- cleanup the server instance
DROP USER WarehouseStockPicker;
GO

ALTER DATABASE AUDIT SPECIFICATION AuditWideWorldImporters
    WITH (STATE = OFF);
GO

DROP DATABASE AUDIT SPECIFICATION AuditWideWorldImporters;
GO

USE Master;
GO

ALTER SERVER AUDIT NewSQLAudit
    WITH (STATE = OFF);
GO

DROP SERVER AUDIT NewSQLAudit;
GO

-- remove the .sqlaudit files from the C:\TempSQL folder as well