* Install the Central Server Databases
  * Inbound
  * ServerTrace_DW

* Copy the Powershell .ps1 scripts to a folder on your Central Server (default c:\psscripts) and enable running of Powershell scripts

* Install the SQL Agent Jobs

* Open the Visual Studio 2017 SSAS Tabular Solution and Deploy it to the Tabular instance of your choice
 * If your tabular instance is on the SAME server as your Central Server's SQL engine, you are done
 * If your Tabular instance is NOT on the Central Server runnin the SQL engine, <br>
  you will need to alter the DataSource of the Tabular Model to point to the SQL Database '''ServerTrace_DW'''
