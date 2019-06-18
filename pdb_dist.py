#! /usr/bin/env python

# Ver: 1.0

import sys
from Bio.PDB import PDBParser

# create parser
parser = PDBParser()

Strname=sys.argv[1]
# read structure from file
structure = parser.get_structure('Str1', Strname)

model = structure[0]
chain = model['A']

# this example uses only the first residue of a single chain.
# it is easy to extend this to multiple chains and residues.

## ATOMS:
# N CA C O CB Everything except these.. calculate distance
main_atoms = ['N','CA','C','O','CB']
# print main_atoms
resolution = structure.header['resolution']
print "#Resolution of",Strname,"=",resolution
# for residue1 in chain:
#     for a in residue1:
#         print residue1, a #, #residue1[a]
#     # break
for residue1 in chain:
    for residue2 in chain:
        best_dist=1000
        final_out=''
        if residue1 != residue2:
            # if residue1.get_id()[1] == 227:
            # print residue1
            # print type(residue1)
            # print residue2
            # compute distance between CA atoms
            for atom1 in residue1:
                # print atom1,atom1.get_name(),type(atom1)
                # if (str(atom1.get_name()) not in main_atoms):
                    # print ">>>>>>>",atom1
                    for atom2 in residue2:
                        # print atom2,atom2.get_name(),type(atom2)
                        # if (str(atom2.get_name()) not in main_atoms):
                            # print "##>>>>>>",atom2
                            try:
                                distance = residue1[atom1.get_name()] - residue2[atom2.get_name()]
                                out=residue1.get_resname(),residue1.get_id()[1],atom1.get_name(),atom1.get_bfactor(),residue2.get_resname(),residue2.get_id()[1],atom2.get_name(),atom2.get_bfactor(),distance
                                
                                if float(distance)<float(best_dist):
                                    # print out, ",,",best_dist
                                    final_out=out
                                    best_dist=distance
                                # print out

                            except KeyError:
                        ## no CA atom, e.g. for H_NAG
                                continue
            # print final_out
            if (len(final_out)>0):
                print '\t'.join([str(a) for a in final_out])
                            # if distance < 10:
                                # print residue1.get_resname(), residue1.get_id()[1], atom1.get_name(),atom1.get_bfactor(), residue2.get_resname(), residue2.get_id()[1], atom2.get_name(), atom1.get_bfactor(), distance 
                            # stop after first residue
        # break
