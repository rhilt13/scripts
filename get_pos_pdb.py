#!/usr/bin/env python2.7

import sys
from Bio.PDB import PDBParser
from Bio.PDB.Polypeptide import PPBuilder 

parser = PDBParser(PERMISSIVE=1)
Strname=sys.argv[1]
structure = parser.get_structure('Str1', Strname)
model = structure[0]
pdb_id=Strname.split('/')[-1].replace(".pdb","").upper()
# pdb_id=pdb_id.replace()
# print pdb_id
for chain in model:
	for res1 in chain:
		print pdb_id+"_"+chain.get_id()+"\t"+res1.get_resname()+"\t"+str(res1.get_id()[1])
		# print "%s_%s\t%s\t%s",pdb_id,chain.get_id(),res1.get_resname(),res1.get_id()[1]
		break