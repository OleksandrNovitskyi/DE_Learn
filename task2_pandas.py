import pyodbc 
import pandas as pd
from sqlalchemy import create_engine

# Replace these variables with your actual SQL Server connection details
server_name = 'WIN-2L0QJEVGRLV'
database_name = 'Northwind'
username = 'sa'
password = '2121'

# Create a connection string for SQL Server
conn_str = f"mssql+pyodbc://{username}:{password}@{server_name}/{database_name}?driver=ODBC+Driver+17+for+SQL+Server"

# Establish a connection using SQLAlchemy
engine = create_engine(conn_str)

query = 'SELECT * FROM inc'
df = pd.read_sql_query(query, engine)

# Modify the data as needed
df.loc[df['person'] == 'John', 'person'] = 'Jim'

# Write the modified DataFrame back to SQL Server
table_name = 'inc'
df.to_sql(table_name, con=engine, if_exists='replace', index=False)
