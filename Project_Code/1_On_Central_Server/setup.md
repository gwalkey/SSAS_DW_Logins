<h2>Central Server Installation Sequence</h2> 

* Install the Central Server Databases
  * OLTP
  * OLAP

* Install the Powershell scripts 
  * (default c:\psscripts) 
  * Enable running of Powershell scripts

* Install the SQL Agent Jobs

* Deploy the SSAS Tabular Model from Source
  * Open the Visual Studio 2017 SSAS Tabular Solution and Deploy it to the Tabular instance of your choice
  * *If your Tabular instance is on the SAME server as your Central Server's SQL engine, you are done
  * If your Tabular instance is NOT on the Central Server runnin the SQL engine, <br>
  you will need to alter the DataSource of the Tabular Model to point to the SQL Database '''ServerTrace_DW'''
