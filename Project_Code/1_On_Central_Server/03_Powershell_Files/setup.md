You will need to customize all the Powershell scripts to match your Central Server drives

<h2>DMZ_Server_Trace_file_mover.ps1</h2> 
Copies XEL files from DMZ/SQL Auth servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (Mapped Drives)
<pre>
$SourceFolder='K:\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination '''d:\traces\DMZSERVER1''' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>

<h2>Domain_Server_Trace_file_mover.ps1</h2> 
Copies XEL files from Domain servers to your Central Server's import folder (d:\traces by default)<br><br>

* Alter the Source location for the XEL files from each remote server: (UNC Paths)
<pre>
$SourceFolder='\\domain_server1\d$\traces\'
</pre>

* Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination '''d:\traces\DOMAINSERVER1''' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>
