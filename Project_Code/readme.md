<h1>Setup Instructions<h1>
<h2>On Each Monitored Server</h2>
<h3>Setup the Extended Events Session</h3>
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
</pre>

<h3>Install the SQL Agent job to cycle the XE Session</h3>
In SSMS on your Remote Servers, execute this SQL to create the Agent Job<br>
* Server Trace - XE Login Session Restart - 000000.sql

<h3>Edit the Agent Job - Server Trace - XE Login Session Restart - 000000</h3>
You need to edit all 7 lines in Step 1 that have the '''SET filename=''' sections to point to the XEL folder of your choice<br>
The XE Session is closed and reset every night at Midnight by dropping and recreating the target output XEL file:
<pre>
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
	AD
</pre>


<h2>On the Central Database Server</h2>
<h3>Edit the XEL File Copy Powershell Scripts</h3>
* Domain_Server_Trace_file_mover.ps1<br>
* DMZ_Server_Trace_file_mover.ps1<br>

Edit the $SourceFolder variable to point to the same filepath above on the remote server, but using UNC syntax:
<pre>
# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

$SourceFolder='\\server1\d$\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# XEL Files
Move-Item -Path $FileSpec -Destination d:\traces\domain_server1  -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h3>Create the OLTP Database</h3>
In SSMS on your Central Server, execute these SQL scripts:<br>
 * 01 - Create Inbound Database.sql<br>
 * 02 - Create Inbound DB Tables.sql<br>

<h3>Create the OLAP Database</h3>
In SSMS on your Central Server, execute these SQL scripts:<br>
 * 01 - Create OLAP Database.sql<br>
 * 02 - Create Date Dimension.sql<br>
 * 03 - Create Other Dimension Tables.sql<br>
 * 04 - Create Fact Table.sql<br>

<h3>Install the Powershell Scripts</h3>
Copy the Powershell script to a folder on your central server<br>
C:\PSScripts is the default<br>
 * Delete_all_xel_files.ps1<br>
 * DMZ_Server_Trace_file_mover.ps1<br>
 * Domain_Server_Trace_file_mover.ps1<br>
 * XEvents_Loader.ps1<br>

<h3>Install the SQL Agent Jobs</h3>
In SSMS on your Central Server, execute these SQL scripts:<br>
 * Server Trace - Step 1 - Truncate Work Tables - Daily - 0001.sql<br>
 * Server Trace - Step 2 - Copy Trace Files up from Source Servers.sql<br>
 * Server Trace - Step 3 - Import XE Trace Files.sql<br>
 * Server Trace - Step 4 - Clean XE Data.sql<br>
 * Server Trace - Step 5 - Populate and Process SSAS MD Cube.sql<br>
 * Server Trace - Step 6 - Backup Server SSAS Databases.sql<br>

<h3>Edit the SQL Agent Jobs</h3>
Finally, we need to edit the ETL agent jobs to suit our environment:<br>
* Edit Job 3 () and create a Step for each Remote Server's XEL Files you plan to import
Change the '''Owner-PC''' powershell Script parameter to point to the sub folder in D:\traces\server1<br>
that hold the XEL files for that server:
A Mutli-server setup will have this XEL file structure on your Central Server:
D:\traces\server1<br>
D:\traces\server2<br>
D:\traces\server3<br>
D:\traces\server4<br>

In this case, the new Job 3 () Steps would be
<pre>
powershell.exe c:\psscripts\xe\XEvents_Loader.ps1 Server1
</pre>
