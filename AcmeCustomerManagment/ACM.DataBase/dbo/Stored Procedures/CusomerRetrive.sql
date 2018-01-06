CREATE PROCEDURE [dbo].[CusomerRetrive]
AS
	SELECT Customer.CustomerId,
			Customer.LastName,
			Customer.FirstName,
			EmailAddress,
			CustomerTypeId
	FROM Customer
	ORDER BY Customer.LastName
RETURN 0