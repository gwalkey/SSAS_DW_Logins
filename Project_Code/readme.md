<h1>Setup Instructions<h1>
<h2>On Each Monitored Server</h2>
<h3>Setup the Extended Events Session<h3>
Install the XE Session below on each server you wish to monitor<br>
Make sure to the edit the file path for the target output XEL file<br>

When the server lays down the XEL file every day, the file-copy PoSH script that runs on the Central Server(here)<br>
https://github.com/gwalkey/SSAS_DW_Logins/blob/master/Project_Code/1_On_Central_Server/03_Powershell_Files/Domain_Server_Trace_file_mover.ps1
will also need to be updated to use the same filepath, but using a UNC syntax instead such as:<br>
<pre>
\\server1\d$\traces\
</pre>

In the XE Session below, edit the '''SET filename=''' section:
<pre>
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
</pre>

<h2>On the Central Database Server<h2>
<h3>Edit the XEL File Copy Powershell Script<h3>

Edit the section here to her to the same filepath above, but in a UNC syntax:
<pre>
# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

$SourceFolder='\\server1\d$\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# XEL Files
Move-Item -Path $FileSpec -Destination d:\traces\domain_server1  -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

