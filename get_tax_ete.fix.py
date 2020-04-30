#! /usr/bin/env python

import sys
from ete3 import NCBITaxa
ncbi = NCBITaxa()

# get_tax_ete.py -i ID_list
# Check for lines with ERROR.

# Local version of NCBI taxonomy db in following folder:
# ~/.etetoolkit/taxa.sqlite

# If wish to update taxonomy database
# ncbi.update_taxonomy_database()

# Available methods:
#ncbi.get_rank()
#ncbi.get_lineage()				# Get all lineage from taxIDs
#ncbi.get_taxid_translator()	# from taxIDs to names
#ncbi.get_name_translator()		# From species/other names to taxIDs
#ncbi.translate_to_names()

def main(args):
	sp_list=list()
	sp_map={}
	sp_ct=0
	trigger=0
#	## Read in the tsv file and store id and species names and map
	with open(args.ID_file, 'r') as infile:
		for line in infile.readlines():
			acc,sci=line.strip().split('\t')
			gen=sci.split(' ')
			sp=gen[0]
			sp.strip()
			# print sci,"--",sp
			if sp not in sp_list:
				sp_list.append(sp)
				sp_ct+=1
			sp_map[acc]=sp

#	## Get taxIDs for all unique species
	name2tax=ncbi.get_name_translator(sp_list)
	# print(name2tax)
	sp_tax_info={}
#	## Get lineages for each taxID
	for sp_name in name2tax:
		# print sp_name,name2tax[sp_name]
		lineage=ncbi.get_lineage(name2tax[sp_name][0])
		names = ncbi.get_taxid_translator(lineage)
		# print [names[taxid] for taxid in lineage][2]
		## Select what information from lineage to keep for output
		taxHier=[names[taxid] for taxid in lineage]
		if taxHier[2] == "Eukaryota":
			try:
				sp_tax_info[sp_name]=taxHier[4]
			except IndexError:
				sp_tax_info[sp_name]=taxHier.pop()
		else:
			sp_tax_info[sp_name]=taxHier[2]
	# print sp_tax_info

#	## Map Lineages back to accession IDs and print
	for ids in sp_map:
		if sp_map[ids] in sp_tax_info:
			print(ids,"\t",sp_map[ids],"\t",sp_tax_info[sp_map[ids]])
		else:
			trigger=1
			print("ERROR: Tax info for ",ids,sp_map[ids]," not found")

	if trigger == 1:
		sys.exit("##### ERRORS. Some species not found !!$$!!")		

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Parse local Taxonomy database using tsv with ID names and species",
           epilog="Contact Rahil for help.")
    parser.add_argument('-i', '--ID_file', help='Input tsv file with accession no. and species name; Species name is required', required=True)

    args = parser.parse_args()
    main(args)


##### Examples #####

# taxid2name = ncbi.get_taxid_translator([9606, 9443])
# print taxid2name
# # {9443: u'Primates', 9606: u'Homo sapiens'}
# name2taxid = ncbi.get_name_translator(['Homo sapiens', 'primates'])
# print name2taxid
# # {'Homo sapiens': [9606], 'primates': [9443]}
# lineage = ncbi.get_lineage(9606)
# print lineage
# # [1, 131567, 2759, 33154, 33208, 6072, 33213, 33511, 7711, 89593, 7742,7776, 117570, 117571, 
# # 8287, 1338369, 32523, 32524, 40674, 32525, 9347, 1437010, 314146, 9443, 376913, 314293, 9526, 
# # 314295, 9604, 207598, 9605, 9606]
# names = ncbi.get_taxid_translator(lineage)
# print [names[taxid] for taxid in lineage]
# # [u'root', u'cellular organisms', u'Eukaryota', u'Opisthokonta', u'Metazoa', u'Eumetazoa', u'Bilateria', u'Deuterostomia', u'Chordata', u'Craniata', u'Vertebrata', u'Gnathostomata', 
# # u'Teleostomi', u'Euteleostomi', u'Sarcopterygii', u'Dipnotetrapodomorpha', u'Tetrapoda', u'Amniota', u'Mammalia', u'Theria', u'Eutheria', u'Boreoeutheria', u'Euarchontoglires',
# # u'Primates', u'Haplorrhini', u'Simiiformes', u'Catarrhini', u'Hominoidea', u'Hominidae', u'Homininae', u'Homo', u'Homo sapiens']

#######################
