import pyodbc 
import pandas as pd
from sqlalchemy import create_engine

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

df.loc[df['person'] == 'Poll', 'income'] = 6000

df['salary'] = df['salary'].apply(lambda x: x * 1.2)

# Write the modified DataFrame back to SQL Server
df.to_sql('inc', con=engine, if_exists='replace', index=False)
