DELETE FROM CustomerType

SET IDENTITY_INSERT [dbo].[CustomerType] ON
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (1, N'Corporation')
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (2, N'Individual')
INSERT INTO [dbo].[CustomerType] ([CustomerTypeId], [Descripation]) VALUES (3, N'Educator')
SET IDENTITY_INSERT [dbo].[CustomerType] OFF
