h2>Design Details</h2>

* The ETL does a typical automatic probe and load of new Dimensions members(Type 1 only)
* There is no usage of SSIS to load Dimension and Fact tables ...because SQL can do that with the MERGE statment
* There is nothing keeping you from using Azure Analysis Services (except for the higher cost and data transfer times)<br>

<h2> Operational Statistics</h2>
Since this is a one-measure Fact Table, the entire 5 year database I run is still pretty small:

* 35 Million Fact Table Rows
* 25 Billion Logins
* SQL OLAP Database with Clustered Columnstore Index  - 4GB
* SSAS MD Cube - 300MB
* SSAS Tabular Model - 520MB
* Yes, MD is smaller using MOLAP Storage than xVelocity 
* Tabular sometimes is faster opening and collapsing the Pivot Table drill-down Levels

<h2> Optional Enhancements</h2>

* Power BI Outlier Detection: logging in outside norms (name/hour) or(name/host)
* Email Notification of newly arriving Dimension members
* Threshold Alerting (± 2.5 Std Dev) of prior days connections (system hung or dead)
