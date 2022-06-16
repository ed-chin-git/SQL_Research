-- switch to the database
USE WideWorldImporters;
GO

-- list all event session definitions
SELECT * FROM sys.server_event_sessions;

-- return a row for each event in an event session
SELECT * FROM sys.server_event_session_events;

-- ... filtered to just the system_health extended event
SELECT * FROM sys.server_event_session_events
WHERE event_session_id = 65536;

-- ... filtered to the telemetry_xevents extended event
SELECT * FROM sys.server_event_session_events
WHERE event_session_id = 66304;

-- return a row for each action on the system_health event
SELECT * FROM sys.server_event_session_actions
WHERE event_session_id = 65536;