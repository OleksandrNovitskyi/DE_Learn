USE [Northwind]
GO
-- Створити filegroupses
ALTER DATABASE Northwind ADD FILEGROUP Filegroup1;
ALTER DATABASE Northwind ADD FILEGROUP Filegroup2;
ALTER DATABASE Northwind ADD FILEGROUP Filegroup3;
GO
-- Додавання файлу до файлової групи
ALTER DATABASE [Northwind]
ADD FILE (
    NAME = TestFG1, 
    FILENAME = 'D:\test\TestFG1.ndf',
    SIZE = 10MB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 5MB
)
TO FILEGROUP Filegroup1; 

ALTER DATABASE [Northwind]
ADD FILE (
    NAME = TestFG2, 
    FILENAME = 'D:\test\TestFG2.ndf',
    SIZE = 10MB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 5MB
)
TO FILEGROUP Filegroup2; 

ALTER DATABASE [Northwind]
ADD FILE (
    NAME = TestFG3, 
    FILENAME = 'D:\test\TestFG3.ndf',
    SIZE = 10MB, 
    MAXSIZE = UNLIMITED, 
    FILEGROWTH = 5MB
)
TO FILEGROUP Filegroup3; 

-- 
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [pf_NewByOrderDate](datetime) AS RANGE RIGHT FOR VALUES (N'1997-01-01T00:00:00', N'1998-01-01T00:00:00')

CREATE PARTITION SCHEME [ps_NewByOrderDate] AS PARTITION [pf_NewByOrderDate] TO (Filegroup1, Filegroup2,Filegroup3)

CREATE CLUSTERED INDEX [ClusteredIndex_on_ps_ByOrderDate_638380723664429469] ON [dbo].[New Orders]
(
	[OrderDate]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [ps_NewByOrderDate]([OrderDate])


DROP INDEX [ClusteredIndex_on_ps_ByOrderDate_638380723664429469] ON [dbo].[New Orders]


COMMIT TRANSACTION

-- Speed Testing
USE [Northwind]
SELECT * FROM [dbo].[New Orders] WHERE [OrderDate] BETWEEN '1995-12-13' AND '1996-12-31';

SELECT * FROM [dbo].[New Ordes2] WHERE [OrderDate] BETWEEN '1995-12-13' AND '1996-12-31';
