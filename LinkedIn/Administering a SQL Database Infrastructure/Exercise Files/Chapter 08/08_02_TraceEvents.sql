-- switch to the database
USE WideWorldImporters;
GO

-- list all traces in the server
SELECT * FROM sys.traces;
GO

-- view everything a trace can track
SELECT * FROM sys.trace_events;
GO

-- view what the default trace is tracking
SELECT t.EventID, e.name as Event_Description
  FROM sys.fn_trace_geteventinfo(1) t
  JOIN sys.trace_events e ON t.eventID = e.trace_event_id
  GROUP BY t.EventID, e.name;
GO

-- copy trace contents into temporary table
SELECT * INTO #DefaultTraceTempTable
FROM fn_trace_gettable('C:\Program Files\Microsoft SQL Server\MSSQL13.SQL_2016\MSSQL\Log\log_29.trc', default);
GO

-- query the trace results
SELECT * FROM #DefaultTraceTempTable;
GO

-- create a more specific query
SELECT TextData, StartTime, DatabaseName
FROM #DefaultTraceTempTable
WHERE DatabaseName = 'WideWorldImporters';
GO

-- create a live trace in profiler
-- execute query
SELECT * FROM Sales.Invoices;
GO