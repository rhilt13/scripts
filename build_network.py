#!/usr/bin/env python

import networkx as nx
import sys 
import pyfpgrowth
import re
import itertools

# build_network.py -f nr_rev12sel3.pttrns.padded.fam.mechanism.Retaining.mainfam.25pos.pairs -q Pos140
#build_network.py -g nr_rev12sel3.pttrns.padded.fam.mechanism.Retaining.mainfam.25pos

def main(args):	
	if (args.pttrn):
		interact=dict()
		file2=args.pttrn
		count=dict()
		with file2 as f2:
			for line2 in f2.readlines():
				line2=line2.strip()
				cols=line2.split('\t')
				# Define columns
				level=cols[0]
				FileNum=cols[1]
				Set=cols[2]
				mainfam=cols[3]
				fam=cols[4]
				mech=cols[5]
				pt=cols[6]
				# key=cols[0]+"-"+cols[1]+"-"+cols[2] # Old pttrn file
				key = Set+"-"+mainfam+"-"+mech	# New pttrn file with added cols
				interact[key]=[]
				# cols[4] = re.sub('[A-Z]', '', cols[4]) # Old
				pt = re.sub('[A-Z]', '', pt) # New
				# print cols[4]
				positions = pt.split(',')
				for posNum in positions:
					interact[key].append(posNum)
		# print interact
		interact_list=list()
		for k in interact:
			# interact_list.append(interact[k])
			# print k,"\t",interact[k]
			for m,n in itertools.combinations(interact[k],2):
				# print m,"==",n
				if (m<n):
					p1=m+'-'+n
				else:
					p1=n+'-'+m
				if (p1 in count):
					count[p1]+=1
				else:
					count[p1]=1
		# print interact_list
		for c in count:
			print mech,"\t",c,"\t",count[c]
		# patterns = pyfpgrowth.find_frequent_patterns(interact_list, 2)
		# for j in patterns:
		# 	if (len(j)>1):
		# 		# print j[0], j
		# 		if (abs(int(j[0])-int(j[1]))>2):
		# 			print mech,"\t",j,"\t",len(j),"\t",patterns[j]
		# rules = pyfpgrowth.generate_association_rules(patterns, 0.9)
		# for j in rules:
		# 	print j,"\t",rules[j]#[0]


	else:
		file=args.infile
		query=args.pos
		G=nx.Graph()
		with file as f:
			for line in f.readlines():
				n1,n2,Ewt=line.strip().split('\t',2)
				G.add_edge(n1,n2,wt=int(Ewt))
		# print G.edges()
		# print G["Pos93"].items()[1][1]['wt']
		neighbors=sorted(G[query].items(), key=lambda edge: edge[1]['wt'])
		print query,":"
		print neighbors[-3]
		print neighbors[-2]
		print neighbors[-1]
		# for n in neighbors:
		# 	print n
		# edgewidth = [ d['weight'] for (u,v,d) in G.edges(data=True)]
		# pos = nx.spring_layout(G, iterations=50)


if __name__ == '__main__':

	from argparse import ArgumentParser
	from argparse import FileType


	parser = ArgumentParser(description=sys.__doc__)
	parser.add_argument('-f', dest='infile', action='store',
		 type=FileType('r'),
		 help='List file with 3 tab separated columns: Node1, Node2 and Edge weight.')
	parser.add_argument('-q', dest='pos', action='store',
		 type=str,
		 help='Query node to find neighbors')
	parser.add_argument('-g', dest='pttrn', action='store',
		 type=FileType('r'),
		 help='List of patterns to generate network from/Alternative network')
	args = parser.parse_args()
	main(args)