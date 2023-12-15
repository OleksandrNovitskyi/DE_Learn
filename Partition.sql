USE Northwind;
GO
CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))  
    AS RANGE RIGHT FOR VALUES ('2022-04-01', '2022-05-01', '2022-06-01') ;  
GO  

CREATE PARTITION SCHEME myRangePS1  
    AS PARTITION myRangePF1  
    ALL TO ('PRIMARY') ;  
GO  

CREATE TABLE dbo.PartitionTable (col1 datetime2(0) PRIMARY KEY, col2 char(10))  
    ON myRangePS1 (col1) ;  
GO


-- Testing
DROP TABLE dbo.PartitionTable;

SELECT * FROM [Northwind].[dbo].[PartitionTable];

INSERT INTO [Northwind].[dbo].[PartitionTable] VALUES (SYSDATETIME(),'text');
