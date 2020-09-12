![Header](../.resources/remedi_hero.png)

Simple program to ingest your medicine list with expiry dates and add appropriate reminders x number of days before the expiry. Sets reminders in your apple Reminders app, so they are available across all your synced apple devices!

## Motivation
I am an international student who is now working in the US. Naturally, I carried a set of medicines with me from home. A recent allergic reaction made me realize that many of my antihistamines had expired or were soon expiring. Hence I wanted a mechanism to remind me whenever my medicines were going to expire so that I could make arrangements in advance.

This project probably has a much larger scope than just for medicines. It could be used to track anything you want and remind you prior to a certain date. It is much more convenient than setting up reminders for individual items in a list. Create a list once, run a command, and you're all set!

I did not explore the internet to confirm if something like this existed since I simply wanted to build it myself to go through the experience and enjoy the phenomena of coding up an idea.

## Requirements
- Python >= **3.7.5** (lower versions untested)
- MacOS (tested on Catalina)

## Installation
1. Clone this repository
2. (Optional) Relocate ```remedi.py``` to a location of your choice
3. Navigate to the project in your terminal
4. Run with initialization option (see Options for other required args)

## Usage
One of the ways to run this script is:
```
python remedi.py --init -f medz.csv -wp 45
```
**Disclaimer:** Wherever the script is stored, a file is created in that directory with the name of ```.remedi_store.json``` to store some metadata. Please do not delete this file. If deleted you may need to run with init again. Feel free to view the  file, it simply stores the path to the source CSV file and the warning period you have set. The main reason to do this was so that you don't need to run a long command everytime, once things are initialized, you can perform an update with a simple command.
When setup correctly, the script will create a new Reminder List: "Remedi List" in your reminders app and add reminders ```warning_period``` number of days before the expiries. You must run the script with the update option if you make any changes to the CSV and want them to be accounted for


## Options
| Option | Description| Required |  Value specs (if any) |
|:-------------:|:-------------:|:-------------:|:-------------:|
| -i/--init |  Initialize the script | No | NA |
| -wp/--warning-period  | Number of days in advance you want to be notified before items in your list perish | Yes if running with -i | Unit is pre-set to days|
| -f/--file | Path to the CSV where your list is defined | Yes if running with -i | Please provide path within quotes to avoid issues with spaces|
| -u/--update | Update(Recreate) the reminders to reflect new stock or any other changes made to the input file | No | By default we use the same CSV path that was used in initialization |


## Input file specification
- Needs to be a CSV file
- Date Format ```MM/YY``` or ```MM/YYYY```
- For now please restrict to using 3 columns in the CSV. Here is the template:
```csv
Name,Expiry date,Notes
Med A,"10/20",Antihistamine
Med B,08/20,Cold
Med C,01/22,Cough
Med D,03/22,Headache
```

## Future Work/Ideas
- Don't recreate json when updating, only modify
- Segment by category and add priorities
- Track quantity
- Auto sync files
- Handle multiple sheets in a file
- Support list of expiry in a single item
- Better ways of reminding/notification system
- QR scanning to automatically add to list (replacement for CSV) [Need to make this an app at that point]

## License
 The script is available under the **MIT** License. Check out the [license ](https://github.com/vedantpuri/remedi/blob/master/LICENSE.md) file for more information.
