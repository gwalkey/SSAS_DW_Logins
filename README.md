# 
SSAS_DW_Logins is a set of MS technologies combined as a SQL Server Security/Auditing Tool:<br>
It is a SSAS Tabular Data warehouse with an Excel Front end to track and analyze SQL Server Logins.

# Components:
1) Extended Event Session to track all SQL Server Login events and save to an .XEL File
2) ETL Process to move, load and parse the XEL trace files into a central SQL database
3) A Transform step to load a DW Star schema database with the tracked Logins
4) An SSAS Tabular Model for slide-and-dice analysis
5) An Excel Pivot Table to view the historical Logins

# Benefits
This solution allows you to answer questions like
* Who logged in at this hour
* From what Hosts
* What Appllications did they use
* What Databases did they access
* Show me all hosts that access this database
* Why is that app logging in 20,000 times per hour?

# ETL Performance
* sys.fn_xe_file_target_read_file = 11 Hours
* XEvent.Linq.dll and XECore.dll assemblies - 11 Minutes

Using the XEvent.Linq.dll and XECore.dll assemblies, we can load over 1M events per minute
![alt text](https://raw.githubusercontent.com/gwalkey/SSAS_DW_Logins/master/Import_Library_Comparison.jpg)

# Inspiration by
* Romans Chapter 8 - https://classic.biblegateway.com/passage/?search=romans+8&version=AMPC
* Rachmaninoff - https://www.youtube.com/watch?v=vpaPWuDQUcc&t=98s
* Lizst - https://www.youtube.com/watch?v=salrwSVWpC4&t=51s
* Saint-Saens- https://www.youtube.com/watch?v=eH-R6wl-dMU&t=15s
* Late Night Alumni - https://www.youtube.com/playlist?list=PLtZ9dBSEHSuCxOJ_oUypS1EvhX0MwCQf5

# Sample Report
![alt text](https://raw.githubusercontent.com/gwalkey/SSAS_DW_Logins/master/DW_Logins_Excel_Model.jpg)
