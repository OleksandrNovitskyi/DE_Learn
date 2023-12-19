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
							SELECT [OrderDate], [ShipCity] FROM [Northwind].[dbo].[Orders]
							WHERE @requestDate = [OrderDate] AND [ShipCity] NOT IN (SELECT [ShipCity] FROM Northwind.dbo.ShipCityByDate);
						END;
					ELSE
						BEGIN
						   SELECT [OrderDate], [ShipCity] INTO ShipCityByDate FROM [Northwind].[dbo].[Orders] WHERE @requestDate = [OrderDate];
						END;
				END
-- for testing
EXEC getShipCityByDate "1996-07-08";
EXEC getShipCityByDate "1996-08-06";
EXEC getShipCityByDate "1996-08-01";

GO
-- показати міста
SELECT * FROM [Northwind].[dbo].[ShipCityByDate]
GO
truncate table [Northwind].[dbo].[ShipCityByDate]
GO
drop table [Northwind].[dbo].[ShipCityByDate]


GO
USE Northwind;
GO 
DROP PROCEDURE IF EXISTS dbo.CheckPrices;  
GO  
CREATE PROCEDURE CheckPrices
				-- @requestDate nvarchar(30)
				AS
				BEGIN
					IF OBJECT_ID(N'Northwind.dbo.CheckPrices', N'U') IS NOT NULL 
						BEGIN
							UPDATE Northwind.dbo.CheckPrices
							SET [Differences] = ISNULL([Northwind].[dbo].[Order Details].[UnitPrice], 0) - ISNULL([Northwind].[dbo].[CheckPrices].[UnitPrice], 0)
							FROM Northwind.dbo.CheckPrices
							JOIN [Northwind].[dbo].[Order Details] ON [Northwind].[dbo].[CheckPrices].[ProductID] = [Northwind].[dbo].[Order Details].[ProductID];				
						END;
					ELSE
						BEGIN
						   SELECT [ProductID], [UnitPrice] INTO [Northwind].[dbo].[CheckPrices] FROM [Northwind].[dbo].[Order Details];
						   ALTER TABLE [Northwind].[dbo].[CheckPrices] ADD [Differences] float DEFAULT 0.0;
						END;
				END;

-- for testing
EXEC CheckPrices;

GO
drop table [Northwind].[dbo].[CheckPrices]