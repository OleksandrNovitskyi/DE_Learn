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

df = pd.read_csv('Bank_of_America_data.csv')

# Write the modified DataFrame back to SQL Server
df.to_sql('Bank_of_America', con=engine, if_exists='replace', index=False)

engine.dispose()
