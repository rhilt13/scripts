#!/usr/bin/python

# Author: Daniel Ian McSkimming

from subprocess import call
from shutil import move
from os.path import exists
from os import makedirs
from collections import defaultdict
from glob import glob

## use ~/rhil_project/scripts/pdb_data.pl script to parse out the 
## pdb structure and residue number information that you want from these output.

## analyze_structures_new.py 2rj7.pdb
## analyze_structures_new.py *.pdb


def run_one(pdb, base, software):
    struct = pdb.split('/')[-1][:-4]
    call(['pdb2pqr', '--ff=amber', '--chain', pdb, base+'PQR/'+struct+'.pqr'])
    call([software+'dssp-2.0.4-linux-amd64', pdb], stdout=open(base+'/2oSTRUCT/'+struct+'.dssp', 'w'))
    call(['perl',software+'extract_acc.pl', base+'2oSTRUCT/'+struct+'.dssp'], stdout=open(base+'/SURF_AREA/'+struct+'.asa', 'w'))
    call([software+'split_ener','-i', base+'PQR/'+struct+'.pqr', '-a', base+'SURF_AREA/'+struct+'.asa'], stdout=open(base+'/ENERGY/'+struct+'.ener', 'w'))
    call([software+'min_dist', '-i', base+'PQR/'+struct+'.pqr','-d','10.0'], stdout=open(base+'DISTANCE/'+struct+'.min', 'w'))
    return

def run_all(args):
    for x in args.pdbs:
        move(x,args.base+'PDB')
        struct = x.split('/')[-1][:-4]
        print "####",struct
        newx = args.base+'PDB/'+struct+'.pdb'
        call([args.software+'split_chain', newx])
        move(newx,args.base+'PDB/orig')
        files = glob(args.base+'PDB/'+struct+'*')
        for y in files:
            print y
            run_one(y, args.base, args.software)
        break
    return

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Analyze pdb structure(s)')
    parser.add_argument('pdbs', nargs='+', help='pdbs for analysis')
    parser.add_argument('--software', action='store', default='/auto/share/Data/UPDATE_PDBS/software/', help='software directory')
    parser.add_argument('--base', action='store', default='./', help='base directory')
    
    args = parser.parse_args()

    for dirs in ['PDB', 'PDB/orig', 'PQR', '2oSTRUCT', 'SURF_AREA', 'DISTANCE', 'ENERGY']:
        if not exists(dirs):
            makedirs(dirs)

    run_all(args)
