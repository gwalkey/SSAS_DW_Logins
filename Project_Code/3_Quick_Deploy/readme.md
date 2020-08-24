<h2>Quick Deploy</h2>

* You can accelerate the system setup by restoring the SQL and SSAS Tabular Databases instead of building them from scratch<br>
* Once restored, you should delete the sample SQL data in the <b>ServerTrace_DW</b> Database tables and re-process the Tabular Model
* All SQL Agent Jobs, Posh Scripts and Tabular Model connections default to '''localhost'''
* The default installation has SQL and SSAS Tabular installed on the same box

<h3>OLTP Database</h3>
Restore the [inbound.bak]

<h3>OLAP Database</h3>
Restore the [ServerTrace_DW.bak]

<h3>SSAS Tabular Database</h3>
Restore the [ServerTrace.abf] to an SSAS Tabular instance

<h2>Tabular Model to SQL Connections</h2>

* Create a SQL Login and User that will be used by the Tabular Model to connect to ServerTrace_DW (or run the Model as Impersonate SQL service)
* You must get the Tabular Model to talk to the SQL database (ServerTrace_DW) before the SQL Agent jobs automatically ETL and prep the SSAS Model
