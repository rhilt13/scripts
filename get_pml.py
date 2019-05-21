#!/usr/bin/env python
import __main__
import pymol
from os import path, environ
import re

# Input:
# -i => pdb_collect - GTfam | pdbID (list of pdb filenames to analyze and add)
# -l => pdb_list.mapped.details - pdbID | GTDomainBounds,Chain | Patterns
# -n => pdb_inserts.txt - pdbID_Chain | GTDomainStartNum | Insertbounds CommaSeparated (obtain using get_inserts.pl script)
# -p => ~/GT/pdb/str_GT/PDB/orig (path to folder with pdb structures)
# -c => sel_pdb.cma ( cma file with all pdbs, Strips chain IDs when reading seq name)
# -d => pdb_domains.txt (Domain boundaries based on cma aligned position: Domain name, start, end, PdbID or -)

# pdb_inserts.txt - Use get_inserts.pl to get this
# get-inserts.pl sel_pdb.cma 4 ../pdb_map/pdb_list.mapped.details  > pdb_inserts.txt

# pdb_domains.txt - Type in the domains you want based on the cma aligned positions

#Map variable regions (Get positions from alignment)
# Map alignment positions to sequence position

# Functions:
# parse_pdbDetails
# get_domain
# map_positions
# align

# Command line to run:
# python get_pml.py \
#   -i pdb_collect \
#   -l ~/GT/gta_revise9/mcBPPS/allgta_tree/try5/pdb_map/pdb_list.mapped.details \
#   -p ~/GT/pdb/str_GT/PDB/orig/ \
#   -n pdb_inserts.txt \
#   -c sel_pdb.cma \
#   -d pdb_domains.txt \
#   -o out1.pml

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

def parse_insertfile(filename):
	pos_list={}
	with open(filename, 'r') as listfile:
		for line in listfile.readlines():
			pdb,pos,inserts=line.strip().split('\t')
			pos_list[pdb]=inserts
	return pos_list

def map_patterns(pdb_name,pattern_list):
	# print pattern_list
	i=3
	outstr=''
	for key, value in pattern_list.items():
		# print pdb_name,key,"==",value
		if (key == 'Class_M'):
			level=1
		elif (key =='Class_R'):
			level=2
		elif (key =='Class_O'):
			level=3
		else:
			i+=1
			level=i
		outstr+="cmd.select(\""+pdb_name+"Lev"+str(level)+"\",\""+pdb_name+" and resi "
		for num in value:
			# print type(num)
			# print type(outstr)
			# print num
			outstr+=num+","
		outstr+="\")\n"
	return(outstr)

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
				ct_aln=0
				ct_gapped=0
				ct_full=int(start_dict[seqID]['ends'].split("-")[0])-1
				line=re.sub(r'[\{\}\(\)\*]', '',line)
				for ch in list(line):
					if ch.islower():
						ct_full+=1
						pos_ct[seqID][ct_gapped]=ct_full
					elif ch.isupper():
						ct_full+=1
						ct_aln+=1
						ct_gapped+=1
						pos_ct[seqID][ct_gapped]=ct_full
					else:
						ct_gapped+=1
						pos_ct[seqID][ct_gapped]=ct_full
	# print pos_ct
	return(pos_ct)

def map_res(pdb,line,pos_map):
	outstring=''
	pos_all=line.strip().split(',')
	for p in pos_all:
		outstring+=str(pos_map[pdb][int(p)])+","
	return(outstring)

def map_domains(domain_info, pos_map):
	dom_map={}
	with open(domain_info, 'r') as inlist:
		for line in inlist.readlines():
			if line.startswith("#"):
				continue
			elif line.startswith("!"):
				# print line
				dom_name,reslist,spec=line.strip().split('\t')
				dom_name=dom_name[1:]
				dom_map[dom_name]={}
				if (spec != '-'):
					dom_map[dom_name][spec]=map_res(spec,reslist,pos_map)
				else:
					for key in pos_map:
						dom_map[dom_name][key]=map_res(key,reslist,pos_map)
			else:
				# print line
				dom_name,start,end,spec=line.strip().split('\t')
				dom_map[dom_name]={}
				if (spec != '-'):
					# dom_map[dom_name][spec]={}
					# dom_map[dom_name][spec][spec]={}
					# pass
				# 	print pos_map
				# 	print pos_map[spec]
					dom_map[dom_name][spec]=str(pos_map[spec][int(start)])+"-"+str(pos_map[spec][int(end)])
					# dom_map[dom_name][spec][1]=pos_map[spec][int(end)]
				else:
					for key in pos_map:
						# dom_map[dom_name][key]={}
						dom_map[dom_name][key]=str(pos_map[key][int(start)])+"-"+str(pos_map[key][int(end)])
						# dom_map[dom_name][key][1]=pos_map[key][int(end)]
	return(dom_map)

