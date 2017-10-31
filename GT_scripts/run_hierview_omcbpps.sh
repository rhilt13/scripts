#! /bin/bash

## Get map_id for the serial number of sets from .hpt file
# cat c_nongt_himsa.hpt|grep '^+'|cut -f2 -d' '|perl -lne '@a=split(/\./,$_);chop $a[1];print "$a[0]\t$a[1]";'|head -40 > map_id

## Run hierview to generate pymol files for a list of pdb sequences
## If for single pdb, follow directions here and run hierview separately (easier)

## First make sure all the pdb sequences are present in the *_himsa.cma file in hier folder
## 		If not, copy *_himsa.cma to a new *.cma file and add required pdb sequences manually.
##			Align the pdb sequences to the *_himsa profiles using rungaps
##			Copy paste the aligned pdb sequences into their respective sets
## 			Record the serial number of the set from *.hpt file not the set number
##  	Also copy *_himsa.tpl file to the same prefix *.tpl file
##		Copy *_himsa.hpt to same prefix .hpt
## 		Copy *_himsa.sets to same prefix .sets

## Input:
## $1 - common file_prefix for cma, tpl, sets and hpt files
## $2 - list of pdb files with full path to location of the pdb file

## map_id - file in the same folder with map fo serial number to set number
## pdb_list - file with list of pdb files with full path in the same folder

## Ouput:
## pdb_details = map of serial number of edited pdb
## hierview outputs:
##		.pml files = pymol files

## Example run
## Run in /home/rtaujale/rhil_project/GT/GT-A/omcbpps_revise3/non-gt2/hier
## bash ~/rhil_project/GT/scripts/run_hierview_omcbpps.sh c_nongt_himsa

## Edit the pdb files and save as *_edit.pdb

for i in `cat pdb_list`; do j=$(echo $i|sed 's/.pdb$/_edit.pdb/'); cat $i |grep '^ATOM\|^TER\|^END' > $j; done

less $1.cma|grep '^>Set\|>...._'|perl -e 'open(IN,"map_id");while(<IN>){chomp;@z=split(/\t/,$_);$hash{$z[1]}=$z[0];}while(<>){if ($_=~/^>Set/){($a)=($_=~/(Set.*?) /);}else{($b)=($_=~/^>(....)_/);if ($a!~/^Set1$/){$hash2{$b}=$hash{$a};}}}open(IN2,"pdb_list");while(<IN2>){chomp;@p=split(/\//,$_);$p[-1]=~s/.pdb//;$_=~s/.pdb/_edit.pdb/;print "$_","\t$hash2{$p[-1]}\n";}' >pdb_details
rm *.path

less pdb_details|perl -lne '@a=split(/\t/,$_); open(OUT,">>$a[1].path");print OUT "$a[0]";if (!exists $hash{$a[1]}){print $a[1];$hash{$a[1]}=1;}' > pdb_groups

for i in `cat pdb_groups`; do 
	path=$(echo $i|cut -f1 -d',')
	num=$(echo $i|cut -f2 -d',')
	hierview $1 $i -pdb_paths=$i.path
done

mkdir pymol
mv *.pml pymol

rm pdb_groups
rm *.path