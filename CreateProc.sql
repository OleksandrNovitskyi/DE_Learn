USE Northwind;
GO 
DROP PROCEDURE IF EXISTS dbo.getShipCityByDate;  
GO  
CREATE PROCEDURE getShipCityByDate
				@requestDate nvarchar(30)
				AS
				BEGIN
					IF OBJECT_ID(N'Northwind.dbo.ShipCityByDate', N'U') IS NOT NULL 
						BEGIN
							INSERT INTO Northwind.dbo.ShipCityByDate
							SELECT [ShipCity] FROM [Northwind].[dbo].[Orders]
							WHERE @requestDate = [OrderDate];
						END;
					ELSE
						BEGIN
						   SELECT [ShipCity] INTO ShipCityByDate FROM [Northwind].[dbo].[Orders] WHERE @requestDate = [OrderDate];
						END;
				END

-- for testing
EXEC getShipCityByDate "1996-07-08";
EXEC getShipCityByDate "1996-08-06";
EXEC getShipCityByDate "1996-08-01";

GO
-- показати міста(без повторів)
SELECT DISTINCT * FROM [Northwind].[dbo].[ShipCityByDate]
GO
truncate table [Northwind].[dbo].[ShipCityByDate]