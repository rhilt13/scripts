#! /usr/bin/env python

# Ver: 1.0

import sys
from Bio.PDB import PDBParser

# create parser
parser = PDBParser()

Strname=sys.argv[1]
if (len(sys.argv)>2):
    chID=sys.argv[2]
else:
    chID='A'
if (len(sys.argv)==4):
    distCutoff=sys.argv[3]
# read structure from file
structure = parser.get_structure('Str1', Strname)

model = structure[0]
chain = model[chID]

# this example uses only the first residue of a single chain.
# it is easy to extend this to multiple chains and residues.

## ATOMS:
# N CA C O CB Everything except these.. calculate distance
main_atoms = ['N','CA','C','O','CB']
aa = ['ALA','ARG','ASN','ASP','CYS','GLN','GLU','GLY','HIS','ILE','LEU','LYS','MET','PHE','PRO','SER','THR','TRP','TYR','VAL']
water=['HOH']
lig=['NAG','NGA','UDP']
aawat= aa + water
# print main_atoms
resolution = structure.header['resolution']
# print "#Resolution of",Strname,"=",resolution

# for residue1 in chain:
#     for a in residue1:
#         if residue1.get_resname() not in aawat:
#             print residue1, residue1.get_resname(), a #, #residue1[a]
#     # break


for residue1 in chain:
    for residue2 in chain:
        best_dist=1000
        final_out=''
        if residue1.get_resname() not in aawat and residue1 != residue2 and residue2.get_resname() in aawat:
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
                                # if len(sys.argv)==4 and distance < float(distCutoff):
                                #     print Strname,"\t",chID,'\t'.join([str(a) for a in out])

                                # print out

                            except KeyError:
                        ## no CA atom, e.g. for H_NAG
                                continue
            # print final_out
            if len(sys.argv)==3:
                if len(final_out)>0:
                    print '\t'.join([str(a) for a in final_out])
            elif len(sys.argv)==4:
                if best_dist < float(distCutoff):
                    print Strname,"\t",chID,'\t'.join([str(a) for a in final_out])
                            # if distance < 10:
                                # print residue1.get_resname(), residue1.get_id()[1], atom1.get_name(),atom1.get_bfactor(), residue2.get_resname(), residue2.get_id()[1], atom2.get_name(), atom1.get_bfactor(), distance 
                            # stop after first residue
        # break
