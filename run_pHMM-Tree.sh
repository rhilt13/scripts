#! /bin/bash

#Input:
# $1 : Absolute path to Location of cma file
# $2 : Folder for all the output
# $3 : whether cma from omcBPPS or not

#Output:
# Folders cma, fasta and prc_* inside $2

#Run:
#

cd $2
mkdir cma
mkdir fasta
if [ -e $1 ]; then
	file=$(echo $1|rev|cut -f1 -d'/'|rev|sed 's/.cma//')
    cp $1 cma
    cd cma
    tweakcma $file -write
    rm ${file}.cma
else
    cp $1/*cma cma
    cd cma
fi

if [[ $3 =~ ^omcBPPS$ ]]; then
	## If cma file comes from omcBPPS;
	sed -i 's/;BPPS=.*:$/:/' *cma
	for i in `ls *cma`; do j=$(echo $i|sed 's/.cma//');cma2fa $j > $j.fasta; done
	for i in `ls *fasta`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|sed 's/.fasta//');k=$(echo $i|sed 's/.fasta//');cat $i|sed "s|consensus seq|$j|" >${k}_1.fasta ; done
	mv *_1.fasta ../fasta
	rm *fasta
else
	## Else if cma file already has consensus sequence then run this
	for i in `ls *cma`; do j=$(echo $i|sed 's/.cma//');cma2fa $j|sed '1,3d' > ${j}_1.fasta; done
	mv *_1.fasta ../fasta/
fi

cd ../
pHMM-Tree -prc -als fasta/
cd prc_als_mode_fasta/tree_files
ls *tree > tree_list
cmp_trees.py -l tree_list -o tree_dist.txt
