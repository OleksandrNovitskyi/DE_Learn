from datetime import datetime, timedelta 
from airflow.models import DAG
from airflow.providers.microsoft.mssql.operators.mssql import MsSqlOperator

dag_owner = 'novitskyi'

default_args = {'owner': dag_owner,
        'depends_on_past': False,
        'retries': 2,
        'retry_delay': timedelta(minutes=5)
        }

with DAG(dag_id='procedures_v3',
        default_args=default_args,
        description='Connect to mssql server and change some data',
        start_date=datetime(2023, 11, 23),
        schedule_interval='0 */2 * * *',
        catchup=False,
) as dag:
    task1 = MsSqlOperator(
        task_id='getShipCityByDate',
        mssql_conn_id='my_mssql_connection_id',
        sql=r"""
            EXEC getShipCityByDate "1996-08-14";
            """
    )

    task1
