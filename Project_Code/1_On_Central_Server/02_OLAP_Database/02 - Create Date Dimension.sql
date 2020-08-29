USE [ServerTrace_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_Date](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DimDate] [date] NOT NULL,
	[DateInteger] [int] NOT NULL,
	[DayofWeek] [tinyint] NULL,
	[DayofWeekName] [varchar](10) NULL,
	[DayofMonth] [tinyint] NULL,
	[DayofYear] [smallint] NULL,
	[Month] [tinyint] NULL,
	[MonthName] [varchar](10) NULL,
	[WeekofYear] [tinyint] NULL,
	[Month Year] [varchar](25) NULL,
	[Year] [smallint] NULL,
	[Quarter] [tinyint] NULL,
	[IsHoliday] [bit] NULL DEFAULT ((0)),
	[HolidayDescription] [varchar](30) NULL,
	[IsWeekDay] [bit] NULL DEFAULT ((0)),
	[LastDayofWeek] [bit] NULL DEFAULT ((0)),
	[LastDayofMonth] [bit] NULL DEFAULT ((0)),
	[UTCOffset] [tinyint] NULL DEFAULT ((5)),
	[QuarterName] [varchar](10) NULL,
 CONSTRAINT [PK_Dim_Date] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO



-- Insert The UNKNOWN Member Row
SET IDENTITY_INSERT [dbo].[Dim_Date] ON
insert into [dbo].[Dim_Date] (
	ID,
	[DimDate],
	[DateInteger],
	[DayofWeek],
	[DayofWeekName],
	[DayofMonth],
	[DayofYear],
	[Month],
	[MonthName],
	[WeekofYear],
	[Month Year],
	[Year],
	[Quarter],
	[IsHoliday],
	[HolidayDescription],
	[IsWeekDay],
	[LastDayofWeek],
	[LastDayofMonth] ,
	[UTCOffset],
	[QuarterName]
)
values (
-2,
'01-01-1900',
19000101,
0,
'Unknown',
0,
0,
0,
'Unknown',
0,
'Unknown',
0,
0,
0,
'Unknown',
0,
0,
0,
0,
'Unknown'
)
SET IDENTITY_INSERT [dbo].[Dim_Date] OFF

--- Create Temp Numbers Table
set nocount on

CREATE TABLE dbo.Numbers 
( 
    Number INT IDENTITY(1,1) PRIMARY KEY CLUSTERED 
) 
 
WHILE COALESCE(SCOPE_IDENTITY(), 0) <= 1000000
BEGIN 
    INSERT dbo.Numbers DEFAULT VALUES 
END

--- Fast Population of DimDate using Numbers table and DATEADD Fctn
INSERT dbo.Dim_Date(DimDate,DateInteger)
SELECT DATEADD(DAY, Number, '19991231'), 
	    datepart(yyyy,DATEADD(DAY, Number, '19991231'))*10000+datepart(mm,DATEADD(DAY, Number, '19991231'))*100+datepart(dd,DATEADD(DAY, Number, '19991231'))
        FROM dbo.Numbers 
        WHERE Number <= 36890 --create days out to 12-31-2100
        ORDER BY Number

--- Update the DimDate Attribute fields
update dbo.dim_Date
Set 
	[DayofWeek] = datepart(dw,DimDate),
	[DayofWeekName] = datename(dw,DimDate),
	[DayofMonth] = datepart(dd,DimDate),
	[DayofYear] = datepart(dy,DimDate),
	[Month] = datepart(mm,DimDate),
	[MonthName] = datename(mm,DimDate),
	[Month Year] = datename(mm,DimDate) + ' ' + datename(yyyy, DimDate),
	[WeekofYear] = datepart(wk,DimDate),	
	[Year] = datepart(yy,DimDate),
	[Quarter] = datepart(qq,DimDate),
	[IsWeekDay] = CASE WHEN DATEPART(dw, DimDate) IN (1,7) THEN 0 ELSE 1 END,
	[LastDayofWeek] = IIF(datepart(dw,DimDate)=7, 1, 0),
	[LastDayofMonth] = IIF(convert(date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,DimDate)+1,0)))=DimDate, 1, 0),
	[QuarterName] = cast(datepart(yy,DimDate) as varchar)+ ' - Q'+cast(datepart(qq,DimDate) as varchar)
where ID>0


-----------------------------------
--- Flag  American Holidays as such
-----------------------------------
--- Christmas
UPDATE dbo.Dim_Date SET isHoliday=1, HolidayDescription = 'Christmas Day' WHERE [Month] = 12 AND [DayOfMonth] = 25 and ID>0

--- New Years
UPDATE dbo.Dim_Date SET isHoliday=1, HolidayDescription = 'New Years Day' WHERE [Month] = 1 AND [DayOfMonth] = 1 and ID>0

--- 4th of July
UPDATE dbo.Dim_Date SET isHoliday=1, HolidayDescription = '4th of July' WHERE [Month] = 7 AND [DayOfMonth] = 4 and ID>0

--- Memorial Day
UPDATE dbo.Dim_Date
    SET
        isHoliday = 1,
		HolidayDescription = 'Memorial Day'
    FROM dbo.Dim_Date c1
    WHERE [Month] = 5
    AND [DayofWeek] = 2
    AND NOT EXISTS (SELECT 1 FROM dbo.Dim_Date c2
        WHERE [Month] = 5 AND [DayofWeek] = 2
        AND c2.[Year] = c1.[Year]
        AND c2.DimDate > c1.dimDate)
	AND ID >0

--- Labor Day
UPDATE dbo.Dim_Date
    SET 
        isHoliday = 1, 
        HolidayDescription = 'Labor Day' 
    FROM dbo.Dim_Date c1 
    WHERE [Month] = 9 
    AND [DayofWeek] = 2 
    AND NOT EXISTS (SELECT 1 FROM dbo.Dim_Date c2 
        WHERE [Month] = 9 AND [DayofWeek] = 2 
        AND c2.[Year] = c1.[Year] 
        AND c2.DimDate < c1.DimDate)
	AND ID >0

--- Thanksgiving
UPDATE dbo.Dim_date
    SET 
        isHoliday = 1, 
        HolidayDescription = 'Thanksgiving Thursday' 
    FROM dbo.Dim_Date c1 
    WHERE [Month] = 11
    AND [DayofWeek] = 5 
    AND (SELECT COUNT(*) FROM dbo.Dim_Date c2 
        WHERE [Month] = 11 AND [DayofWeek] = 5 
        AND c2.[Year] = c1.[Year]
        AND c2.DimDate < c1.DimDate) = 3 
	AND ID >0

7USE [ServerTrace_DW]
GO

--- Helps OLAP INSERT Step
CREATE NONCLUSTERED INDEX [NCIX_Date_Integer] ON [dbo].[Dim_Date]
(
	[DateInteger] ASC
) ON [PRIMARY]
GO

--- Make Sure Date Column stays Unique
create unique nonclustered index [IDX_DimDate] on [Dim_Date] (DimDate)
GO
