#! /bin/bash

# Run inside the run_gaps results folder

## Input: 
#  1 - .hits file from rungaps
# bash ~/rhil_project/GT/scripts/parse_rungapsOut.sh pdb_seqres.faa.hits

## First run rungaps as follows 
#run_gaps ~/rhil_project/GT/gta_muscle_long/gta_mus_longer pdb_seqres.faa -O &>>pdb_seqres.faa.hits

if [[ $1 =~ hits$ ]]; then
	less $1|grep '^=='|cut -f3,4 -d' '|sed 's/: /\t/g' > map_fam_info
else
	cp $1 map_fam_info
fi 

for i in `ls *cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'); echo $j $k |sed 's/>/\n\t/g'; done >list_hits.txt

cat map_fam_info |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s//g;print "$_\t$hash{$_}\n";}}' > list_hits.txt.details


### To get counts of GT families instead of list of IDs: 
for i in `ls *.cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'|cut -f1 -d'|'|sort|uniq -c); echo $j $k |sed 's/ >/\t/g;s/ /\n\t/g'; done > list_hits.txt.count

cat map_fam_info |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt.count");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s*//g;print "$_\t$hash{$_}\n";}}' > list_hits.txt.count.details

less list_hits.txt.details|perl -lne 'last if ($_=~/^aln/);next if ($_=~/^$/);if ($_=~/^[0-9]/){@a=split(/\t/,$_);$fam=$a[1];}elsif ($_!~/consensus/){$_=~s/^\s+//;($pdb)=($_=~/(.*?) /);print "$fam\t$pdb";}' > list_hits.txt.details.map
