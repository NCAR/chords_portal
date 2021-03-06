#! /usr/local/bin/python
import argparse
import sh
import os
import platform
import sys
from datetime import datetime, timedelta

# If set True, add some diagnostic printing.
verbose = False

# Terminal control characters
termBoldOn = '\033[1m'
termBoldOff = '\033[0m'
if os.name == 'nt':
    termBoldOn = ''
    termBoldOff = ''

# Platform characteristics
os_name = os.name
os_arch = platform.uname()[4]

#####################################################################
"""
Manage the command line options.
The options are collated in a dictionary keyed on the option long name.
The option dictionary will only contain the options that are present on the command line.
"""
class CommandArgs:
    def __init__(self):
        description = """
A CHORDS utility to download a range of days of data for a collection of instruments.
        
A start-through-end range of days is specified, along with a list of instrument ids.
A single zip file for each day is created, containing individual files for
each instrument. Note that the data files each have the name "instrument-<id>.csv".
This is convention provided by CHORDS when a multi-instrument download is requested.

"""

        epilog = """
If --end is not supplied, the end date is set to the begin
date + one day, .i.e a single day will be processed. 
If --ids is not supplied, all instruments will be fetched.

""" + "This operating system is " + os_name + ", the architecture is " + os_arch + "."
        parser = argparse.ArgumentParser(description=description, epilog=epilog, formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument("--ip",    action="store", required=True, help="IP of CHORDS portal")
        parser.add_argument("--ids",   action="store", default=None, help="comma separated list of instrument ids")
        parser.add_argument("--format",action="store", required=True, help="csv|geojson")
        parser.add_argument("--test",  action="store_true", default=False, help="include test observations")
        parser.add_argument("--begin", action="store", required=True, help="begin date: yyyy-mm-dd")
        parser.add_argument("--end",   action="store", default=None, help="end date:yyyy-mm-dd")
        parser.add_argument("--prefix",action="store", default="", help="(optional) output file name prefix")
        parser.add_argument("-v", "--verbose", action="store_true", default=False, help="verbose output (optional)")

        # Parse the command line. 
        args = parser.parse_args()
    
        if (args.format != 'csv' and args.format != 'geojson'):
            parser.print_help()
            exit(1)

        args.begin = self.get_date(args.begin)

        if args.end:
            args.end = self.get_date(args.end)
        else:
            args.end = args.begin + timedelta(days=1)
    
        if args.ids:
            id_chars = '0123456789,'
            if not set(args.ids).issubset(set(id_chars)):
                print('Only the characters "' + id_chars + '" are allowed in the instrument identifiers.')
                exit(1)
            
        # If no switches, print the help.
        if not sys.argv[1:]:
            parser.print_help()
            parser.exit()

        self.options = vars(args)

    def get_options(self):
        """
        Return the dictionary of existing options.
        """

        return self.options

    def get_date(self, s):
        try:
            return datetime.strptime(s,"%Y-%m-%d")
        except ValueError as e:
            print('Error in date "' + s + '", use format YYYY-M-D')
            exit(1)

class CHORDS_curl:
    def __init__(self, ip, ids, format, test_data, begin, end, prefix):
        self.ip = ip
        self.ids = ids
        self.format = format
        self.test_data = test_data
        self.begin = self.timestamp(date=begin)
        self.end = self.timestamp(date=end)
        self.prefix = prefix

    def timestamp(self, date):
        t = date.strftime("%Y-%m-%dT00Z")
        return t

    def get_data(self):
        endpoint = "http://" + self.ip + "/api/v1/data.%s?" % (self.format) + "start=" + self.begin + "&end=" + self.end
        if self.ids:
            endpoint += "&instruments=" + self.ids
        if self.test_data:
            endpoint += "&include_test_data=true"
        if self.format == 'csv':
            file_ext = '.zip'
        else:
            if self.format == 'geojson':
                file_ext = '.geojson'
            else:
                file_ext = ''

        filename = self.prefix+"chords-" + self.begin + "-" + self.end + file_ext
        print(filename + ":", endpoint)
        sh.curl("-L", endpoint, "--output", filename)

#####################################################################
if __name__ == '__main__':
    # Get the command line options
    options = CommandArgs().get_options()

    test_data = options["test"]
    this_day = options["begin"]
    while this_day <= options["end"]:
        c = CHORDS_curl(ip=options["ip"], ids=options["ids"], format=options["format"],
            test_data=test_data, prefix=options["prefix"],
            begin=this_day, end=this_day+timedelta(days=1))
        c.get_data()
        this_day += timedelta(days=1)
