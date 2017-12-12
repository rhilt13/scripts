import nmrpystar
import sys

with open(sys.argv[1], 'r') as data_file:
	raw_data=data_file.read()
data=nmrpystar.parse(raw_data)

if data.status == 'success':
    print 'it worked!!  ', data.value
else:
    print 'uh-oh, there was a problem with the string I gave it ... ', data
