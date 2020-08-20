USE [inbound]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lkpDBID2Name](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [char](25) NOT NULL,
	[DatabaseID] [int] NOT NULL,
	[DatabaseName] [char](75) NOT NULL,
 CONSTRAINT [PK_lkpDBID2Name_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [NCIX_lkp_Server_DatabaseID] ON [dbo].[lkpDBID2Name]
(
	[ServerName] ASC,
	[DatabaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Trace2](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[DateInteger] [int] NOT NULL,
	[StartHour] [smallint] NOT NULL,
	[ServerName] [varchar](25) NOT NULL,
	[DatabaseName] [varchar](75) NULL,
	[HostName] [varchar](25) NULL,
	[ApplicationName] [varchar](125) NULL,
	[SessionLoginName] [varchar](50) NULL,
 CONSTRAINT [PK_Trace2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [NCIX_Copy_Trace2_to_Trace3] ON [dbo].[Trace2]
(
	[DatabaseName] ASC
)
INCLUDE([DateInteger],[StartHour],[ServerName],[HostName],[ApplicationName],[SessionLoginName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Trace3](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateInteger] [int] NOT NULL,
	[ServerName] [varchar](25) NOT NULL,
	[DatabaseName] [varchar](75) NOT NULL,
	[HostName] [varchar](25) NULL,
	[ApplicationName] [varchar](125) NULL,
	[SessionLoginName] [varchar](50) NULL,
	[StartHour] [smallint] NOT NULL,
	[Connections] [int] NOT NULL,
 CONSTRAINT [PK_Trace3] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[XE_Load](
	[StartTime] [datetime] NULL,
	[DateInteger] [int] NOT NULL,
	[StartHour] [int] NOT NULL,
	[UserName] [varchar](100) NULL,
	[ServerName] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[Hostname] [varchar](100) NULL,
	[ApplicationName] [varchar](255) NULL,
	[SessionLoginName] [varchar](100) NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[XE_Stage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NULL,
	[DateInteger] [int] NOT NULL,
	[StartHour] [int] NOT NULL,
	[UserName] [varchar](100) NULL,
	[ServerName] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[Hostname] [varchar](100) NULL,
	[ApplicationName] [varchar](255) NULL,
	[SessionLoginName] [varchar](100) NULL,
 CONSTRAINT [PK_XE_Stage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XE_Trace_Error](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NULL,
	[DateInteger] [int] NOT NULL,
	[StartHour] [int] NOT NULL,
	[UserName] [varchar](100) NULL,
	[ServerName] [varchar](100) NULL,
	[DatabaseName] [varchar](100) NULL,
	[Hostname] [varchar](100) NULL,
	[ApplicationName] [varchar](255) NULL,
	[SessionLoginName] [varchar](100) NULL,
 CONSTRAINT [PK_XE_Trace_Error] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

