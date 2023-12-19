USE Northwind; -- всі подальші команди стосуються цієї БД
GO
CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))  -- створити фунцію розбиття яка приймає на вхід стовпчик з типом данних Date
    AS RANGE RIGHT FOR VALUES ('2022-04-01', '2022-05-01', '2022-06-01') ;  -- розділити на 4 групи, межами є дати які в дужках
GO  

CREATE PARTITION SCHEME myRangePS1  -- створити схему розбиття
    AS PARTITION myRangePF1  -- використати розбиття за допомогою функції myRangePF1
    ALL TO ('PRIMARY') ;  -- зберігати в файловій групі [PRIMARY]- це я не до кінця зрозумів
GO  

CREATE TABLE dbo.PartitionTable -- створити таблицю 
(
	col0 INT IDENTITY(1,1), -- IDENTITY(1,1) - згенерувати послідовність INT цифр від 1 до нескінченності
	col1 datetime2(0), -- колонка з датами
	сol2 char(10) -- колонка з текстом
	PRIMARY KEY (col0, col1) -- в якості первинного ключа комбінація 1ї і 2ї колонок
) ON myRangePS1 (col1) ;  -- для розбиття використати схему myRangePS1, передати в цю схему колонку 2
GO


-- Testing
DROP TABLE Northwind.dbo.PartitionTable;
DROP PARTITION SCHEME myRangePS1;
DROP PARTITION FUNCTION myRangePF1;
GO  
SELECT * FROM [Northwind].[dbo].[PartitionTable];
GO  
INSERT INTO [Northwind].[dbo].[PartitionTable] VALUES (SYSDATETIME(),'text');


