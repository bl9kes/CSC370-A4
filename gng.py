#!/usr/bin/env python3
import psycopg2, calendar, datetime, re
from psycopg2 import OperationalError

def create_connection():
    conn = None
    try:
        # Establish a connection to the database
        dbconn = psycopg2.connect(
            host='studentdb.csc.uvic.ca',
            user='c370_s134',
            password='3DwI9QUt'
        )
        # If the connection was successful, return it
        return dbconn
    except OperationalError as e:
        print(f"The error '{e}' occurred")
    return conn

def browse_queries(conn):
     while True:
        print("\n=== Green-not-Greed Database Queries ===")
        for key, value in queries.items():
            print(f"{key}. {value['description']}")
        print("B. Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break

        query_info = queries.get(choice)
        if query_info:
            results = execute_query(conn, query_info["query"])
            print("\nResults:")
            if results:
                for row in results:
                    formatted_row = " | ".join(str(item).strip() if isinstance(item, str) else str(item) for item in row)
                    print(formatted_row)
            else:
                print("No results found.")
        else:
            print("Invalid option. Please try again.")

queries = {
    "1": {
        "description": "Calculate the total expenses for each event, grouped by Event ID.",
        "query": """
            SELECT Event_ID, SUM(Amount) AS Total_Expenses
            FROM Accrue
            JOIN Expenses ON Accrue.Expense_ID = Expenses.Expense_ID
            GROUP BY Event_ID
            ORDER BY Total_Expenses ASC;
        """
    },
    "2": {
        "description": "Compute the total donations received for each campaign, grouped by Campaign ID.",
        "query": """
            SELECT Campaign_ID, SUM(Amount) AS Total_Donations
            FROM FundedBy
            JOIN Donor ON FundedBy.Donor_ID = Donor.Member_ID
            GROUP BY Campaign_ID;
        """
    },
    "3": {
        "description": "Find the average donation amount across all donations.",
        "query": """
            SELECT AVG(Amount) AS Avg_Donation
            FROM Donor;
        """
    },
    "4": {
        "description": "Count how many events each volunteer has participated in, ordered by participation.",
        "query": """
            SELECT Volunteer_ID, COUNT(Event_ID) AS Events_Participated
            FROM Executes
            GROUP BY Volunteer_ID
            ORDER BY Events_Participated DESC;
        """
    },
    "5": {
        "description": "Identify how many campaigns each employee has been involved in planning.",
        "query": """
            SELECT Employee_ID, COUNT(Campaign_ID) AS Campaigns_Involved
            FROM Plans
            GROUP BY Employee_ID
            ORDER BY Employee_ID ASC;
        """
    },
    "6": {
        "description": "Determine the number of events organized under each campaign, limited to the first 4 campaigns.",
        "query": """
            SELECT Campaign_ID, COUNT(Event_ID) AS NumberOfEvents
            FROM Organize
            GROUP BY Campaign_ID
            ORDER BY Campaign_ID ASC
            LIMIT 4;
        """
    },
    "7": {
        "description": "List each volunteer, the number of events they've worked on, and their tier.",
        "query": """
            SELECT Volunteer.Member_ID, COUNT(Executes.Event_ID) AS EventsWorked, Volunteer.Tier
            FROM Volunteer
            JOIN Executes ON Volunteer.Member_ID = Executes.Volunteer_ID
            GROUP BY Volunteer.Member_ID;
        """
    },
    "8": {
        "description": "Identify the highest salary among employees who have planned more than one campaign.",
        "query": """
            SELECT Employee.Member_ID, MAX(Employee.Salary) AS HighestSalary
            FROM Employee
            JOIN Plans ON Employee.Member_ID = Plans.Employee_ID
            GROUP BY Employee.Member_ID
            HAVING COUNT(DISTINCT Plans.Campaign_ID) > 1;
        """
    },
    "9": {
        "description": "Count how many website pages exist for each status.",
        "query": """
            SELECT Status, COUNT(*) AS Count
            FROM Website
            GROUP BY Status;
        """
    },
    "10": {
        "description": "Determine the top donor by total donation amount.",
        "query": """
            SELECT Member_ID, SUM(Amount) AS TotalDonation
            FROM Donor
            GROUP BY Member_ID
            ORDER BY SUM(Amount) DESC
            LIMIT 1;
        """
    },
}


def add_volunteer(conn):
    print("Current known Member IDs and Names:")
    existing_member_ids = set()
    with conn.cursor() as cur:
        cur.execute("SELECT Member_ID, Name FROM Member ORDER BY Member_ID;")
        members = cur.fetchall()
        for member in members:
            print(f"Member ID: {member[0]}")
            existing_member_ids.add(member[0])  # Store existing Member IDs for comparison

    # Regular expression for matching phone number format
    phone_pattern = re.compile(r"\d{3}-\d{3}-\d{4}")

    while True:
        member_id = input("Enter member ID (xxxxxxxx): ")
        # Check if member_id is 8 digits long and not already used
        if not (member_id.isdigit() and len(member_id) == 8):
            print("Invalid Member ID. Please enter an 8 digit ID.")
            continue
        elif member_id in existing_member_ids:
            print("This Member ID is already in use. Please enter a unique Member ID.")
            continue

        name = input("Enter volunteer name: ")

        contact = input("Enter volunteer contact information (e.g., phone number): ")
        # Check if contact matches the phone number pattern
        if not phone_pattern.match(contact):
            print("Invalid contact format. Please enter a phone number in the format 'xxx-xxx-xxxx'.")
            continue

        tier = input("Enter volunteer tier (e.g., 'New', 'Experienced'): ")
        # Check if tier is either 'New' or 'Experienced'
        if tier not in ['New', 'Experienced']:
            print("Invalid tier. Please enter either 'New' or 'Experienced'.")
            continue

        with conn.cursor() as cur:
            try:
                # Insert into Member
                cur.execute("INSERT INTO Member (Member_ID, Name, Contact) VALUES (%s, %s, %s);", (member_id, name, contact))
                # Insert into Volunteer
                cur.execute("INSERT INTO Volunteer (Member_ID, Tier) VALUES (%s, %s);", (member_id, tier))
                conn.commit()
                print(f"Volunteer added successfully with Member ID: {member_id}.")
                break  # Exit loop after successful operation
            except Exception as e:
                print(f"An error occurred: {e}")
                conn.rollback()
                break




def assign_volunteer_to_event(conn):
    # Regular expression for matching event_id format
    event_pattern = re.compile(r"00\d_Event\d")

    volunteer_id = input("Enter member ID (xxxxxxxx): ")
    # Check if volunteer_id is 8 digits long
    if not (volunteer_id.isdigit() and len(volunteer_id) == 8):
        print("Invalid Member ID. Please enter an 8 digit ID.")
        return  # Exit if the volunteer_id is not valid

    while True:
        event_id = input("Enter event ID (00x_Eventx): ")
        # Check if event_id matches the expected pattern
        if not event_pattern.match(event_id):
            print("Invalid event ID format. Please enter an event ID in the format '00x_Eventx'.")
            continue

        with conn.cursor() as cur:
            try:
                cur.execute("INSERT INTO Executes (Event_ID, Volunteer_ID) VALUES (%s, %s);", (event_id, volunteer_id))
                conn.commit()
                print("Volunteer assigned to event successfully.")
                break  # Exit loop after successful operation
            except Exception as e:
                conn.rollback()
                if "violates foreign key constraint" in str(e) and "event_id" in str(e):
                    print("The event ID entered does not exist. Please enter a valid event ID.")
                    continue  # Reprompt for event_id due to foreign key constraint violation
                else:
                    print(f"An error occurred: {e}")
                    # Exit or handle other types of errors differently
                    break



def schedule_event(conn):
    # Regular expression for matching event_id format
    event_id_pattern = re.compile(r"00\d_Event\d")

    # Input and validation for event_id
    while True:
        event_id = input("Enter event ID (00x_Eventx): ")
        if event_id_pattern.match(event_id):
            # Check if event ID exists in the database
            with conn.cursor() as cur:
                cur.execute("SELECT EXISTS(SELECT 1 FROM Event WHERE Event_ID = %s)", (event_id,))
                if cur.fetchone()[0]:
                    print("Event ID already exists. Please enter a new event ID.")
                    continue
            break
        print("Invalid event ID format. Please enter an event ID in the format '00x_Eventx'.")

    name = input("Enter event name: ")

    # Input and validation for profit/loss
    while True:
        profit_loss = input("Enter event profit/loss: ")
        if not profit_loss:  # Allow empty input
            break
        # Add specific validation rules for profit/loss if necessary
        break  # Break loop if input is acceptable

    # Input and validation for event type
    while True:
        event_type = input("Enter event type: ")
        if event_type:  # Check if input is not empty
            # Add specific validation rules for event type if necessary
            break  # Break loop if input is acceptable
        print("Event type cannot be empty. Please provide a valid event type.")

    location = input("Enter event location: ")

    # Input and validation for date
    while True:
        date = input("Enter event date (e.g., April 20, 2024): ")
        try:
            # Convert the input date string to datetime format
            parsed_date = datetime.datetime.strptime(date, "%B %d, %Y")
            # If the parsing is successful, break out of the loop
            break
        except ValueError:
            print("Invalid date format. Please enter the date in the format 'Month day, year'.")
            continue

    with conn.cursor() as cur:
        try:
            cur.execute("INSERT INTO Event (Event_ID, Name, \"Profit/Loss\", Type, Location, Date) VALUES (%s, %s, %s, %s, %s, %s);", 
                        (event_id, name, profit_loss, event_type, location, parsed_date.strftime("%B %d, %Y")))
            conn.commit()
            print("Event scheduled successfully.")
        except Exception as e:
            conn.rollback()
            print(f"An error occurred: {e}")


def view_campaign_state(conn):
    campaign_id = input("Enter campaign ID to view its state: ")

    with conn.cursor() as cur:
        cur.execute("""
        SELECT e.Name, e.Date, COUNT(ex.Volunteer_ID)
        FROM Event e
        LEFT JOIN Executes ex ON e.Event_ID = ex.Event_ID
        WHERE e.Event_ID IN (SELECT Event_ID FROM Organize WHERE Campaign_ID = %s)
        GROUP BY e.Name, e.Date
        ORDER BY e.Date;
        """, (campaign_id,))
        results = cur.fetchall()
        for event in results:
            print(f"Event: {event[0]}, Date: {event[1]}, Volunteers: {event[2]}")


def ascii_bar_chart(label_value_pairs):
    max_value = max(value for label, value in label_value_pairs) if label_value_pairs else 1
    scale = 50 / max_value if max_value > 0 else 1

    for label, value in label_value_pairs:
        # Ensure at least one '#' for any non-zero donation
        bar_length = max(1, int(value * scale)) if value > 0 else 0
        bar = "#" * bar_length
        print(f"{label} : {bar} ({value})")



def report_financials(conn, query, title):
    with conn.cursor() as cur:
        cur.execute(query)
        results = cur.fetchall()

    if not results:
        print(f"\nNo data available for {title}.")
        return

    print(f"\n{title}:")
    max_length = max(len(row[1]) for row in results)  # Find max length for campaign names
    for row in results:
        name = row[1].ljust(max_length) 
        print(f"{row[0]} ({name}): {row[2]:.2f}")

    print("\n" + "-" * (max_length + 60))

    # Generate and print ASCII bar chart
    label_value_pairs = [(f"{row[0]} ({row[1]})", row[2]) for row in results]
    ascii_bar_chart(label_value_pairs)


def view_donations(conn):
    while True:
        print("\n=== Donations Menu ===")
        print("1. View Total Donation Amount")
        print("2. View Largest Single Donation")
        print("B. Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break

        if choice == '1':
            query = "SELECT SUM(Amount) FROM Donor;"
            title = "Total Donation Amount"
        elif choice == '2':
            query = "SELECT MAX(Amount) FROM Donor;"
            title = "Largest Single Donation"
        else:
            print("Invalid option. Please try again.")
            continue
        
        with conn.cursor() as cur:
            cur.execute(query)
            result = cur.fetchone()[0]
            print(f"\n{title}: {result if result is not None else 0:.2f}")


def view_expenses(conn):
    while True:
        print("\n=== Expenses Menu ===")
        print("1. View Total Expenses")
        print("2. View Total Expenses of Each Campaign")
        print("3. View Total Expenses of Each Event")
        print("4. View Campaign with the Most Expenses")
        print("B. Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break

        if choice == '1':
            query = "SELECT SUM(Amount) FROM Expenses;"
            title = "Total Expenses"
        elif choice == '2':
            query = """SELECT O.Campaign_ID, SUM(E.Amount) AS Total_Expenses
                       FROM Expenses E
                       JOIN Accrue A ON E.Expense_ID = A.Expense_ID
                       JOIN Event EV ON A.Event_ID = EV.Event_ID
                       JOIN Organize O ON EV.Event_ID = O.Event_ID
                       GROUP BY O.Campaign_ID;"""
            title = "Total Expenses of Each Campaign"
        elif choice == '3':
            query = """SELECT Event_ID, SUM(Expenses.Amount) AS Total_Expenses
                       FROM Accrue
                       JOIN Expenses ON Accrue.Expense_ID = Expenses.Expense_ID
                       GROUP BY Event_ID;"""
            title = "Total Expenses of Each Event"
        elif choice == '4':
            query = """SELECT O.Campaign_ID, C.Name, SUM(E.Amount) AS Total_Expenses
                       FROM Accrue A
                       JOIN Expenses E ON A.Expense_ID = E.Expense_ID
                       JOIN Event EV ON A.Event_ID = EV.Event_ID
                       JOIN Organize O ON EV.Event_ID = O.Event_ID
                       JOIN Campaign C ON O.Campaign_ID = C.Campaign_ID
                       GROUP BY O.Campaign_ID, C.Name
                       ORDER BY Total_Expenses DESC
                       LIMIT 1;"""
            title = "Campaign with the Most Expenses"
        else:
            print("Invalid option. Please try again.")
            continue

        with conn.cursor() as cur:
            cur.execute(query)
            if choice in ['2', '3']:
                results = cur.fetchall()
                for row in results:
                    print(f"{row[0]}: {row[1]:.2f}")
            elif choice == '4':
                result = cur.fetchone()
                if result:
                    campaign_id, campaign_name, total_expenses = result
                    print(f"\n{title}: Campaign {campaign_id} ('{campaign_name}') has the most expenses: -{total_expenses:.2f}")
                else:
                    print("\nUnable to find the campaign with the most expenses.")
            else:  # For choice '1'
                result = cur.fetchone()[0]
                print(f"\n{title}: {result:.2f}" if result is not None else "\nNo expenses found.")


def manage_donations_and_expenses(conn):
    while True:
        print("\n=== Manage Donations and Expenses ===")
        print("1. View Total Donations per Campaign")
        print("2. View Total Expenses per Event")
        print("3. View Donation Details")
        print("4. View Expenses Details")
        print("B. Go Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break
        elif choice == '1':
            # Directly call the predefined function for total donations per campaign
            report_financials(conn, 
                "SELECT Campaign.Campaign_ID, Campaign.Name, SUM(Donor.Amount) AS Total_Donations FROM Campaign JOIN FundedBy ON Campaign.Campaign_ID = FundedBy.Campaign_ID JOIN Donor ON FundedBy.Donor_ID = Donor.Member_ID GROUP BY Campaign.Campaign_ID, Campaign.Name;", 
                "Total Donations per Campaign")
        elif choice == '2':
            # Directly call the predefined function for total expenses per event
            report_financials(conn, 
                "SELECT Event.Event_ID, Event.Name, SUM(Expenses.Amount) AS Total_Expenses FROM Event JOIN Accrue ON Event.Event_ID = Accrue.Event_ID JOIN Expenses ON Accrue.Expense_ID = Expenses.Expense_ID GROUP BY Event.Event_ID, Event.Name;", 
                "Total Expenses per Event")
        elif choice == '3':
            # Call the function to view donations
            view_donations(conn)
        elif choice == '4':
            # Call the function to view expenses
            view_expenses(conn)
        else:
            print("Invalid option. Please try again.")


def manage_campaigns(conn):
    while True:
        print("\n=== Manage Campaigns ===")
        print("1. Add New Volunteer")
        print("2. Assign Volunteer to Campaign Event")
        print("3. Schedule Event for Campaign")
        print("4. Add Event to Campaign")
        print("5. View Campaign State")
        print("B. Go Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break
        elif choice == '1':
            add_volunteer(conn)
        elif choice == '2':
            assign_volunteer_to_event(conn)
        elif choice == '3':
            schedule_event(conn)
        elif choice == '4':
            add_event_to_campaign(conn)
        elif choice == '5':
            view_campaign_state(conn)
        else:
            print("Invalid option. Please try again.")


def browse_membership_history(conn):
    # Regular expression for matching member_id format
    member_id_pattern = re.compile(r"\d{8}")

    # Input and validation for member_id
    while True:
        member_id = input("Enter Member ID to view history: ")
        if not member_id_pattern.match(member_id):
            print("Invalid Member ID format. Please enter an 8 digit number.")
            continue

        with conn.cursor() as cur:
            cur.execute("SELECT EXISTS(SELECT 1 FROM Member WHERE Member_ID = %s)", (member_id,))
            if cur.fetchone()[0]:
                break  # Member ID exists, proceed
            else:
                print("Member ID does not exist. Please enter a valid Member ID.")
                continue

    print("\n=== Membership History ===")
    
    with conn.cursor() as cur:
        # Fetch member's participation in events
        cur.execute("""
            SELECT e.Event_ID, e.Name, e.Date
            FROM Executes ex
            JOIN Event e ON ex.Event_ID = e.Event_ID
            WHERE ex.Volunteer_ID = %s
            ORDER BY e.Date;
        """, (member_id,))
        events = cur.fetchall()
        
        print("\nParticipated Events:")
        if events:
            for event in events:
                print(f"{event[0]}: {event[1]}, Date: {event[2]}")
        else:
            print("No event participation found.")

def manage_annotations(conn):
    while True:
        print("\n=== Manage Annotations ===")
        print("1. Add Annotation")
        print("2. View Annotations")
        print("B. Go Back")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'B':
            break
        elif choice == '1':
            add_annotation(conn)
        elif choice == '2':
            view_annotations(conn)
        else:
            print("Invalid option. Please try again.")


def add_annotation(conn):
    # Input the type of related ID
    while True:
        related_type = input("Enter the type of the related ID (Member/Campaign/Event): ").strip().lower()
        if related_type not in ('member', 'campaign', 'event'):
            print("Invalid input type. Please enter 'Member', 'Campaign', or 'Event'.")
            continue
        break

    # Validate and input related ID based on the input type
    while True:
        if related_type == 'member':
            related_id = input("Enter the Member ID (XXXX XXXX): ").strip()
            if len(related_id) != 8 or not related_id.isdigit():
                print("Invalid Member ID format. Please enter an 8-digit number.")
                continue
            # Check if Member ID exists in the database
            with conn.cursor() as cur:
                cur.execute("SELECT EXISTS(SELECT 1 FROM Member WHERE Member_ID = %s)", (related_id,))
                if not cur.fetchone()[0]:
                    print("Member ID does not exist. Please enter a valid Member ID.")
                    continue
        elif related_type == 'campaign':
            related_id = input("Enter the Campaign ID (XXX): ").strip()
            if len(related_id) != 3 or not related_id.isdigit():
                print("Invalid Campaign ID format. Please enter a 3-digit number.")
                continue
            # Check if Campaign ID exists in the database
            with conn.cursor() as cur:
                cur.execute("SELECT EXISTS(SELECT 1 FROM Campaign WHERE Campaign_ID = %s)", (related_id,))
                if not cur.fetchone()[0]:
                    print("Campaign ID does not exist. Please enter a valid Campaign ID.")
                    continue
        elif related_type == 'event':
            related_id = input("Enter the Event ID (XXX_EventX): ").strip()
            # Add regex pattern validation for event ID if needed
            # Check if Event ID exists in the database
            with conn.cursor() as cur:
                cur.execute("SELECT EXISTS(SELECT 1 FROM Event WHERE Event_ID = %s)", (related_id,))
                if not cur.fetchone()[0]:
                    print("Event ID does not exist. Please enter a valid Event ID.")
                    continue
        break

    note = input("Enter your annotation: ")

    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO Annotations (Related_ID, Related_Type, Note)
            VALUES (%s, %s, %s);
        """, (related_id, related_type.capitalize(), note))
        conn.commit()

    print("Annotation added successfully.")


def view_annotations(conn):
    print("\n=== View Annotations ===")
    with conn.cursor() as cur:
        cur.execute("""
            SELECT Annotation_ID, Related_ID, Related_Type, Note
            FROM Annotations
            ORDER BY Annotation_ID;
        """)
        annotations = cur.fetchall()
        if annotations:
            for annotation in annotations:
                print(f"Annotation ID: {annotation[0]}, Related ID: {annotation[1]}, Type: {annotation[2]}, Note: {annotation[3]}")
        else:
            print("No annotations found.")

def preprocess_date(date_str):
    try:
        # Regular expression to remove the ordinal suffixes from the day
        processed_date_str = re.sub(r"(?<=\d)(st|nd|rd|th),", ",", date_str)
        # Attempt to parse the date with the expected format '%B %d, %Y'
        processed_date = datetime.datetime.strptime(processed_date_str, '%B %d, %Y')
    except ValueError:
        # If parsing with the expected format fails, try parsing with '%B %d, %Y' without the suffixes
        processed_date = datetime.datetime.strptime(date_str, '%B %d, %Y')

    return processed_date

def display_event_calendar(conn):
    current_year = datetime.datetime.now().year

    with conn.cursor() as cur:
        cur.execute("SELECT Date, Name FROM Event;")
        events = cur.fetchall()

    print(f"\nEvents for the Year {current_year}:")
    for event_date, event_name in events:
        try:
            # Convert the event's date from the given format to a datetime object
            parsed_date = preprocess_date(event_date)
            if parsed_date.year == current_year:
                # If the event is in the current year, print its details
                print(f"{parsed_date.strftime('%B %d, %Y')}: {event_name}")
        except ValueError as e:
            print(f"Error processing date '{event_date}': {e}")


def execute_query(conn, query, params=None):
    try:
        cur = conn.cursor()
        if params:
            cur.execute(query, params)
        else:
            cur.execute(query)
        rows = cur.fetchall()
        cur.close()
        return rows
    except OperationalError as e:
        print(f"An error occurred: {e}")


def main_menu(conn):
    options = {
        "1": browse_queries,
        "2": lambda conn: manage_campaigns(conn), 
        "3": lambda conn: manage_donations_and_expenses(conn), 
        "4": browse_membership_history,
        "5": manage_annotations,
        "6": display_event_calendar, # Phase5
    }
    
    while True:
        print("\n=== GnG Main Menu ===")
        print("1. Browse Queries")
        print("2. Manage Campaigns")  
        print("3. Manage Donations and Expenses") 
        print("4. Browse Membership History")
        print("5. Manage Annotations")
        print("6. Display Event Calendar") # Phase5
        print("Q. Quit")
        choice = input("Select an option: ").strip()

        if choice.upper() == 'Q':
            break
        
        action = options.get(choice)
        if action:
            action(conn)
        else:
            print("Invalid option. Please try again.")



if __name__ == '__main__':
    conn = create_connection()
    if conn is not None:
        main_menu(conn)
        conn.close()
    else:
        print("Failed to connect to the database")
