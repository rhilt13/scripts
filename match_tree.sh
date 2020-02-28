#! /bin/bash

#$1 - file with list of fasta sequences
#$2 - location of ID mapping file to species name
#$3 - species tree

for i in `cat $1`; do
	file=$(echo $i|rev|cut -f1 -d'/'|rev);
	cat $i|perl -lne 'if($_=~/^>/){($id)=($_=~/\:(.*?).kin_dom/);print ">$id";}else{print $_;}' > temp_1
	edit_fasta_ID.pl $2 temp_1 > temp_2
	mafft --auto temp_2 > $file.msa;
	iqtree -s $file.msa -st AA -m MFP+MERGE -bb 1000 -wbt -nm 1000
done
