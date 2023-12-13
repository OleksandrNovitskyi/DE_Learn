USE [Northwind]
GO
--створити таблиці
SELECT * INTO [dbo].[New Order Details] FROM [dbo].[Order Details];
SELECT * INTO [dbo].[New Order Details2] FROM [dbo].[Order Details];

GO
BEGIN TRANSACTION
/*
DROP PARTITION SCHEME [ps_ByUnitPrice];
DROP PARTITION FUNCTION [pf_ByUnitPrice];
*/

CREATE PARTITION FUNCTION [pf_ByUnitPrice](money) AS RANGE LEFT FOR VALUES (N'10', N'25', N'50', N'75', N'100')


CREATE PARTITION SCHEME [ps_ByUnitPrice] AS PARTITION [pf_ByUnitPrice] TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY])




CREATE CLUSTERED INDEX [ClusteredIndex_on_ps_ByUnitPrice_638380650503064567] ON [dbo].[New Order Details]
(
	[UnitPrice]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [ps_ByUnitPrice]([UnitPrice])


DROP INDEX [ClusteredIndex_on_ps_ByUnitPrice_638380650503064567] ON [dbo].[New Order Details]


SELECT * FROM [dbo].[New Order Details] WHERE [UnitPrice] BETWEEN 4 AND 15;

SELECT * FROM [dbo].[New Order Details2] WHERE [UnitPrice] BETWEEN 4 AND 15;
