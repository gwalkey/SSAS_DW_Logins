<h1>A SQL Server SSAS Tabular Model for tracking SQL Server Logins</h1>
SSAS DW Logins is a set of Microsoft technologies combined into a SQL Server Security Auditing Tool<br>

# Attention SQL SATURDAY  Salt Lake 2020 Peeps:
Look forward to seeing you Today!

# Components:
* Extended Event Session to track all SQL Server Login events saved to .XEL Files
* ETL Process to move, load, clean and aggregate the XEL trace files from remote SQL servers into a central SQL database
* A Transform step to load a DW Star schema database with the tracked Logins
* An SSAS Tabular Model for slide-and-dice analysis
* A sample Excel Pivot Table to view the historical Logins

# Benefits
This solution allows you to answer questions like
* Who logged in
* From what Hosts
* At what Time
* What Application did they use
* What Databases did they access
* Show me all hosts that access a certain database
* Show me all access for any person
* Why is that app logging in 20,000 times per hour?
* Connection string tracking

# ETL Performance
* Using sys.fn_xe_file_target_read_file = 11 Hours
* Using XEvent.Linq.dll and XECore.dll assemblies - 11 Minutes

Using the XEvent.Linq.dll and XECore.dll assemblies, we can load over 1M events per minute
![alt text](https://raw.githubusercontent.com/gwalkey/SSAS_DW_Logins/master/Import_Library_Comparison.jpg)

# Inspiration by
* Romans Chapter 8 - https://classic.biblegateway.com/passage/?search=romans+8&version=AMPC
* Rachmaninoff - https://youtu.be/vpaPWuDQUcc
* Mozart - https://youtu.be/Rb0UmrCXxVA
* Lizst - https://youtu.be/salrwSVWpC4
* Late Night Alumni - https://www.youtube.com/playlist?list=PLtZ9dBSEHSuCxOJ_oUypS1EvhX0MwCQf5

# Sample Report
![alt text](https://raw.githubusercontent.com/gwalkey/SSAS_DW_Logins/master/DW_Logins_Excel_Model.jpg)
