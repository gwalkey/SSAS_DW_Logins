USE [msdb]
GO

/****** Object:  Job [Server Trace - Step 4 - Clean XE Data]    Script Date: 9/9/2019 10:09:41 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 9/9/2019 10:09:41 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Server Trace - Step 4 - Clean XE Data', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Cleanup Data in XE_Stage Table
Copy Relevant Trace Columns into Trace2
Aggregate Trace2 Row Counts by Hour into Trace3
Trace3 will be loaded into the DW Relational Fact Table', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 1 - XE_Stage - Fixup Blank SessionLoginName with UserName]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 1 - XE_Stage - Fixup Blank SessionLoginName with UserName', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'update XE_Stage
set SessionLoginName = UserName
where (SessionLoginName is null or SessionLoginName='''') and UserName is not null', 
		@database_name=N'inbound', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 2 - XE_Stage - Fixup Blank Host and Application Fields for Known Apps]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 2 - XE_Stage - Fixup Blank Host and Application Fields for Known Apps', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--- SQL Agent Job Steps
UPDATE	
    dbo.XE_Stage
SET
    ApplicationName=''SQLAgent - TSQL JobStep''
WHERE	
    ApplicationName LIKE ''SQLAgent - TSQL JobStep %''

--- SQL Profiler
UPDATE	
    dbo.XE_Stage
SET
    ApplicationName=''SQL Server Profiler''
WHERE	
    ApplicationName LIKE ''SQL Server Profiler - %''

--- Red Gate SQL Prompt
UPDATE	
    inbound.dbo.XE_Stage
SET
    ApplicationName=''Red Gate Software Ltd SQL Prompt''
WHERE	
    ApplicationName LIKE ''Red Gate Software Ltd SQL Prompt %''

--- IIS App Pools
UPDATE	
    inbound.dbo.XE_Stage
SET
    ApplicationName=''w3wp app pool''
WHERE	
    ApplicationName LIKE ''w3wp@/LM/W3SVC/2/ROOT%''

--- DatabaseMail
update
     [inbound].[dbo].[XE_Stage]
set
     ApplicationName = ''DatabaseMail''
where 
     ApplicationName like ''DatabaseMail%''

', 
		@database_name=N'inbound', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 3 - XE_Stage - Copy any remaining Empty Elements to XE_Trace_Error table for further review]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 3 - XE_Stage - Copy any remaining Empty Elements to XE_Trace_Error table for further review', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'declare @mycount int

insert into [XE_Trace_Error]
(
    [StartTime],
    [DateInteger],
    [StartHour],
    [UserName],
    [ServerName],
    [DatabaseName],
    [Hostname],
    [ApplicationName],
    [SessionLoginName]
)
select 

    [StartTime],
    [DateInteger],
    [StartHour],
    [UserName],
    [ServerName],
    [DatabaseName],
    [Hostname],
    [ApplicationName],
    [SessionLoginName]
FROM 
	XE_stage WITH (NOLOCK)
WHERE 
	(Hostname is null or Hostname='''') OR
	(SessionLoginName IS NULL OR SessionLoginName='''') OR
	(ServerName IS NULL OR ServerName='''') OR
	(ApplicationName IS NULL OR ApplicationName='''')

set @mycount = @@rowcount

DECLARE @filename NVARCHAR(1000);
DECLARE @ReportHTML  NVARCHAR(MAX);
DECLARE @body nvarchar(max);
DECLARE @Subject NVARCHAR (250);
DECLARE @DL VARCHAR(1000);
SET @DL = ''Super.Dba@company.com''

--- Build the subject line with server and instance name
SET @Subject = ''SERVER Trace - XE Import Errors Remain''


--- Send email to distribution list.     
if @mycount>0
begin
	SET @ReportHTML =
    N''<H1>Server Trace - XE Import Empty Errors Remain: ''+ convert(varchar,@mycount) + '' rows in XE_Trace_Error table</H1>'' +
    N''<h2>Import Errors</h2>''+
    N''<table border="1">'' +
    N''<tr>''+
	N''<th>StartTime</th>'' +
    N''<th>DateInteger</th>'' +
    N''<th>StartHour</th>'' +
    N''<th>UserName</th>'' +
    N''<th>ServerName</th>'' +
    N''<th>DatabaseName</th>'' +
	N''<th>Hostname</th>'' +
	N''<th>ApplicationName</th>'' +
	N''<th>SessionLoginName</th>'' +
	    CAST((
	
		SELECT 
			td = [StartTime],'''',
			td = [DateInteger], '''',
			td = [StartHour], '''',
			td = COALESCE([UserName],'' ''), '''',
			td = COALESCE([ServerName],'' ''),'''',
			td = COALESCE([DatabaseName],'' ''),'''',
			td = coalesce([Hostname],'' ''),'''',
			td = COALESCE([ApplicationName],'' ''),'''',
			td = COALESCE([SessionLoginName],'' ''),''''
		from 
			[inbound].[dbo].[xe_trace_error]
		
		



        FOR XML PATH(''tr''), TYPE 
		) AS NVARCHAR(MAX) 
	) +
    N''</table>'';



--- Send email to distribution list.	
EXEC msdb.dbo.sp_send_dbmail 
           @recipients=@DL,
           @subject = @Subject,  
           @body =@ReportHTML,
           @body_format = ''HTML''


end

--- Delete From Prod Table
DELETE
FROM 
     XE_stage
WHERE 
	(Hostname is null or Hostname='''') OR
	(SessionLoginName IS NULL OR SessionLoginName='''') OR
	(ServerName IS NULL OR ServerName='''') OR
	(ApplicationName IS NULL OR ApplicationName='''')

', 
		@database_name=N'inbound', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 4 - Trace2 - Load cleaned data from XE_Stage into Trace2]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 4 - Trace2 - Load cleaned data from XE_Stage into Trace2', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--- DROP Index B4 ETL
ALTER INDEX [NCIX_Copy_Trace2_to_Trace3] ON [dbo].[Trace2] DISABLE

--- Copy Yesterdays Extended Events Login Data
--- Minimally logged ON
DBCC TRACEON(610);

INSERT INTO dbo.Trace2 with (tablock)
(
	[StartTime],
	[DateInteger],
	[StartHour],
	[ServerName],
	[DatabaseName],
	[Hostname],
	[ApplicationName],
	[SessionLoginName]
)
SELECT
	StartTime,
	dateinteger,
	Starthour,
	[ServerName],
	[DatabaseName],
	[Hostname],
	[ApplicationName],
	[SessionLoginName]
FROM 
	dbo.XE_Stage

--- MLI OFF
DBCC TRACEOFF(610);

--- Rebuild Index
USE [inbound]
GO
ALTER INDEX [NCIX_Copy_Trace2_to_Trace3] ON [dbo].[Trace2] REBUILD PARTITION = ALL 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100)
GO
', 
		@database_name=N'inbound', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 5 - Trace3 - Generate Hourly Totals to Prep for Fact Table Loading]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 5 - Trace3 - Generate Hourly Totals to Prep for Fact Table Loading', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=4, 
		@on_success_step_id=7, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--- Generate Previous Days Connection Count Totals


--- Copy Todays Login-Only Trace Data
declare @Yesterday [date]
set @Yesterday = dateadd(dd,-1,getdate())


--- Group Counts by Server/DB/Host/Login/App/Hour
declare @myDateInteger int
set @myDateInteger = datepart(yyyy,@Yesterday)*10000+datepart(mm,@Yesterday)*100+datepart(dd,@Yesterday)

--- Minimally logged ON
DBCC TRACEON(610);

insert into Trace3
(
    [DateInteger],
    [ServerName],
    [DatabaseName],
    [HostName],
    [ApplicationName],
    [SessionLoginName],
    [StartHour],
    [Connections]
)
select 
	DateInteger
	,Servername
	,DatabaseName
	,HostName
	,ApplicationName
	,SessionLoginname
	,Starthour
	,count(*) as ''Connections''
FROM 
	[inbound].[dbo].[Trace2]
where 
	databasename is not null 
group by 
	DateInteger
	,Servername
	,DatabaseName
	,HostName
	,ApplicationName
	,SessionLoginname
	,Starthour



--- MLI OFF
DBCC TRACEOFF(610);
', 
		@database_name=N'inbound', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Step 6 - Delete all XEL Files]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Step 6 - Delete all XEL Files', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell.exe c:\psscripts\trace_file_movers\Delete_all_xel_files.ps1', 
		@flags=40
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Call Next Job - Server Trace - Populate and Process SSAS Cube]    Script Date: 9/9/2019 10:09:41 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Call Next Job - Server Trace - Populate and Process SSAS Cube', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_start_job N''Server Trace - Step 5 - Populate and Process SSAS Tabular Model'';', 
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

