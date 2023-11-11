# Dylan Hussain
# C21331063

import psycopg2, getpass, pandas as pd
from psycopg2 import Error

def main():
    try:
        print("\nThis is the Mechanic Role, please login:")
        
        connection = psycopg2.connect(
            host="147.252.250.51",  
            user = "C21331063",
            password=getpass.getpass(prompt='Password: '),
            port="5432", 
            database="postgres")
        
        cursor = connection.cursor()

        # Get the model parts available and display them to the user
        get_model_parts = ("SELECT modelpartname, parts_partid FROM \"Bike856BB\".model_part")
        cursor.execute(get_model_parts)
        result = cursor.fetchall()

        model_part_display = pd.DataFrame(
            result, 
            columns=['Model Part', 'Part ID']
        )

        # Check for bikes that are awaiting repair
        # if none display no bikes available
        try:
            get_bikes_awaiting_repair = ("SELECT * from \"Bike856BB\".get_bikes_awaiting_repair()")
            cursor.execute(get_bikes_awaiting_repair)
            bikes_awaiting_repair = cursor.fetchall()
        except:
            raise Exception('\nError: There are no bikes awaiting repair.\n')

        print("\nBIKES AWAITING REPAIR:\n")

        # Create dict to validate serial numbers
        valid_serials = {}

        for bike in bikes_awaiting_repair:
            serial = bike[0]
            valid_serials[serial] = True

        df = pd.DataFrame(
        bikes_awaiting_repair, 
        columns=['Serial Number','Repair Number', 'Model ID', 'Customer ID'])

        print(df, '\n')

        # Loop until user enters a valid serial number
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
    
        # Get the repair description given the serial number
        get_bike_description = ("SELECT \"Bike856BB\".get_bike_description({0})".format(target_serial))
        cursor.execute(get_bike_description)

        df = pd.DataFrame(
        cursor.fetchall(), 
        columns=['Description'])

        print('\n', df, '\n')

        # Loop until a repair description is entered
        isValid = False
        while not isValid:
            repair_description = input("\nEnter the repair description: ")
            if len(repair_description.strip()) > 0:
                isValid = True
            else:
                print("\nError: You must enter a value, try again.\n")
        
        # Loop until the hours spent on the repair is entered
        isValid = False
        while not isValid:
            try:
                hours_spent = int(input("\nEnter the hours spent: "))
                isValid = True
            except ValueError:
                print("\nError: You must enter an integer value, try again.\n")


        # Record the repair record
        log_repair = ("SELECT \"Bike856BB\".log_repair({0}, '{1}', {2})".format(target_serial, repair_description, hours_spent))
        cursor.execute(log_repair)

        repair_id = cursor.fetchone()[0]
        print("\nYour repair id is {0}".format(repair_id))

        # Prompt user to insert new part id and quantity, check the quantity
        # and part id for valid types and check part id for valid part
        # Loop until user does not want to insert new part
        has_exited = False
        while not has_exited:
            print("\n", model_part_display, "\n")

            try:
                model_id = int(input("Enter part id: "))
                part_quantity = int(input("Enter part quantity: "))

                try: 
                    record_part = ("CALL \"Bike856BB\".record_part_repaired({0}, {1}, {2})".format(part_quantity, repair_id, model_id))
                    cursor.execute(record_part)
                except:
                    print("\nError: Model part is not valid.")

                try_again = input("\nWould you lke to add another part (Y/N): ")
                if try_again.lower() == 'n':
                    has_exited = True
            except ValueError:
                print("\nError: You must enter an integer value, try again.\n")


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