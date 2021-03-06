USE [ServerTrace_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Fact_Trace](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateID] [int] NOT NULL,
	[HourID] [int] NOT NULL,
	[ServerNameID] [int] NOT NULL,
	[DatabaseNameID] [int] NOT NULL,
	[HostNameID] [int] NOT NULL,
	[ApplicationNameID] [int] NOT NULL,
	[SessionLoginNameID] [int] NOT NULL,
	[Connections] [bigint] NOT NULL,
 CONSTRAINT [PK_Fact_Trace] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO


--- Create NCCIX BEFORE Foreign Keys
USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCSIX_All_Columns] ON [dbo].[Fact_Trace2]
(
	[DateID],
	[HourID],
	[ServerNameID],
	[DatabaseNameID],
	[HostNameID],
	[ApplicationNameID],
	[SessionLoginNameID],
	[Connections]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0) ON [PRIMARY]
GO




ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimApplication] FOREIGN KEY([ApplicationNameID])
REFERENCES [dbo].[Dim_ApplicationName] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimApplication]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimDatabaseName] FOREIGN KEY([DatabaseNameID])
REFERENCES [dbo].[Dim_DatabaseName] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimDatabaseName]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimDate] FOREIGN KEY([DateID])
REFERENCES [dbo].[Dim_Date] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimDate]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimHostName] FOREIGN KEY([HostNameID])
REFERENCES [dbo].[Dim_Hostname] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimHostName]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimHour] FOREIGN KEY([HourID])
REFERENCES [dbo].[Dim_Hour] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimHour]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimServerName] FOREIGN KEY([ServerNameID])
REFERENCES [dbo].[Dim_ServerName] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimServerName]
GO

ALTER TABLE [dbo].[Fact_Trace]  WITH CHECK ADD  CONSTRAINT [FK_FactTrace_DimSessionLoginName] FOREIGN KEY([SessionLoginNameID])
REFERENCES [dbo].[Dim_SessionLoginName] ([ID])
GO

ALTER TABLE [dbo].[Fact_Trace] CHECK CONSTRAINT [FK_FactTrace_DimSessionLoginName]
GO


--- Index up the FKs
USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_Dim_Date] ON [dbo].[Fact_Trace]
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_Dim_Host] ON [dbo].[Fact_Trace]
(
	[HostNameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_Dim_Login] ON [dbo].[Fact_Trace]
(
	[SessionLoginNameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO


USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_DimApp] ON [dbo].[Fact_Trace]
(
	[ApplicationNameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_DimDB] ON [dbo].[Fact_Trace]
(
	[DatabaseNameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

USE [ServerTrace_DW]
GO

CREATE NONCLUSTERED INDEX [NCIX_FactTrace_FK_Server] ON [dbo].[Fact_Trace]
(
	[ServerNameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

