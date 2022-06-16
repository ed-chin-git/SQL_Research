-- view the status of the test message
SELECT * FROM msdb.dbo.sysmail_allitems
WHERE mailitem_id = <mailitem_id> ;
GO

-- view the event log
SELECT * FROM msdb.dbo.sysmail_event_log
WHERE mailitem_id = <mailitem_id> ;
GO