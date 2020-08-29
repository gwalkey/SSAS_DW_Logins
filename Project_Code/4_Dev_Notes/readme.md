<h2>Design Details</h2>

<h3>Idea Genesis</h3>
Original idea came in 2015 after hearing of a SQL Server database compromise and subsequent FBI
and NSA post-mortem evaluation. A DBA woke up to find queries running with his credentials. NOT Cool.

* An APT got on the victims network, sniffed packets, reconned the network, found the SQL Servers and started to run, 
package and upload patient data from inside the firewall

* Post-mortem remediations included
  * Changing passwords on a regular basis
  * Log all SQL access
  * Rework all SQL security from the ground up as initial grant-none
  * Encrypt all SQL traffic on the wire
  * Encrypt all SQL data at rest
  * Encrypt all SQL backups
  * Install foreign app and host detection tools behind the firewall
  * Hire someone to read the security logs

I had the idea that if you could find the the access outliers, you could "find the rogue query", and here we are with this project

<h3>Design Choices</h3>

* The ETL does a typical automatic probe and load of new Dimensions members (Kimball Type 1 only)
* There is no usage of SSIS to load Dimension and Fact tables ...because SQL can do that with the MERGE statment
* There is nothing keeping you from using Azure Analysis Services (except for the higher cost and data transfer times)<br>

The Original design used SSAS Multi-Dimensional

* Why Multidimensional?
* Project Started in 2014 
* My First Data Warehouse
* Tabular still 1.0-ish in 2014
* Didn’t have enough $$$ for memory for Tabular
* Didn’t have enough $$$ for Enterprise Edition
* Learned Data Warehousing using MD and MDX instead of Excel functions (DAX)

<h2> Operational Statistics</h2>

* 35 Million Fact Table Rows
* 25 Billion Logins
* SQL OLAP Database (Both Columnstore Index and Rowstore indexes on Foreign Keys on Fact Table)  - 4GB
* SSAS MD Cube - 300MB
* SSAS Tabular Model - 520MB
* Yes, MD is smaller using MOLAP Storage than xVelocity 
* But Tabular is faster opening and collapsing the Pivot Table drill-down Levels

<h2> Optional Enhancements</h2>

* Power BI Outlier Detection: logins outside norms (name/hour) or(name/host)
* Email Notification of newly arriving Dimension members
* Threshold Alerting (± 2.5 Std Dev) of prior days connections (system hung or dead)
