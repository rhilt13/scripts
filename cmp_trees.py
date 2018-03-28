#! /usr/bin/env python

import __main__
from ete2 import Tree

def main(args):

	rf={}
	max_rf={}
	name=list()
	with open(args.listfile, 'r') as inlist1:
		for line1 in inlist1.readlines():
			line1=line1.strip()
			name.append(line1)
			t1=Tree(line1)
			rf[line1]={}
			max_rf[line1]={}
			with open(args.listfile, 'r') as inlist2:
				for line2 in inlist2.readlines():
					line2=line2.strip()
					t2=Tree(line2)
					rf_result=t1.robinson_foulds(t2,unrooted_trees=True)
					rf[line1][line2]=rf_result[0]
					max_rf[line1][line2]=rf_result[1]
	col_width = max(len(word) for word in name) + 2
	col_width2=4
	for key1,val1 in sorted(rf.items()):
		print "".join(key1.ljust(col_width)),
		tot=0
		ct=0
		for key2,val2 in sorted(rf.items()):
			ct+=1
			print "".join(str(rf[key1][key2]).ljust(col_width2)),
			tot+=rf[key1][key2]
		avg=tot/ct
		print "="+"".join(str(avg).ljust(col_width2)),
		print

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Compare trees and calculate Robinson-Foulds distance",
           epilog="Contact Rahil for help.")
    parser.add_argument('-l', '--listfile', help='List of trees to compare with path', required=True)
    parser.add_argument('-o', '--output', help='Output file to store the output matrix.', required=False)

    args = parser.parse_args()
    main(args)