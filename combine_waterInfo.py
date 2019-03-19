#!/usr/bin/env python

import sys
import pyfpgrowth

# combine_waterInfo.py water-interact_resAll.txt.e5.rep > water-interact_resAll.txt.e5.rep.net
interact=dict()
with open(sys.argv[1],'r') as file:
	for line1 in file.readlines():
		line1=line1.strip()
		cols=line1.split('\t')
		key=cols[0]+"."+cols[1]+"."+cols[3]+"."+str(cols[8])
		if key in interact:
			# a=7
			# interact[key]+=" "+cols[1]+"-"+cols[2]+"-"+cols[5]+"-"+cols[6]+"-"+cols[8]
			# interact[key]+=" "+cols[7]
			interact[key].append(cols[7])
		else:
			interact[key]=[]
			# print interact[key],type(interact[key])
			# interact[key]=" "+cols[7]
			interact[key].append(cols[7])
			# print val
			# interact[key][0]=val
		# print key
# print interact
interact_list=list()
for k in interact:
	interact_list.append(interact[k])
	# print k,"\t",
	# for m in interact[k]:
	# 	print m+",",
	# print
# print interact_list

patterns = pyfpgrowth.find_frequent_patterns(interact_list, 10)
for j in patterns:
	if (len(j)>1):
		if (abs(int(j[0])-int(j[1]))>2):
			print j,"\t",len(j),"\t",patterns[j]
# rules = pyfpgrowth.generate_association_rules(patterns, 0.7)
# # for j in rules:
# # 	printq j,"\t",rules[j]
