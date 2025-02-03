For phase 5 I decided to implement a calendar feature that showcases the upcoming events.

The code preprocesses dates by attempting to parse them in a specified format, handling cases where the date might contain ordinal suffixes, and then displays events for the current year from a database table.

The code for the function is below:

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