def set_default():
	outdefault="set seq_view, 0\n"
	outdefault+="hide lines\n"
	# outdefault+="show cartoon\n"
	return(outdefault)

def main(args):

	# print store
	info=parse_pdbDetails(args.listfile)
	i=0
	out=''
	if args.insertlist is not None:
		ins=parse_insertfile(args.insertlist)
	if args.cma is not None:
		mapped_pos=map_aligned_pos(args.cma,info)
	if args.domains is not None:
		mapped_dom=map_domains(args.domains,mapped_pos)
	with open(args.inlist, 'r') as inlist:
		for line in inlist.readlines():
			if line.startswith("#"):
				continue
			i+=1
			gtfam,pdb=line.strip().split('\t')
			path=args.pathtostr.rstrip('\/')
			pdb_new=gtfam+"_"+pdb+"full"
			gtpdb=gtfam+"_"+pdb
			gtpdbss=gtpdb+"_ss"
			# print info[pdb]['ends']
			start,end=info[pdb]['ends'].split('-')
			start=str(int(start)-1)
			end=str(int(end)+1)

			# Load structure
			out+="cmd.load(\""+path+"/"+pdb+".pdb\")\n"
			out+="cmd.color(\"gray9\",\""+pdb+" and (resi 1-"+start+" or resi "+end+"-10000)\")\n"
			# Select GT domain
			out+="cmd.select(\""+gtpdb+"\",\"resi "+info[pdb]['ends']+" and "+pdb+" and chain "+info[pdb]['chain']+"\")\n"
			# Select sec. str. of GT domain
			out+="cmd.select(\""+gtpdbss+"\",\"(ss h+s) and "+gtpdb+"\")\n"
			out+="hide everything,"+pdb+"\n"
			out+="show cartoon, "+gtpdb+"\n"

			# Align to the first structure
			if (i==1):
				template=gtpdbss
			else:
				out+="cmd.cealign(\""+template+"\",\""+gtpdbss+"\")\n"
				# print "AA"

			# Map omcBPPS/mcBPPS patterns
			# print info[pdb]
			# print gtpdb
			# print info[pdb]['patterns']
			out+=map_patterns(gtpdb,info[pdb]['patterns'])

			# Map inserts
			pdb_ch=pdb+"_"+info[pdb]['chain']
			if pdb_ch in ins and ins[pdb_ch] != 'None':
				out+="cmd.select(\""+gtpdb+"Ins\",\""+gtpdb+" and resi "+ins[pdb_ch]+"\")\n"
				out+="cmd.color(\"gray3\",\""+gtpdb+"Ins\")\n"

			# Map domains
			for d in mapped_dom:
				if pdb in mapped_dom[d]:
					out+="cmd.select(\""+gtpdb+"_"+d+"\",\""+gtpdb+" and resi "+mapped_dom[d][pdb]+"\")\n"
					# print d,pdb

			# Change name to order everything
			out+="cmd.set_name(\""+pdb+"\",\""+pdb_new+"\")\n"

	#
	# print "OUTFILE------------",out
	# Map alignment positions
	# First, get alignment start position in pdb
	out+=set_default()
	if args.output is not None:
		with open(args.output, 'w') as pmlfile:
			pmlfile.write(out)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Generate pml scripts as required based on input.",
           epilog="Contact Rahil for help.")
    parser.add_argument('-c', '--cma', help='Input cma files with aligned pdbs', required=False)
    parser.add_argument('-d', '--domains', help='Domain boundaries based on cma aligned position: Domain name, start, end, PdbID (optional) or -', required=False)
    parser.add_argument('-n', '--insertlist', help='Input list of inserts (obtain using get_inserts.pl script): pdb_chain start_pos insert_pos', required=False)
    parser.add_argument('-i', '--inlist', help='Input list of GTfamily,pdb_fileprefix', required=True)
    parser.add_argument('-l', '--listfile', help='Input file with pdbID,domain_rangeChain,mapped_patterns', required=True)
    parser.add_argument('-p', '--pathtostr', help='Path to folder with the structures of listed pdbs', required=True)
    parser.add_argument('-o', '--output', help='Output file to store the rms score.', required=False)

    args = parser.parse_args()
    main(args)

# Table
# gt family, pdb id(filename), gt domain start-end, class residues,...

# cmd.load("./2ffu_H.pdb")
# cmd.select("gt13_2am5","resi 110-374 and 2am5")
# cmd.select("gt13_2am5_ss","(ss h+s) and gt13_2am5")

# cmd.select("ligand","hetatm and not hydro and not solvent")
# cmd.show("sticks","ligand and not hydro")
# cmd.color("deepteal","ligand")

# super gt27_2ffu_ss, gt13_2am5_ss