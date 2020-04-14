#!/usr/bin/env python
# python 3
from ete3 import Tree
import sys
# argv[1] - reference species newick tree file  *
f1 = open(sys.argv[1], "r")
for line1 in f1:
        ref_tree = Tree(line1, format=1)
for node1 in ref_tree.get_leaves():
        print(node1.name)
