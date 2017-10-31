#! /bin/bash

# Run inside the run_gaps results folder
## Change the first cut column expressions in line 14 and 20 as required
## to capture the file number
## pdb_seqres.taa_31.cma -- grab 31

## Input: 
#  1 - .hits file from rungaps output as .o file in qsub folder
# bash ~/rhil_project/GT/scripts/parse_rungapsNr.sh pdb_seqres.faa.hits

## First run rungaps as follows in zcluster /home/nknlab/rt33095/db/rt33095_Mar_23 folder
# for i in `ls nr.part-*`; do run_gaps ~/GT/rt33095_Mar_18/gt_rev2 $i -O; done
#run_gaps ~/rhil_project/GT/gta_muscle_long/gta_mus_longer pdb_seqres.faa -O &>>pdb_seqres.faa.hits

less $1|grep '^=='|cut -f3,4 -d' '|sed 's/: /\t/g' > fam_num_list

for i in `ls *cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'); echo $j $k |sed 's/>/\n\t/g'; done >list_hits.txt

cat fam_num_list |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s//g;print "$hash{$_}\n";}}' > list_hits.txt.details


### To get counts of GT families instead of list of IDs: 
for i in `ls *.cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'|cut -f1 -d'|'|sort|uniq -c); echo $j $k |sed 's/ >/\t/g;s/ /\n\t/g'; done > list_hits.txt.count

cat fam_num_list |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt.count");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s*//g;print "$_\t$hash{$_}\n";}}' > list_hits.txt.count.details
