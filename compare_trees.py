#!/usr/bin/env python

# python 3

from ete3 import Tree
# from ete3 import Nexml
import csv
import sys
import os.path

# argv[1] - reference species newick tree file	*
# argv[2] - species tree to compare
# argv[3] - list of leaves to remove/keep change in code		*.remove_leaves

f1 = open(sys.argv[1], "r")
for line1 in f1:
	ref_tree = Tree(line1, format=1)

f2 = open(sys.argv[2], "r")
for line2 in f2:
	q_tree = Tree(line2, format=1)
ref_leaves=[]
for node1 in ref_tree.get_leaves():
	ref_leaves.append(node1.name)
#print(ref_leaves)
#print(len(ref_leaves))

q_leaves=[]
for node2 in q_tree.get_leaves():
        q_leaves.append(node2.name)
#print(q_leaves)
#print(len(q_leaves))

## If keep the leaves
keep_leaves=[]
f3 = open(sys.argv[3], "r")
for line3 in f3:
	print(line3)
	keep_leaves.append(line3.strip())
print(keep_leaves)
ref_tree.prune(keep_leaves)
print(ref_tree)
print(ref_tree.write())

#keep_leaves = [x for x in ref_leaves if x in q_leaves]
#print(keep_leaves)
#print(len(keep_leaves))

#ref_tree.prune(q_leaves)	# To prune reference tree to only keep query tree leaves
#print(ref_tree)

rf=ref_tree.robinson_foulds(q_tree,unrooted_trees=True)
#print(rf)	# Output: rf, rf_max, common_attrs, names, edges_t1, edges_t2, discarded_edges_t1, discarded_edges_t2
