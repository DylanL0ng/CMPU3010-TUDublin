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

    sname = input("Enter the student name: ")
    postgreSQL_function_Query = ("SELECT ADDSTUDENT('{0}');".format(sname));
    cursor.execute(postgreSQL_function_Query)

    connection.commit()

    s_id = cursor.fetchone()[0]
    print("The student ID is", s_id)
    
except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("\nPostgreSQL connection is closed")
    else:
        print("Terminating")
