﻿/*
Deployment script for ACM

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "ACM"
:setvar DefaultFilePrefix "ACM"
:setvar DefaultDataPath "C:\Users\NISSIMOHAYON\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"
:setvar DefaultLogPath "C:\Users\NISSIMOHAYON\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
The column [dbo].[Customer].[CstomerId] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Customer])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [dbo].[FK_Customer_CustomerType]...';


GO
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [FK_Customer_CustomerType];


GO
PRINT N'Starting rebuilding table [dbo].[Customer]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Customer] (
    [CustomerId]     INT           IDENTITY (1, 1) NOT NULL,
    [LastName]       NVARCHAR (20) NULL,
    [FirstName]      NVARCHAR (20) NULL,
    [EmailAddress]   NVARCHAR (50) NULL,
    [CustomerTypeId] INT           NULL,
    PRIMARY KEY CLUSTERED ([CustomerId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Customer])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Customer] ([LastName], [FirstName], [EmailAddress], [CustomerTypeId])
        SELECT [LastName],
               [FirstName],
               [EmailAddress],
               [CustomerTypeId]
        FROM   [dbo].[Customer];
    END

DROP TABLE [dbo].[Customer];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Customer]', N'Customer';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[Customer].[IX_Customer_LastName]...';


GO
CREATE NONCLUSTERED INDEX [IX_Customer_LastName]
    ON [dbo].[Customer]([LastName] ASC);


GO
PRINT N'Altering [dbo].[CustomerType]...';


GO
ALTER TABLE [dbo].[CustomerType]
    ADD [IsSystem] BIT NULL;


GO
PRINT N'Creating [dbo].[FK_Customer_CustomerType]...';


GO
ALTER TABLE [dbo].[Customer] WITH NOCHECK
    ADD CONSTRAINT [FK_Customer_CustomerType] FOREIGN KEY ([CustomerTypeId]) REFERENCES [dbo].[CustomerType] ([CustomerTypeId]);


GO
PRINT N'Altering [dbo].[CusomerRetrive]...';


GO
ALTER PROCEDURE [dbo].[CusomerRetrive]
AS
	SELECT Customer.CustomerId,
			Customer.LastName,
			Customer.FirstName,
			EmailAddress,
			CustomerTypeId
	FROM Customer
	ORDER BY Customer.LastName
RETURN 0
GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
DELETE FROM CustomerType

SET IDENTITY_INSERT [dbo].[CustomerType] ON
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (1, N'Corporation')
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (2, N'Individual')
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (3, N'Educator')
SET IDENTITY_INSERT [dbo].[CustomerType] OFF

GO

GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Customer] WITH CHECK CHECK CONSTRAINT [FK_Customer_CustomerType];


GO
PRINT N'Update complete.';


GO