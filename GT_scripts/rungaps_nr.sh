#! /bin/bash

# Input:
# $1 - absolute path to nrtx partition folder (/auto/share/db/nr_partition)
# $2 - absolute path to rungpas profile (~/GT/gta_revise9/profile/gt_rev9)
# $3 - absolute path to output folder (~/GT/gta_revise9/rungaps/)
# $4 - prefix for sets file in output ( nr_gtrev9)

## Points to check:
# 1) Make sure nr partitions are named nrtx.part-*
# 2) Output folder specified in $3 should not have a folder named nr

if [ -d $3/nr ]; then
	echo "Folder $3 exists!! Use different folder or remove current one and run again!"
	exit
fi
## Run rungaps on all nrtx partitions
cd $1;
for i in `ls nrtx.part-*`; do run_gaps $2 $i -O &>>$i.hits; done

## Move output files to designated folder
mkdir $3/nr/;
mkdir $3/nr/part;
mkdir $3/nr/sets;
mv *.cma $3/nr/part/;
mv *.seq $3/nr/part/;
cd $3/nr/;

## Get head and tail for cma files
head -2 part/nrtx.part-01_aln.cma|sed 's/[(][0-9]*[)][{]/(numnumseq){/g' > head
tail -1 part/nrtx.part-01_aln.cma > tail

## Create a number to family mapping file
less part/nr.part-01.hits|grep '^=='|cut -f3,4 -d' '|sed 's/: /\t/g' > map_fam_info

## Concatenate all hits from all parts into a single file
for i in `ls part/nrtx.part*aln.cma`; do cat $i|sed '1,2d'|head -n -2 >> $4; done
## Adding head and tail to make a complete cma file
for i in `ls $4`; do j=$(cnt $i|sed 's/^\s\+//g'|cut -f1 -d' ');cat ../head $i ../tail|sed "s|numnumseq|$j|" >$i.cma ; done

## Separate out sets of hits
for i in `ls part/nrtx.part-*[0-9].cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');cat $i|sed '1,6d'|head -n -2 >> sets/${4}_$j; done
cd sets;
for i in `ls *`; do j=$(cnt $i|sed 's/^\s\+//g'|cut -f1 -d' ');cat ../head $i ../tail|sed "s|numnumseq|$j|" >$i.cma ; done
