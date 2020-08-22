<h2>Database Setup</h2>
* You can accelerate the system setup step by restoring the 2 SQL and 1 SSAS Tabular Databases<br>
* You might want to delete the sample data in these
* Dont forget to put Non-Clustered Columnstore Index on the Fact Table

<h3>OLTP Database</h3>
Restore the [inbound.bak]

<h3>OLAP Database</h3>
Restore the [ServerTrace_DW.bak]

<h3>SSAS Tabular Database</h3>
Restore the [ServerTrace.abf] to an SSAS Tabular instance
