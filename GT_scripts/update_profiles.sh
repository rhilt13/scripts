#! /bin/bash

## To change the consensus sequence id to file id 
# for i in `ls`; do j=$(echo $i|cut -f1 -d'.');sed -i "s/lcl/GT-A|$j/" $i; done

## To get consensus sequences to get .cons file:
# for i in `cat ../order`; do head -2 $i.FASTA.press; done|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > ../GT-A.cons

# Generate a multiple seq alignment of the consensus seq
# Edit the consensus seq as required
# Make sure the edited file has full seq IDs with consensus at the end

# After editing with MEGA, run:
# remove_newline_fasta.pl gt_test4.fas |perl -lne 'if ($_=~/^>/){print $_;}else{$_=uc($_);print $_;}' > gt_test4.fas.fa
############################################
## 4 input files:
## 1- edited alignment of consensus sequences
## 2- folder with FASTA alignment of each family with name <name>.FASTA.press
## 3- An order file with the order of families ( Use only family names like GT27, cd00218,...)
## 4- Output profile prefix
#############################################

## Does not work for sub-sub families
## Edited alignments must be same order as order file
## First sequence in edited alignment must be consensus sequence of all consensus sequences

#############################################

### Run bash ~/rhil_project/GT/scripts/update_profiles.sh <edited_alignment_file_name> <folder_with_family_alignments> <order_file> <output_prefix>

## bash ~/rhil_project/GT/scripts/update_profiles.sh a new_sub order test_out1

##############################################

fa2cma $1 |sed "s/fa2cma/GT-A/"> $1.cma
cp $1.cma $4.tpl

cat $1 |perl -lne 'if($_=~/^>/){print $_;}else{$_=~s/-//g;$_=uc($_);print $_;}' >$1.nogaps

edit_all_alignments_nosub.pl $2 $1.nogaps

cd $2
for i in `ls *.FASTA.press.edit`; do k=$(ls $i|cut -f1 -d'.');g="GT-A|${k}"; fa2cma $i |sed "s/fa2cma/$g/;s/\[0_/[1_/;s/_0\]/_1]/" > $k.cma; done

rm ../$4.cma; for i in `less ../$3`; do cat $i.cma >> ../$4.cma; done
cd ..

run_map $4
chmod 755 $4.*

### Error checking
rm $4.error
cat $4.tpl|grep -v '^>'|grep '\-[[:lower:]]' >>$4.error
cat $4.tpl|grep -v '^>'|grep '[[:lower:]]\-' >>$4.error
cat $4.tpl|grep -v '^>'|grep ')-' >>$4.error
cat $4.tpl|grep -v '^>'|grep '-(' >>$4.error
##################################
## Check length of consensus match between cma and tpl files
## Check and fix following regular expressions in the tpl file using Sublime:
## -[a-z]
## [a-z]-
## \)-
## -\(

## for i in `ls sel_sub_test7/*cma`;do cat $i|head -5|tail -2;done|less
##################################