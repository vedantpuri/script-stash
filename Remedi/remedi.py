import os
import sys
import csv
import json
import argparse
import datetime

# Constants
ERROR_MESSAGE_HEADER = "-" * 20 + "ERROR" + "-" * 20
METADATE_FILE = ".remedi_store.json"
REMINDER_LIST_TITLE = "Remedi List"
TMP_ASCPT = "tmp.scpt"
DIVIDER = "-"*30


def validate_date_fmt(date_str):
    """Check if expiry date is in correct format"""
    try:
        date_obj = datetime.datetime.strptime(date_str, "%m/%y")
        return date_obj
    except ValueError:
        return None

def get_fmt_err(idx_list):
    """Create formatted error message for wrong expiry date format"""
    s = f"\033[91m{ERROR_MESSAGE_HEADER}"
    s += "These line numbers have an issue with the date format.\n"
    for idx in idx_list:
        s += str(idx) + "\n"
    s += "Please adhere to MM/YY or MM/YYYY date format.\nMake the fixes and rerun.\033[0m"
    return s


def read_csv(file_name, running_update=False):
    """
    Read the CSV file
    :param file_name:   Path to the CSV file
    :return:            Dict with keys as dates of expiry, value is a list of items and notes
    """
    if not os.path.isfile(file_name):
        if running_update:
            err_and_exit(
                f"It appears that the source file has been renamed or deleted. Re-run with init."
            )
        else:
            err_and_exit(
                f"Could not find {file_name}. Please ensure you entered the correct file-path and Re-run."
            )
    print("Reading CSV ...")
    remedi_store = {}
    file = open(file_name)
    csv_reader = csv.reader(file)
    faulty_lines = []
    for idx, row in enumerate(csv_reader):
        # Skip title line
        if idx != 0:
            medicine_name, expiry_dt, notes = row[0], row[1], row[2]
            date_obj = validate_date_fmt(expiry_dt)
            if not date_obj:
                faulty_lines += [idx + 1]
            else:
                if date_obj not in remedi_store:
                    remedi_store[date_obj] = []
                remedi_store[date_obj] += [(medicine_name, notes)]
    if faulty_lines:
        err_and_exit(get_fmt_err(faulty_lines))
    print("Reading Successfully complete.")
    return remedi_store

def store_metadata(metadata_dict):
    """
    Store metadate in JSON
    :param metadata_dict:   A dictionary containing metadata
    """
    print(f"Storing metadata ...")
    with open(METADATE_FILE, "w") as outfile:
        json.dump(metadata_dict, outfile, indent=2)
    print(f"Succeffully stored  metadate in {METADATE_FILE}")

def create_reminder_str(exp_dict, warning_period):
    """
    Create apple script string to create reminders
    :param exp_dict:        Dictionary containing expiry dates and items, notes
    :param warning_period:  Warning period for reminder
    """
    ascript_str = f'tell application "Reminders"\n  if not (exists list "{REMINDER_LIST_TITLE}") then\n    make new list with properties {{name:"{REMINDER_LIST_TITLE}"}}\n  end if\n   set mylist to list "{REMINDER_LIST_TITLE}"\n    tell mylist\n'
    for k, v in exp_dict.items():
        for med in v:
            dt = (k - datetime.timedelta(days=warning_period)).strftime("%m/%d/%Y")
            ascript_str += f'       make new reminder at end with properties {{name:"{med[0]} Expiring in {warning_period} days", due date:date "{dt}", body:"{med[1]}"}}\n'
    ascript_str += '    end tell\nend tell'
    return ascript_str

def run_ascript(scpt_str):
    """
    Run an apple script command
    :param scpt_str:    The script as a space formatted string
    """
    with open(TMP_ASCPT, "w") as f:
        f.write(scpt_str)
    os.system(f"osascript {TMP_ASCPT}")

def make_reminders(remedi_store, warning_period):
    """
    Create Reminders in the Reminders app
    :param remedi_store:    Dictionary holding data in efficient format
    :param inp_file:        Path to CSV file containing the data
    :param warning_period:  Days in advance you want to be notified
    """
    print("Creating Reminders ...")
    scpt_str = create_reminder_str(remedi_store, warning_period)
    run_ascript(scpt_str)
    print("Reminders Successfully added")

def err_and_exit(msg):
    """Print an error message and exit"""
    print(msg)
    exit()

def run_update():
    """Perform an update in Reminders, reflecting latest changes from csv"""
    rem_ascript_str = f'tell application "Reminders"\n  if (exists list "{REMINDER_LIST_TITLE}") then\n    delete list "{REMINDER_LIST_TITLE}"\n  end if\nend tell'
    if not os.path.isfile(METADATE_FILE):
        err_and_exit(
            f"It appears this is your first time running remedi. Please run with the init option"
        )
    with open(METADATE_FILE) as f:
        data = json.load(f)
        input_file = data['input_file']
        warning_period = data['warning_period']
        print("Performing Update ...")
        print("Removing previous reminder list ...")
        run_ascript(rem_ascript_str)
        print("Successfully removed")
        print("Creating fresh list of reminders ...")
        make_reminders(read_csv(input_file, True), warning_period)
        print("Update complete.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parser for script args")
    parser.add_argument(
        "-i",
        "--init",
        required=False,
        help="Initialize Remedi",
        action="store_true",
    )
    parser.add_argument(
        "-wp",
        "--warning-period",
        required="--init" in sys.argv or "-i" in sys.argv,
        type=int,
        choices=range(1, 365 * 101),
        help="Number of days in advance you want to be notified before items in your list perish",
        metavar='',
    )
    parser.add_argument(
        "-f",
        "--file",
        required="--init" in sys.argv or "-i" in sys.argv,
        help="Path to the CSV where your list is defined",
        metavar='',
    )
    parser.add_argument(
        "-u",
        "--update",
        required=False,
        help="Update the reminders to reflect new stock or any other changes made to the input file",
        action="store_true",
    )
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"{DIVIDER}\n{time_now} : Running remedi")
    args = parser.parse_args()
    if args.init:
        exp_dict = read_csv(args.file)
        store_metadata({"input_file": args.file, "warning_period": args.warning_period})
        make_reminders(exp_dict, args.warning_period)
    elif args.update:
        run_update()
    else:
        parser.print_help()
