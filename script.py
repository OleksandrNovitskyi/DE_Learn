import pyodbc 
import pandas as pd

# cnxn = pyodbc.connect('DRIVER={SQL Server};Server=WIN-2L0QJEVGRLV;Database=Northwind;Port=myport;User ID=myuserid;Password=mypassword')
cnxn = pyodbc.connect('DRIVER={SQL Server};Server=WIN-2L0QJEVGRLV;Database=Northwind;Trusted_Connection=yes;')

# cursor = cnxn.cursor()
# cursor.execute("SELECT * FROM dbo.Customers;")
# rows = cursor.fetchall()
# for row in rows:
#     print(row)
# cursor.close()

df = pd.read_sql("SELECT * FROM dbo.Customers", cnxn)
print(df)

cnxn.close()

