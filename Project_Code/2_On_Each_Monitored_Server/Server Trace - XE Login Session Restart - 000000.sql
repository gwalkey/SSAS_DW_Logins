USE [msdb]
GO

/****** Object:  Job [Server Trace - XE Login Session Restart - 000000]    Script Date: 10/2/2019 9:08:52 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 10/2/2019 9:08:52 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Server Trace - XE Login Session Restart - 000000', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'ReStart Daily Extended Events Login Trace
Change Target Daily Filename
XEL Files Stored in D:\Traces', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Bounce XE Trace]    Script Date: 10/2/2019 9:08:52 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Bounce XE Trace', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
--- Daily Restart Action

--- Drop Yesterdays target
ALTER EVENT SESSION [Logins] ON SERVER 
DROP TARGET package0.event_file
GO

--- Rename output files based on DOW
IF DATEPART(WEEKDAY,GETDATE())=1
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-Pc\XE_Logins_Sunday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=2
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Monday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=3
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Tuesday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=4
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Wednesday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=5
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Thursday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=6
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Friday.xel'',max_file_size=100, max_rollover_files = 100)

IF DATEPART(WEEKDAY,GETDATE())=7
	ALTER EVENT SESSION [Logins] ON SERVER 
	ADD TARGET package0.event_file(SET filename=N''D:\Traces\OWNER-PC\XE_Logins_Saturday.xel'',max_file_size=100, max_rollover_files = 100)

-- Start the Event Session
ALTER EVENT SESSION [Logins]
ON SERVER 
STATE = START;
GO', 
		@database_name=N'master', 
		@flags=12
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Server Trace - Midnight Start', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20150514, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'b9e00bfa-4fd8-4466-abcf-3e4d49271ba6'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

