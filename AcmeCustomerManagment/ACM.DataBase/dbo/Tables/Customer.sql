CREATE TABLE [dbo].[Customer] (
    [CustomerId]    INT           IDENTITY (1, 1) NOT NULL,
    [LastName]     NVARCHAR (20) NULL,
    [FirstName]    NVARCHAR (20) NULL,
    [EmailAddress] NVARCHAR (50) NULL,
    [CustomerTypeId] INT NULL, 
    PRIMARY KEY CLUSTERED ([CustomerId] ASC), 
    CONSTRAINT [FK_Customer_CustomerType] FOREIGN KEY ([CustomerTypeId]) REFERENCES [CustomerType]([CustomerTypeId])
);


GO
CREATE NONCLUSTERED INDEX [IX_Customer_LastName]
    ON [dbo].[Customer]([LastName] ASC);

