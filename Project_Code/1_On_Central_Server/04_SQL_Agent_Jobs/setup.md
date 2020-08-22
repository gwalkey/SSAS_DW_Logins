Install each SQL Agent Job using SSMS

The first job, [Server Trace - Step 1 - Truncate Work Tables - Daily - 0001.sql] starts on a midnight 0000 Schedule

The SQL Agent Jobs call the next one in the chain

* Server Trace - Step 1 - Truncate Work Tables - Daily - 0001.sql
* Server Trace - Step 2 - Copy Trace Files up from Source Servers.sql
* Server Trace - Step 3 - Import XE Trace Files.sql
* Server Trace - Step 4 - Clean XE Data.sql
* Server Trace - Step 5 - Populate and Process SSAS MD Cube.sql

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
