CREATE TABLE [dbo].[CustomerType]
(
	[CustomerTypeId] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Descripation] NVARCHAR(50) NULL, 
    [IsSystem] BIT NULL
)
