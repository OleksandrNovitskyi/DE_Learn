import pyodbc 

cnxn = pyodbc.connect('DRIVER={SQL Server};Server=WIN-2L0QJEVGRLV;Database=Northwind;Trusted_Connection=yes;')

cursor = cnxn.cursor()

# cursor.execute("CREATE TABLE inc(person nvarchar(50), income money);")

cursor.execute("INSERT INTO inc VALUES('John', 500, 2500);")
cursor.execute("INSERT INTO inc VALUES('John', 1500, 2500);")
cursor.execute("INSERT INTO inc VALUES('Poll', 5100, 2500);")
cursor.execute("INSERT INTO inc VALUES('Sarah', 1500, 2500);")
cursor.execute("INSERT INTO inc VALUES('Jeck', 2500, 2500);")


# Execute the SQL command to alter the table
# cursor.execute("ALTER TABLE inc ADD salary money")

# Execute the SQL command with the data
# cursor.execute("UPDATE inc SET person = ? WHERE income = ?", ('WINNER', 5100))

# Execute the SQL command with the data
# cursor.execute("DELETE FROM inc WHERE person = ?", ('WINNER',))

keep_one_instance_query = """
    WITH CTE AS (
        SELECT person, 
               ROW_NUMBER() OVER (PARTITION BY person ORDER BY (SELECT NULL)) AS rn
        FROM inc
    )
    DELETE FROM CTE WHERE rn > 1
"""
cursor.execute(keep_one_instance_query)

cursor.commit()
cursor.close()

cnxn.close()

