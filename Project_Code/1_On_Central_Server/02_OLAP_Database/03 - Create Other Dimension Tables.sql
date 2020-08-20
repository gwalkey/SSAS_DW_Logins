USE [ServerTrace_DW]
GO

--- ServerName
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_ServerName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](25) NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Dim_ServerName_DateCreated]  DEFAULT (dateadd(day,(-1),getdate())),
 CONSTRAINT [PK_Dim_ServerName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

set identity_insert Dim_ServerName on 
insert into [dbo].[Dim_ServerName]
(
ID,
ServerName
)
values
(
-2,
'Unknown'
)

set identity_insert Dim_ServerName off

CREATE UNIQUE NONCLUSTERED INDEX [NCIX_ServerName_No_Dupes] ON [dbo].[Dim_ServerName]
(
	[ServerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO



---DataBaseName
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_DatabaseName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [varchar](75) NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Dim_DatabaseName_DateCreated]  DEFAULT (dateadd(day,(-1),getdate())),
 CONSTRAINT [PK_Dim_DatabaseName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

set identity_insert Dim_DatabaseName on
insert into [dbo].[Dim_DatabaseName]
(
ID,
DatabaseName
)
values
(
-2,
'Unknown'
)
set identity_insert Dim_DatabaseName off

SET ANSI_PADDING OFF
GO

CREATE UNIQUE NONCLUSTERED INDEX [NCIX_DatabaseName_No_Dupes] ON [dbo].[Dim_DatabaseName]
(
	[DatabaseName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


--- HostName
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_Hostname](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HostName] [varchar](25) NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Dim_Hostname_DateCreated]  DEFAULT (dateadd(day,(-1),getdate())),
 CONSTRAINT [PK_Dim_Hostname] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

set identity_insert Dim_HostName on
insert into [dbo].[Dim_Hostname]
(
ID,
HostName
)
values
(
-2,
'Unknown'
)
set identity_insert Dim_HostName off


SET ANSI_PADDING OFF
GO

CREATE UNIQUE NONCLUSTERED INDEX [NCIX_Hostname_No_Dupes] ON [dbo].[Dim_Hostname]
(
	[HostName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO



--- ApplicationName
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_ApplicationName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationName] [varchar](125) NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Dim_ApplicationName_DateCreated]  DEFAULT (dateadd(day,(-1),getdate())),
 CONSTRAINT [PK_Dim_ApplicationName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

set identity_insert Dim_ApplicationName on
insert into [dbo].[Dim_ApplicationName]
(
ID,
ApplicationName
)
values
(
-2,
'Unknown'
)
set identity_insert Dim_ApplicationName off


CREATE UNIQUE NONCLUSTERED INDEX [NCIX_ApplicationName_No_Dupes] ON [dbo].[Dim_ApplicationName]
(
	[ApplicationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO




--- SessionLoginName
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dim_SessionLoginName](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SessionLoginName] [varchar](50) NOT NULL,
	[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Dim_SessionLoginName_DateCreated]  DEFAULT (dateadd(day,(-1),getdate())),
 CONSTRAINT [PK_Dim_SessionLoginName] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

set identity_insert Dim_SessionLoginName on
insert into [dbo].[Dim_SessionLoginName]
(
ID,
SessionLoginName
)
values
(
-2,
'Unknown'
)
set identity_insert Dim_SessionLoginName off



SET ANSI_PADDING OFF
GO


CREATE UNIQUE NONCLUSTERED INDEX [NCIX_SessionLoginName] ON [dbo].[Dim_SessionLoginName]
(
	[SessionLoginName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


-- Dim Hour of Day
USE [ServerTrace_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Dim_Hour](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Hour] [int] NULL,
 CONSTRAINT [PK_Dim_Hour] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO dbo.Dim_Hour
(
    Hour
)
VALUES
(0),
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23)
