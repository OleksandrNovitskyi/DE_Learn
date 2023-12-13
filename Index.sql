-- індекси
SELECT * FROM [Northwind].[dbo].[New Order Details];
  go
  -- кластеризований (він тільки один, по ньому впорядовується)
  -- створити
CREATE CLUSTERED INDEX IX_OrderID ON [Northwind].[dbo].[New Order Details] ([OrderID]);
  GO
CREATE CLUSTERED INDEX IX_ProductID ON [Northwind].[dbo].[New Order Details] ([ProductID]);
  go
  -- видалити 
    DROP INDEX IX_OrderID ON [Northwind].[dbo].[New Order Details];
	GO
DROP INDEX IX_ProductID ON [Northwind].[dbo].[New Order Details];
	GO

  -- перевірити чи є
SELECT *
FROM sys.indexes
WHERE name = 'IX_ProductID' AND object_id = OBJECT_ID('[Northwind].[dbo].[New Order Details]');
	GO
-- некластеризований (може бути багато)
CREATE NONCLUSTERED INDEX IX_OrderID ON [Northwind].[dbo].[New Order Details] ([OrderID]);
	GO
	-- унікальний (потрібна колонка унікальних значень)
ALTER TABLE [Northwind].[dbo].[New Order Details]
ADD [ID] INT IDENTITY(1,1);
	GO
CREATE UNIQUE INDEX IX_ID ON [Northwind].[dbo].[New Order Details] ([ID]);

-- складний індекс (по двом і більше стовпцям)
CREATE INDEX IX_OrderDetails_OrderID_ProductID ON [Northwind].[dbo].[New Order Details] (OrderID, ProductID);
GO
DROP INDEX IX_OrderDetails_OrderID_ProductID ON [Northwind].[dbo].[New Order Details];
GO


