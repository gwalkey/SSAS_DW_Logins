<h2>Install Powershell Scripts</h2> 
The SQL Agent Jobs call the Powershell scripts from these default folders

<h3>Install File Movers</h3>
Make a Folder on your Central Server (default path is c:\psscripts\trace_file_movers) and copy these files there:
 * DMZ_Server_Trace_file_mover.ps1
 * Delete_all_xel_files.ps1
 * Domain_Server_Trace_file_mover.ps1

<h3>Install XE Loader</h3>
Make a Folder on your Central Server (default path is c:\psscripts\XE) and copy these files there:
 * XEvents_Loader.ps1
  
<h2>XEL Trace File Subfolders</h2>
Make a set of subfolders to hold the XEL files copied up from each server<br>
The XEL Loader will look here for XEL input<br>
 * D:\Traces\DomainServer1
 * D:\Traces\DomainServer2
 * D:\Traces\DomainServer3
 * D:\Traces\DMZServer1

<h2>Customize the Powershell scripts</h2> 
Next, you will need to customize the Powershell scripts

<h3>DMZ_Server_Trace_file_mover.ps1</h3> 
Copies XEL files from DMZ/SQL Auth servers to your Central Server's import folder (d:\traces by default)<br><br>
 * Add a section for each remote server using (Mapped Drives)
<pre>
# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

$SourceFolder='K:\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# Create PShell Credential
$pass="NotaGreatPassword"|ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PsCredential("DMZSERVER1\dba",$pass)

# Create PShell Drive to point to dmz server share
New-PSDrive -name K  -PSProvider FileSystem -Credential $Cred -scope Script -root \\dmzserver1\traces

# Move Sql Trace Files from DMZ machine for import
Move-Item -Path $filespec -Destination d:\traces\DMZSERVER1 -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

set-location c:

Remove-PSDrive -name K
</pre>

<h3>Domain_Server_Trace_file_mover.ps1</h3> 
Copies XEL files from Domain/WinAuth servers to your Central Server's import folder (d:\traces by default)<br><br>
* Add a section for each remote server using (UNC Paths)
<pre>
# Get Day of Week for Yesterday
[string]$Day = ((get-date).AddDays(-1)).DayOfWeek

# Server 1
$SourceFolder='\\domain_server1\d$\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# XE Files
Move-Item -Path $FileSpec -Destination d:\traces\DomainServer1  -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue

# Server 2
$SourceFolder='\\domain_server2\d$\traces\'
$FileSpec = $SourceFolder+'XE_Logins_'+$Day+'*.xel'
Write-Output('{0}' -f $Filespec)

# XE Files
Move-Item -Path $FileSpec -Destination d:\traces\DomainServer2  -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h3>Delete_all_xel_files.ps1</h3> 
Deletes the XEL files from the default (d:\traces) folder after they are imported to the SQL Databases<br><br>

* Alter the GCI path for the Central Server's default import folder (d:\traces)
<pre>
$Files = gci -path "d:\traces\*.xel" -Recurse | select fullname 
</pre>

<h3>XEvents_Loader.ps1</h3> 
Performs the loading of the Extended Event Session XEL files into the [XE_Load] SQL table<br><br>

* Alter the version-specific paths of the Extended Events DLLs:
<pre>
# Load Assemblies with Hard-Coded filepath per SQL version you are using
# 130=SQL2016
# 140=SQL2017
# 150=SQL2019
# 160=SQL2022
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XE.Core.dll'
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XEvent.Linq.dll'
</pre>

* Alter the locaton of the XEL Load Folder:
<pre>
$XELFilePath = "d:\traces\"+$ServerName+"\XE_Logins_"+$Yesterday+"*.xel"
</pre>

