You will need to customize these Powershell scripts to match your Central Server

<h2>DMZ_Server_Trace_file_mover.ps1</h2> 
Copies XEL files from DMZ/SQL Auth servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (Mapped Drives)
<pre>
$SourceFolder='K:\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination 'd:\traces\DMZSERVER1' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h2>Domain_Server_Trace_file_mover.ps1</h2> 
Copies XEL files from Domain servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (UNC Paths)
<pre>
$SourceFolder='\\domain_server1\d$\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination 'd:\traces\DOMAINSERVER1' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h2>Delete_all_xel_files.ps1</h2> 
Deletes the XEL files from the default (d:\traces) folder after they are imported to the SQL Databases<br><br>

* Alter the GCI path for the Central Server's default import folder (d:\traces)
<pre>
$Files = gci -path "d:\traces\*.xel" -Recurse | select fullname 
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination 'd:\traces\DOMAINSERVER1' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h2>XEvents_Loader.ps1</h2> 
Performs the loading of the Extended Event Session XEL files into the Trace_Load SQL table

* Alter the version-specific paths of the Extended Events DLLs:
<pre>
# Load Assemblies with Hard-Coded filepath per SQL version you are using
# 130=2016
# 140=2017
# 150=2019
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XE.Core.dll'
Add-Type -Path 'C:\Program Files\Microsoft SQL Server\150\Shared\Microsoft.SqlServer.XEvent.Linq.dll'
</pre>

* Alter the locaton of the XEL Load Folder:
<pre>
$XELFilePath = "d:\traces\"+$ServerName+"\XE_Logins_"+$Yesterday+"*.xel"
</pre>

