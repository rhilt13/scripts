#!/usr/bin/env python2.7

from ete2 import Tree
# from ete3 import Nexml
import csv
import sys
import os.path

# argv[1] - newick tree file 			*
# argv[2] - outgroup
# argv[3] - list of leaves to remove 	*.remove_leaves
# argv[4] - list of clade ids to prune	*.collapse_list
# argv[5] - output tree filename 		*.col 
# argv[6] - output for hierarchy of nodes 	*.col.nodes

def collapsed_leaf(node):
		if len(node2labels[node]) == 1:
			 return True
		else:
			 return False

f = open(sys.argv[1], "r")
for line in f:
	t = Tree(line, format=1)
# print t
# print t.get_ascii(show_internal=True)

if len(sys.argv) > 2:
	if sys.argv[2] in t:
		t.set_outgroup(sys.argv[2])

# Create a cache with every node content
node2labels = t.get_cached_content(store_attr="name")

all_leaves=[leaf.name for leaf in t]
# print all_leaves
# print len(all_leaves)

# print leaf.name
remove_leaves=list()
if len(sys.argv) > 3:
	if (os.path.isfile(sys.argv[3])):
		with open(sys.argv[3]) as f:
			remove_leaves=[line.rstrip('\n') for line in f]
		# print remove_leaves
		# print len(remove_leaves)
		keep_leaves = [x for x in all_leaves if x not in remove_leaves]
		# print keep_leaves
		# print len(keep_leaves)
		t.prune(keep_leaves)
# print t1.get_ascii(show_internal=True)

#########################################
## If wish to remove internal nodes to change levels
# remove_nodes=['I48']
# # print remove_nodes
# for n in t.traverse():
# 	if n.name in remove_nodes:
# 		J = t.search_nodes(name=n.name)[0]
# 		J.delete()
#########################################

if len(sys.argv) > 4:
	ids=list()
	with open(sys.argv[4]) as f:
		ids1=[line.rstrip('\n') for line in f]
			# ids.append(line.rstrip('\n').split(','))
		ids=[x for x in ids1 if x not in remove_leaves]
	for n in t.traverse():
		if n.name in ids:
			# print n.name
			for i in n.get_children():
			# for i in n.get_descendants():
				# print i.name
				J = t.search_nodes(name=i.name)[0]
				J.detach()
				# print J
print t.get_ascii(show_internal=True)

if len(sys.argv) > 5:
	t.write(format=1, outfile=sys.argv[5])

if len(sys.argv) > 6:
	file1=open(sys.argv[6],"w")
	for n in t.traverse():
		file1.write(n.name+"\t")
		for i in n.get_leaves(): # descendants
			file1.write(i.name+" ")
		file1.write("\n",)
	file1.close()
# print node2labels
# ancestor = t.get_common_ancestor("C", "J", "B")
# for n in t.traverse():
# 	# print n.name, "node %s contains %s tips" %(n.name, len(node2labels[n]))
# 	if n.name in leaves:
# 		print n.name, "node %s contains %s tips" %(n.name, len(node2labels[n]))
# 		print "=====>>>>>LEAF defined"

# print t.write(is_leaf_fn=collapsed_leaf)


# t2 = Tree( t.write(is_leaf_fn=collapsed_leaf) )
# print t2.get_ascii(show_internal=True)
# '''
