<#
.SYNOPSIS
	Parses Extended Event Session XEL Trace Files using SQL Server Library DLLs and [QueryableXEventData]
	
.DESCRIPTION
    This runs on the Central Server, importing all the XEL session files from all your Monitored Servers
	A SQL Agent Step copies all the XEL Files to a XEL Folder such as D:\Traces with a subfolder per Server

.EXAMPLE
 	
.EXAMPLE
 
.EXAMPLE
 
.Inputs
   
.Outputs

.NOTES
   
.LINK
    https://blogs.msdn.microsoft.com/extended_events/2011/07/20/introducing-the-extended-events-reader/
    https://dba.stackexchange.com/questions/206863/what-is-the-right-tool-to-process-big-xel-files-sql-server-extended-events-log?rq=1
#>


[CmdletBinding()]
Param(
    [parameter(Position=0,mandatory=$false,ValueFromPipeline)]
    [ValidateNotNullOrEmpty()]
    [string]$ServerName='localhost'

)

Set-StrictMode -Version latest;
   
# Load Assemblies with Hard-Coded filepath per SQL version you are using
# 130=2016
# 140=2017
# 150=2019
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XE.Core.dll'
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XEvent.Linq.dll'

$CentralServer='localhost'

# Clear out BulkCopy Load Table
try
{
    $SQLConnectionString = "Data Source=$CentralServer;Initial Catalog=inbound;Integrated Security=SSPI;"
    $Connection = New-Object System.Data.SqlClient.SqlConnection
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $Connection.ConnectionString = $SQLConnectionString
    $Connection.Open()
    $SqlCmd.Connection = $Connection
    $SqlCmd.CommandTimeout=0
    $SqlCmd.CommandText = "TRUNCATE TABLE [inbound].[dbo].[XE_Load]"

    # Execute statement
    $ExecResponse = $SqlCmd.ExecuteNonQuery()

    # Close Conn
    $Connection.Close()

}
catch
{
    Throw('Error Truncating XE_Load Table:{0}' -f $error[0])
}

# Create Datatable for SqlBulkCopy below
$dt = New-Object System.Data.DataTable
$col1 = New-object system.Data.DataColumn StartTime,([datetime])
$col2 = New-object system.Data.DataColumn DateInteger,([int])
$col3 = New-object system.Data.DataColumn StartHour,([int])
$col4 = New-object system.Data.DataColumn UserName,([string])
$col5 = New-object system.Data.DataColumn ServerName,([string])
$col6 = New-object system.Data.DataColumn DatabaseName,([string])
$col7 = New-object system.Data.DataColumn Hostname,([string])
$col8 = New-object system.Data.DataColumn ApplicationName,([string])
$col9 = New-object system.Data.DataColumn SessionLoginName,([string])
$dt.columns.add($col1)
$dt.columns.add($col2)
$dt.columns.add($col3)
$dt.columns.add($col4)
$dt.columns.add($col5)
$dt.columns.add($col6)
$dt.columns.add($col7)
$dt.columns.add($col8)
$dt.columns.add($col9)

# Get Yesterday's Name
[string]$Yesterday = (get-date).AddDays(-1).DayOfWeek

# Setup to Import
$XELFilePath = "d:\traces\"+$ServerName+"\XE_Logins_"+$Yesterday+"*.xel"
Write-Output('Import all XEL Files from [{0}]' -f $XELFilePath)

# Import the Daily XEL Files
$Stopwatch1 = [system.diagnostics.stopwatch]::StartNew()
$Events = new-object Microsoft.SqlServer.XEvent.Linq.QueryableXEventData($XELFilePath)
$Stopwatch1.stop()
Write-output("XEL Events Loaded into Memory Duration: {0:N0}:{1}:{2}.{3:00}" -f $Stopwatch1.elapsed.Hours, $Stopwatch1.Elapsed.Minutes, $Stopwatch1.Elapsed.Seconds, $Stopwatch1.Elapsed.Milliseconds)

# Setup BulkCopy Object
$bcp = New-Object System.Data.SqlClient.SqlBulkCopy("Data Source=$CentralServer;Initial Catalog=inbound;Integrated Security=SSPI",[System.Data.SqlClient.SqlBulkCopyOptions]::TableLock)
$bcp.DestinationTableName = "dbo.XE_Load"

# Read and BulkCopy Events up to SQL in batches of 10000
Write-Output('Read and BulkCopy Events up to SQL in batches of 10000')
[long]$eventCount = 0
$Stopwatch = [system.diagnostics.stopwatch]::StartNew()
foreach($event in $Events) 
{
    $eventCount += 1
    $row = $dt.NewRow()

    # Parse out the XE Trace columns we are interested in
    $row["StartTime"]        = $event.Timestamp.LocalDateTime
    $row["DateInteger"]      = [int]$($event.Timestamp.LocalDateTime.Year)*10000+[int]$($event.Timestamp.LocalDateTime.month)*100+[int]$($event.Timestamp.LocalDateTime.day)
    $row["StartHour"]        = [int]$event.Actions["collect_system_time"].Value.LocalDateTime.Hour
    
    # If SQL Auth Actions property [username] is missing, keep going
    $ErrorActionPreference = "SilentlyContinue"
    $row["UserName"]         = [string]$event.Actions["username"].Value
    $row["ServerName"]       = [string]$event.Actions["server_instance_name"].Value
    $row["DatabaseName"]     = [string]$event.Actions["database_name"].Value
    $row["Hostname"]         = [string]$event.Actions["client_hostname"].Value
    $row["ApplicationName"]  = [string]$event.Actions["client_app_name"].Value
    $row["SessionLoginName"] = [string]$event.Actions["session_nt_username"].Value
    $dt.Rows.Add($row)
    $ErrorActionPreference = "Continue"

    # Bulk the batch into SQL
    if($eventCount % 10000 -eq 0) {
        $bcp.WriteToServer($dt)
        $dt.Rows.Clear()
        Write-output("SQL BulkCopy {0:N0} Events" -f $eventcount)
    }

}

# write last batch up
$bcp.WriteToServer($dt)
$bcp.Close()

$Stopwatch.stop()
Write-output("{0:N0} Read, Parse and Bulk Copy Duration: {1}:{2}:{3}.{4:00}" -f $eventCount,$Stopwatch.elapsed.Hours, $Stopwatch.Elapsed.Minutes, $Stopwatch.Elapsed.Seconds, $Stopwatch.Elapsed.Milliseconds)

# Move Rows from Load to Stage Table
Write-Output('Moving Loaded Rows to XE_Stage')
$SQLText1=
"
INSERT INTO XE_Stage
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
SELECT
	[StartTime],
    [DateInteger],
    [StartHour],
    [UserName],
    [ServerName],
    [DatabaseName],
    [Hostname],
    [ApplicationName],
    [SessionLoginName]
from XE_Load
"

try
{
    $SQLConnectionString = "Data Source=$CentralServer;Initial Catalog=inbound;Integrated Security=SSPI;"
    $Connection = New-Object System.Data.SqlClient.SqlConnection
    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $Connection.ConnectionString = $SQLConnectionString
    $Connection.Open()
    $SqlCmd.Connection = $Connection
    $SqlCmd.CommandTimeout=0
    $SqlCmd.CommandText = $SQLText1

    # Execute statement
    $ExecResponse = $SqlCmd.ExecuteNonQuery()

    # Close Conn
    $Connection.Close()
}
catch
{
    Write-Output('Error Moving Loaded Rows to XE_Stage Table: {0}' -f $error[0])
}
