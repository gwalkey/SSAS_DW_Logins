USE [msdb]
GO

/****** Object:  Job [Server Trace - Step 5 - Populate and Process SSAS Tabular Model]    Script Date: 8/28/2020 10:14:04 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 8/28/2020 10:14:04 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Server Trace - Step 5 - Populate and Process SSAS Tabular Model', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Add new members to Dimensions, 
Add Measure data to Fact Table, 
Process SSAS Dimensions and Cube', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1a - Add New Members to Server Dimension]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1a - Add New Members to Server Dimension', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---------------------------------------------
--- ADD NEW DIMENSIONS - TYPE 1 - no updates
-----------------------------------------------
--- Server
set nocount on
declare @mycount int
declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)

MERGE [ServerTrace_DW].[dbo].[Dim_ServerName] AS [Target]
USING (select distinct ServerName from [inbound].[dbo].[Trace3] 
	where 
	dateinteger=@myDateInteger and 
	ServerName is not null) AS [Source]
   ON Target.ServerName = Source.ServerName
WHEN NOT MATCHED BY TARGET
    THEN INSERT
	(
		ServerName
    )
	VALUES
	(
		Source.ServerName
    );
', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1b - Add New Members to Database Dimension]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1b - Add New Members to Database Dimension', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---------------------------------------------
--- ADD NEW DIMENSIONS - TYPE 1 - no updates
-----------------------------------------------
set nocount on
--- Database
declare @mycount int
declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)

MERGE [ServerTrace_DW].[dbo].[Dim_DatabaseName] AS [Target]
USING (select distinct DatabaseName from [inbound].[dbo].[Trace3] 
	where 
	dateinteger=@myDateInteger and 
	DatabaseName is not null) AS [Source]
   ON Target.DatabaseName = Source.DatabaseName
WHEN NOT MATCHED BY TARGET
    THEN INSERT
	(
		DatabaseName
    )
	VALUES
	(
		Source.DatabaseName
    );
', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1c - Add New Members to Host Dimension]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1c - Add New Members to Host Dimension', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------
--- ADD NEW DIMENSIONS - TYPE 1 - no updates
-----------------------------------------------
set nocount on
--- Host
declare @mycount int
declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)

MERGE [ServerTrace_DW].[dbo].[Dim_HostName] AS [Target]
USING (select distinct HostName from [inbound].[dbo].[Trace3] 
	where 
	dateinteger=@myDateInteger and 
	HostName is not null and Hostname <>'''')  AS [Source]
   ON Target.HostName = Source.HostName
WHEN NOT MATCHED BY TARGET
    THEN INSERT
	(
		HostName
    )
	VALUES
	(
		Source.HostName
    );
', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1d - Add New Members to SessionLoginName Dimension]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1d - Add New Members to SessionLoginName Dimension', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---------------------------------------------
--- ADD NEW DIMENSIONS - TYPE 1 - no updates
-----------------------------------------------
set nocount on
declare @mycount int
declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)


--- SessionLoginName

MERGE [ServerTrace_DW].[dbo].[Dim_SessionLoginName] AS [Target]
USING (select distinct SessionLoginName from [inbound].[dbo].[Trace3] 
	where 
	dateinteger=@myDateInteger and 
	SessionLoginName is not null) AS [Source]
   ON Target.SessionLoginName = Source.SessionLoginName
WHEN NOT MATCHED BY TARGET
    THEN INSERT
	(
		SessionLoginName
    )
	VALUES
	(
		Source.SessionLoginName
    );
', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1e - Add New Members to ApplicationName Dimension]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1e - Add New Members to ApplicationName Dimension', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---------------------------------------------
--- ADD NEW DIMENSIONS - TYPE 1 - no updates
-----------------------------------------------
--- Server
set nocount on
declare @mycount int
declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)

--- ApplicationName

MERGE [ServerTrace_DW].[dbo].[Dim_ApplicationName] AS [Target]
USING (select distinct ApplicationName from [inbound].[dbo].[Trace3] 
	where 
	dateinteger=@myDateInteger and 
	ApplicationName is not null and ApplicationName<>'''') AS [Source]
   ON Target.ApplicationName = Source.ApplicationName
WHEN NOT MATCHED BY TARGET
    THEN INSERT
	(
		ApplicationName
    )
	VALUES
	(
		Source.ApplicationName
    );

', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 2 - Populate DW Cube Fact Table from Inbound Trace3 Hourly Aggregates]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 2 - Populate DW Cube Fact Table from Inbound Trace3 Hourly Aggregates', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'---- Load Fact Table from Daily Trace3 table
--- This Method does the FK Lookup during INSERT

declare @yesterday [date]
set @yesterday = dateadd(dd,-1,getdate())
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@yesterday)*10000+datepart(mm,@yesterday)*100+datepart(dd,@yesterday)

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;

insert into Fact_Trace
(
     DateID,
     HourID,
     HostNameID,
     DataBaseNameID,
     ApplicationNameID,
     SessionLoginNameID,
     ServerNameID,
     Connections
)
select
     (select coalesce((select top 1 ID from Dim_Date d1 where d1.[DateInteger]= oltp.DateInteger),1)) as ''TraceDate'', --- ServiceDate
     (select coalesce((select top 1 ID from Dim_Hour d1 where d1.[Hour] = oltp.StartHour),-2)) as ''startHour'',
     (select coalesce((select top 1 ID from Dim_HostName d2 where d2.[Hostname] = oltp.[HostName]),-2)) as ''HostName'',
     (select coalesce((select top 1 ID from Dim_DataBaseName d2 where d2.[DataBaseName] = oltp.[DataBaseName]),-2)) as ''DataBaseName'',
     (select coalesce((select top 1 ID from Dim_ApplicationName d2 where d2.[ApplicationName] = oltp.[ApplicationName]),-2)) as ''ApplicationName'',
     (select coalesce((select top 1 ID from Dim_SessionLoginName d2 where d2.[SessionLoginName] = oltp.[SessionLoginName]),-2)) as ''SessionLoginName'',
     (select coalesce((select top 1 ID from Dim_ServerName d2 where d2.[ServerName] = oltp.[ServerName]),-2)) as ''ServerName'',
     oltp.Connections -- get Counts later (by hour of the day)
from 
     [inbound].[dbo].[Trace3] OLTP
where 
     OLTP.DateInteger = @myDateInteger
', 
		@database_name=N'ServerTrace_DW', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 10 - Process Tabular Model - Fact Table]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 10 - Process Tabular Model - Fact Table', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'ANALYSISCOMMAND', 
		@command=N'{
  "refresh": {
    "type": "full",
    "objects": [
      {
        "database": "ServerTrace",
        "table": "Fact_Trace"
      }
    ]
  }
}', 
		@server=N'HPZ820', 
		@database_name=N'ServerTrace', 
		@flags=8
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 11 - Process Tabular Model - Database]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 11 - Process Tabular Model - Database', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'ANALYSISCOMMAND', 
		@command=N'{
  "refresh": {
    "type": "full",
    "objects": [
      {
        "database": "ServerTrace"
      }
    ]
  }
}', 
		@server=N'localhost', 
		@database_name=N'master', 
		@flags=8
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Call Next Job - Backup Tabular Model]    Script Date: 8/28/2020 10:14:04 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Call Next Job - Backup Tabular Model', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_start_job N''Server Trace - Step 6 - Backup Server SSAS Databases'';', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


