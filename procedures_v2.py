from datetime import datetime, timedelta 
from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator
from airflow.providers.microsoft.mssql.hooks.mssql import MsSqlHook
import pandas as pd

dag_owner = 'novitskyi'

default_args = {'owner': dag_owner,
        'depends_on_past': False,
        'retries': 2,
        'retry_delay': timedelta(minutes=5)
        }
    
def extract_data():
    hook = MsSqlHook(mssql_conn_id="my_mssql_connection_id")
    sql="EXEC extract;"
    df = hook.get_pandas_df(sql)
    df.to_csv('file.csv', index=False)
    print(df)

def load_data():
    df_from_first_task = pd.read_csv('file.csv')
    for index, row in df_from_first_task.iterrows():
        sql = "EXEC load @OrderID = %s, @Cash = %s;"
        params = (row['OrderID'], row['Cash'])
        
        mssql_hook = MsSqlHook(mssql_conn_id="my_mssql_connection_id")
        mssql_hook.run(sql, parameters=params)

with DAG(dag_id='procedures_v2',
        default_args=default_args,
        description='Connect to mssql server and change some data',
        start_date=datetime(2023, 11, 23),
        schedule_interval='0 12 * * *',
        catchup=False,
) as dag:
    create_proc1_extract = MsSqlOperator(
        task_id="create_proc1_extract",
        mssql_conn_id="my_mssql_connection_id",
        sql=r""" 
                CREATE OR ALTER PROCEDURE extract AS
                   SELECT [OrderID], sum([UnitPrice]*[Quantity]) AS Cash FROM [Northwind].[dbo].[Order Details] GROUP BY [OrderID];
            """,
    )
      
    create_proc2_load = MsSqlOperator(
        task_id="create_proc2_load",
        mssql_conn_id="my_mssql_connection_id",
        sql=r""" 
                CREATE OR ALTER PROCEDURE load 
                    @OrderID INT, 
                    @Cash FLOAT
                AS
                BEGIN
                    MERGE INTO Northwind.dbo.New_table AS target
                    USING (VALUES (@OrderID)) AS source (OrderID)
                    ON target.OrderID = source.OrderID
                    WHEN MATCHED THEN
                        UPDATE SET Cash = @Cash
                    WHEN NOT MATCHED THEN
                        INSERT (OrderID, Cash) VALUES (@OrderID, @Cash);
                END;
            """,
    )

    task0 = MsSqlOperator(
        task_id='create_table',
        mssql_conn_id='my_mssql_connection_id',
        sql=r"""USE Northwind;
            IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'New_table')
            BEGIN
                CREATE TABLE dbo.New_table (
                    OrderID INT NULL,
                    Cash FLOAT NULL
                ) ON [PRIMARY];
            END
            """
    )
    task1 = PythonOperator(
        task_id="extract",
        python_callable=extract_data
    )

    task2 = PythonOperator(
        task_id="load",
        python_callable=load_data,
    )

    create_proc1_extract >> create_proc2_load >> task0 >> task1 >> task2
