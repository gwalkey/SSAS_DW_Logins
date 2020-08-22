You will need to customize all the Powershell scripts to match your Central Server drives

<h2> DMZ_Server_Trace_file_mover.ps1</h2>
Copies XEL files from DMZ/SQL Auth server to your Central Server's import folder (d:\traces by default)<br>
* Alter the Source location:
<pre>
$SourceFolder='K:\traces\'
</pre>

*  Alter the Destination Folder:
<pre>
Move-Item -Path $filespec -Destination '''d:\traces\DMZSERVER1''' -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
</pre>
