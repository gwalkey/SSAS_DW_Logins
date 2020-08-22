<h1>SSAS_DW_Logins</h1>
SSAS_DW_Logins is a set of Microsoft technologies combined as a SQL Server Security Auditing Tool:<br>
It is a SSAS Tabular Data warehouse with an Excel Front end that allows you to track and analyze SQL Server Logins.

# Components:
* Extended Event Session to track all SQL Server Login events saved to .XEL Files
* ETL Process to move, load and parse the XEL trace files into a central SQL database
* A Transform step to load a DW Star schema database with the tracked Logins
* An SSAS Tabular Model for slide-and-dice analysis
* An Excel Pivot Table to view the historical Logins

# Benefits
This solution allows you to answer questions like
* Who logged in at this hour
* From what Hosts
* What Appllications did they use
* What Databases did they access
* Show me all hosts that access this database
* Why is that app logging in 20,000 times per hour?

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
