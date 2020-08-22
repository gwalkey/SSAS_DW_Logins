<h2>Install SQL Agent Jobs</h2> 

Install each SQL Agent Job using SSMS

The first job, [Server Trace - Step 1 - Truncate Work Tables - Daily - 0001.sql] starts on a minute-after-midnight 0001 Schedule

The SQL Agent Jobs call the next one in the chain

* Server Trace - Step 1 - Truncate Work Tables - Daily - 0001.sql
* Server Trace - Step 2 - Copy Trace Files up from Source Servers.sql
* Server Trace - Step 3 - Import XE Trace Files.sql
* Server Trace - Step 4 - Clean XE Data.sql
* Server Trace - Step 5 - Populate and Process SSAS Tabular Model.sql

As a Step 6, you should create your own Tabular Backup Job using TMSA and scheduling it as a SSAS Command Job step type
<pre>
Server: Localhost
{
  "backup": {
    "database": "ServerTrace",
    "file": "c:\\SQLBackups\\ServerTrace_Tabular.abf",
    "allowOverwrite": true,
    "applyCompression": true
  }
}

</pre>

<h2>Customize the Agent Jobs</h2> 
Next, you will need to customize the Jobs as such:

<h3>Server Trace - Step 3 - Import XE Trace Files</h3>
This Job has one step for each remote server's XEL that you are importing<br>
If you are importing 20 Server's XEL files, this Job will have one Step for each Server

* Import Yesterdays XE Data for Domain Server 1
Alter the XEvents_Loader script's parameter as such:
<pre>
powershell.exe c:\psscripts\xe\XEvents_Loader.ps1 Server1
</pre>

* Import Yesterdays XE Data for Domain Server 2
Alter the XEvents_Loader script's parameter as such:
<pre>
powershell.exe c:\psscripts\xe\XEvents_Loader.ps1 Server2
</pre>

