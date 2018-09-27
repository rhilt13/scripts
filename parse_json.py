
# python ~/scripts/parse_json.py INETA_DB.json |sed 's/\[/,/g;s/\]//g;' > inetaCS.csv

import json
import sys
# from pprint import pprint

# with open(sys.argv[1], 'r') as data_file:    
#    raw_data=data_file.read()
#    data = json.loads(raw_data)

jsonFile = open(sys.argv[1], 'r')
data = json.load(jsonFile)
jsonFile.close()

# pprint(data)

# for d in data:
# 	# print d
# 	name= d.split('::',5)[2]
# 	code= d.split('::',5)[1]
# 	# print name,data[d]["ChemicalShifts"]
# 	print code,",",name,

# 	for i in data[d]["ChemicalShifts"]:
# 		print data[d]["ChemicalShifts"][i],
# 	print

for d in data:
	print ['input']['MLE']['content'][0]


# g=0
# for d in data:
# 	# print d
# 	g+=1;
# 	name= d.split('::',5)[2]
# 	code= d.split('::',5)[1]
# 	# print name,data[d]["ChemicalShifts"]
# 	print g,code,",",name,
# 	print data[d]["Networks"],
# 	print