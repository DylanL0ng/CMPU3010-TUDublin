# MAKE USER STUDENT ID
# ADD "Bike856BB" BEFORE ALL FUNCTIONS AND PROCEDURES
# grants
# select, insert bike
# select, insert repair
# select, insert repairpart
# select, model_part

import psycopg2, getpass, pandas as pd
from psycopg2 import Error

def main():
    try:
        print("\nThis is the Mechanic Role, please login:")
        
        connection = psycopg2.connect(
            # host="147.252.250.51",  
            host="localhost",  
            user = "postgres",
            # user = "C21331063",
            password="Sp00ky!",
            # password=getpass.getpass(prompt='Password '),
            port="5432", 
            database="postgres")
        
        cursor = connection.cursor()

        get_model_parts = ("SELECT modelpartname, parts_partid FROM model_part")
        cursor.execute(get_model_parts)
        result = cursor.fetchall()

        model_part_display = pd.DataFrame(
            result, 
            columns=['Model Part', 'Part ID']
        )

        try:
            get_bikes_awaiting_repair = ("SELECT * from get_bikes_awaiting_repair()")
            cursor.execute(get_bikes_awaiting_repair)
            bikes_awaiting_repair = cursor.fetchall()
        except:
            raise Exception('\nError: There are no bikes awaiting repair.\n')

        print("\nBIKES AWAITING REPAIR:\n")

        valid_serials = {}

        for bike in bikes_awaiting_repair:
            serial = bike[0]
            valid_serials[serial] = True

        df = pd.DataFrame(
        bikes_awaiting_repair, 
        columns=['Serial Number','Repair Number', 'Model ID', 'Customer ID'])

        print(df, '\n')

        isValid = False
        while not isValid:
            try:
                target_serial = int(input("Which serial number would you like to repair: "))
                if target_serial in valid_serials:
                    isValid = True
                else:
                    print('\nError: Serial number is not valid, try again.\n')
            except ValueError:
                print("\nError: You must enter an integer value, try again.\n")
    
        get_bike_description = ("SELECT get_bike_description({0})".format(target_serial))
        cursor.execute(get_bike_description)

        df = pd.DataFrame(
        cursor.fetchall(), 
        columns=['Description'])

        print('\n', df, '\n')

        isValid = False
        while not isValid:
            repair_description = input("\nEnter the repair description: ")
            if len(repair_description.strip()) > 0:
                isValid = True
            else:
                print("\nError: You must enter a value, try again.\n")
        
        isValid = False
        while not isValid:
            try:
                hours_spent = int(input("\nEnter the hours spent: "))
                isValid = True
            except ValueError:
                print("\nError: You must enter an integer value, try again.\n")


        log_repair = ("SELECT log_repair({0}, '{1}', {2})".format(target_serial, repair_description, hours_spent))
        cursor.execute(log_repair)

        repair_id = cursor.fetchone()[0]
        print("\nYour repair id is {0}".format(repair_id))

        has_exited = False
        while not has_exited:
            print("\n", model_part_display, "\n")

            model_id = int(input("Enter part id: "))
            part_quantity = int(input("Enter part quantity: "))

            try: 
                record_part = ("CALL record_part_repaired({0}, {1}, {2})".format(part_quantity, repair_id, model_id))
                cursor.execute(record_part)
            except:
                print("\nError: Model part is not valid.")

            try_again = input("\nWould you lke to add another part (Y/N): ")
            if try_again.lower() == 'n':
                has_exited = True

        connection.commit()

    except (Exception, Error) as error:
        print("Error while connecting to PostgreSQL", error)
    finally:
        if (connection):
            cursor.close()
            connection.close()
            print("\nPostgreSQL connection is closed")
        else:
            print("Terminating")

main()