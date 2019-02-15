#!/usr/bin/env python

import networkx as nx
import sys 

def main(args):
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
		 type=FileType('r'), required=True,
		 help='List file with 3 tab separated columns: Node1, Node2 and Edge weight.')
	parser.add_argument('-q', dest='pos', action='store',
		 type=str,
		 help='Query node to find neighbors')
	args = parser.parse_args()
	main(args)