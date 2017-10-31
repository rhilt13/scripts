#! /bin/bash

## Remove redundant sequences from CAZy_allGT_genbank.faa.IDedit

# Generate a CAZy_GT-A.id_map file using parse_cazy.pl script
# for i in `ls`; do parse_cazy.pl $i map >> CAZY_GT-A.id_map; done

#make a list of all ids (for which you want to remove redundant) - organism specific, taxa specific
#cat CAZy_allGT_genbank.faa.IDedit_aln.cma|grep '^>'|grep sapiens|cut -f2 -d'|' > sel_hum.ids

# Input:
# $1 - list of IDs from which to remove redundant
#		Only genbank IDs with or without the .1 or .2 or ... at the end - Make appropriate changes to match.fix.pl  $str=~s/\.[0-9]+$|//g;
# $2 - id mapping file
#		~/rhil_project/GT/CAZy_families/CAZy_allGT.id_map.all
#		~/rhil_project/GT/CAZy_families/CAZy_allGT.id_map
#		~/rhil_project/GT/CAZy_families/CAZy_GT-A.id_map
#		~/rhil_project/GT/CAZy_families/CAZy_GT-B.id_map
#		~/rhil_project/GT/CAZy_families/CAZy_GT-C.id_map
#		~/rhil_project/GT/CAZy_families/CAZy_GT-u.id_map
# $3 - file from which to get the sequences
# $4 - 'cma' or 'fasta'


# use match.pl to select only single matched id from id_map 
match.fix.pl $1 $2 |sort -u > $1.uniq

if [ $4 == 'cma' ]; then 
	# get cma sequences
	parse_cma.pl $3 sel $1.uniq > $1.uniq.cma
elif [ $4 == 'fasta' ]; then 
	# get FASTA sequences
	get-seq-bioperl_nochange1.pl $1.uniq $3 >$1.uniq.fa
fi