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

for i in `ls *cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'); echo $j $k |sed 's/>/\n\t/g'; done|sed 's/ \+$//g' >list_hits.txt

cat map_fam_info |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s//g;print "$_\t$hash{$_}\n";}}' > list_hits.txt.details


### To get counts of GT families instead of list of IDs: 
for i in `ls *.cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');k=$(cat $i|grep '^>'|cut -f1 -d'|'|sort|uniq -c); echo $j $k |sed 's/ >/\t/g;s/ /\n\t/g'; done > list_hits.txt.count

cat map_fam_info |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt.count");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s*//g;print "$_\t$hash{$_}\n";}}' > list_hits.txt.count.details

less list_hits.txt.details|perl -lne 'last if ($_=~/^aln/);next if ($_=~/^$/);if ($_=~/^[0-9]/){@a=split(/\t/,$_);$fam=$a[1];}elsif ($_!~/consensus/){$_=~s/^\s+//;($pdb)=($_=~/(.*?)$|\s/);print "$fam\t$pdb";}' > list_hits.txt.details.map
for i in `ls *[0-9].cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');export j;cat $i|perl -e 'while(<>){if ($_=~/^\[/){($set)=($_=~/=(Set[0-9]+)\(/);}elsif ($_=~/^\$/){($len)=($_=~/=([0-9]+)\(/);}elsif ($_=~/^>/){$_=~s/^>//;print "$ENV{j}\t$set\t$len\t$_";}}'; done |sed 's/ /\t/' > list_hits.txt.details.map.seqlen

less list_hits.txt.details.map.seqlen|cut -f1,2,4|sed 's/\t/|/g'|grep -v consensus|cut -f1,2,4 -d'|'|sort|uniq -c|sed 's/^ \+//g;s/ /|/g'|perl -e 'while(<>){chomp;@a=split(/\|/,$_);$h2{$a[2]}=$a[1];$hash{$a[2]}{$a[3]}=$a[0];}for $k1(sort keys %hash){print "$h2{$k1}\t$k1\t";for $k2(sort keys %{$hash{$k1}}){print"$k2($hash{$k1}{$k2}),";}print "\n";}'|sed 's/,$//' > list_hits.txt.details.map.seqlen.famDist

mkdir rungaps_out
mv *cma rungaps_out
mv *seq rungaps_out