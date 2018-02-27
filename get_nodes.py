#!/usr/bin/env python2.7

from ete2 import Tree
from ete3 import Nexml
import csv
import sys

# argv[2] - newick tree file

def collapsed_leaf(node):
    if len(node2labels[node]) == 1:
       return True
    else:
       return False

f = open(sys.argv[1], "r")
for line in f:
	t = Tree(line, format=1)

if len(sys.argv) > 2:
  if sys.argv[2] in t:
    t.set_outgroup(sys.argv[2])
# We create a cache with every node content
node2labels = t.get_cached_content(store_attr="name")
# print node2labels
# print t.get_ascii(show_internal=True)

# for n in t.traverse():
#   print n.name,"\t",
#   for i in node2labels[n]:
# 		print i,
#   print "\n",

for n in t.traverse():
  print n.name,"\t",
  # print n.dist,
  for i in n.get_descendants():
    if i.is_leaf():
      id=i.name
      print i.name.lstrip('0123456789_'),
    else:
      print i.name,
  print "\n",
  # for i in node2labels[n]:
    # print i,
  # print "\n",