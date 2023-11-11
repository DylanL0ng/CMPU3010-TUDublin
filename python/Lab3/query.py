import psycopg2, getpass, pandas as pd
from psycopg2 import Error
try:
    connection = psycopg2.connect(
        host="localhost",  
        user = "postgres",
        # password=getpass.getpass(prompt='Password '),
        password="Sp00ky!",
        port="5432", 
        database="postgres")
    cursor = connection.cursor()
    postgreSQL_select_Query = 'SELECT st_id, st_name FROM Student;'
    cursor.execute(postgreSQL_select_Query)
    df = pd.DataFrame(
        cursor.fetchall(), 
        columns=['',''])
    print(df)
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("\nPostgreSQL connection is closed")
    else:
        print("Terminating")
