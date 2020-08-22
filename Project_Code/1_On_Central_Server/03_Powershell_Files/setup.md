<h2>Install Powershell Scripts</h2> 
First, make a Folder on your Central Server (default path is c:\psscripts) and copy these files there:
* DMZ_Server_Trace_file_mover.ps1
* Delete_all_xel_files.ps1
* Domain_Server_Trace_file_mover.ps1

Make a Subfolder (c:\psscripts\trace_file_movers) and copy this file there:
* XEvents_Loader.ps1

The SQL Agnet Jobs call the Powershell scripts from these default folders

<h2>Customize the Powershell scripts</h2> 
Next, you will need to customize these Powershell scripts to match your Central Server

<h3>DMZ_Server_Trace_file_mover.ps1</h3> 
Copies XEL files from DMZ/SQL Auth servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (Mapped Drives)
<pre>
$SourceFolder='K:\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination 'd:\traces\DMZSERVER1' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h3>Domain_Server_Trace_file_mover.ps1</h3> 
Copies XEL files from Domain servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (UNC Paths)
<pre>
$SourceFolder='\\domain_server1\d$\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination 'd:\traces\DOMAINSERVER1' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h3>Delete_all_xel_files.ps1</h3> 
Deletes the XEL files from the default (d:\traces) folder after they are imported to the SQL Databases<br><br>

* Alter the GCI path for the Central Server's default import folder (d:\traces)
<pre>
$Files = gci -path "d:\traces\*.xel" -Recurse | select fullname 
</pre>

<h3>XEvents_Loader.ps1</h3> 
Performs the loading of the Extended Event Session XEL files into the Trace_Load SQL table<br><br>

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

