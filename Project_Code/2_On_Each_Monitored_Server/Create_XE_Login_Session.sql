CREATE EVENT SESSION [Logins] ON SERVER 
ADD EVENT sqlserver.login(SET collect_database_name=(1)
    ACTION(package0.collect_system_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.nt_username,sqlserver.server_instance_name,sqlserver.session_nt_username,sqlserver.username)
    WHERE ([sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[client_app_name],N'Microsoft SQL Server Management Studio - Transact-SQL IntelliSense') AND NOT [sqlserver].[like_i_sql_unicode_string]([sqlserver].[client_app_name],N'SQLAgent%')))
ADD TARGET package0.event_file(SET filename=N'D:\Traces\XE_Logins_Dummy.xel',max_file_size=(100),max_rollover_files=(100))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO

ALTER EVENT SESSION [Logins]
ON SERVER 
STATE = START;
GO