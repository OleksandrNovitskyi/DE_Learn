USE Northwind;
GO
CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))  
    AS RANGE RIGHT FOR VALUES ('2022-04-01', '2022-05-01', '2022-06-01') ;  
GO  

CREATE PARTITION SCHEME myRangePS1  
    AS PARTITION myRangePF1  
    ALL TO ('PRIMARY') ;  
GO  

CREATE TABLE dbo.PartitionTable 
(
	col0 INT IDENTITY(1,1),
	col1 datetime2(0),
	сol2 char(10)
	PRIMARY KEY (col0, col1)
) ON myRangePS1 (col1) ;  
GO


-- Testing
DROP TABLE Northwind.dbo.PartitionTable;
DROP PARTITION SCHEME myRangePS1;
DROP PARTITION FUNCTION myRangePF1;
GO  
SELECT * FROM [Northwind].[dbo].[PartitionTable];
GO  
INSERT INTO [Northwind].[dbo].[PartitionTable] VALUES (SYSDATETIME(),'text');


