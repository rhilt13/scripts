#!/usr/bin/env python
import __main__
import pymol
from os import path, environ
import re

# create a dssp folder and copy dssp of all selected pdbs

def parse_pdbDetails(file):
	store={}
	with open(file, 'r') as listfile:
		for line in listfile.readlines():
			pdb,domain,patterns=line.strip().split('\t',2)
			store[pdb]={}
			store[pdb]['patterns']={}
			ends,chain=domain.split(',')
			levels=patterns.split('\t')
			# print type(patterns)
			for level in levels:
				clas,pat=level.split(',')
				p=pat.split(' ')
				res_list=list()
				for i in p:
					num=re.sub("[^0-9]","",i)
					# print type(pdb),type(clas)
					# print clas,pat,num
					res_list.append(num)
				store[pdb]['chain']=chain
				store[pdb]['ends']=ends
				store[pdb]['patterns'][clas]=res_list
	return store

def map_aligned_pos(cma_file,start_dict):
	pos_ct={}
	# pos_ct['aln']={}
	# pos_ct['gapped']={}
	# pos_ct['full']={}
	with open(cma_file, 'r') as infile:
		for line in infile.readlines():
			if (line.startswith('>')):
				seqID=line.split(" ", 1)[0].split("_", 1)[0][1:].strip()	## Remove description and chain no from pdb ID 2z86_A
				# print seqID
			elif (line.startswith('{')):
				if seqID not in start_dict:
					print ">>>>>PDB details not found in",args.listfile,"for pdb",seqID
					continue
				pos_ct[seqID]={}
				res[seqID]={}
				ct_aln=0
				ct_gapped=0
				ct_all=0
				ct_full=int(start_dict[seqID]['ends'].split("-")[0])-1
				line=re.sub(r'[\{\}\(\)\*]', '',line)
				for ch in list(line):
					if ch.islower():
						ct_all+=1
						ct_full+=1
						pos_ct[seqID][ct_gapped]=ct_full
						res[seqID][ct_all]=ch+str(ct_full)
					elif ch.isupper():
						ct_all+=1
						ct_full+=1
						ct_aln+=1
						ct_gapped+=1
						pos_ct[seqID][ct_gapped]=ct_full
						res[seqID][ct_all]=ch+str(ct_full)
					else:
						ct_all+=1
						ct_gapped+=1
						pos_ct[seqID][ct_gapped]=ct_full
						res[seqID][ct_all]=ch+str(ct_full)
	return(pos_ct,res)

def parse_dssp(dssp_file):
	with open(dssp_file, 'r') as infile:
		for line in infile.readlines():


def main(args):
	info=parse_pdbDetails(args.listfile)
	mapped_pos,all_pos=map_aligned_pos(args.cma,info)
	with open(args.inlist, 'r') as inlist:
		for line in inlist.readlines():
			if line.startswith("#"):
				continue
			i+=1
			gtfam,pdb,chain=line.strip().split('\t')
			ds_file=args.dsspdir+"/"+pdb+"_"+chain+".dssp"
			parse_dssp(ds_file)

			start,end=info[pdb]['ends'].split('-')


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Generate pml scripts as required based on input.",
           epilog="Contact Rahil for help.")
    parser.add_argument('-c', '--cma', help='Input cma files with aligned pdbs', required=False)
    parser.add_argument('-l', '--listfile', help='Input file with pdbID,domain_rangeChain,mapped_patterns', required=True)
    parser.add_argument('-i', '--inlist', help='Input list of GTfamily,pdb_fileprefix,chain', required=True)
    parser.add_argument('-d', '--dsspdir', help='Path to folder with the dssp of listed pdbs(pdbID_<chain>.dssp)', required=True)
    parser.add_argument('-o', '--output', help='Output file to store the rms score.', required=False)

    args = parser.parse_args()
    main(args)