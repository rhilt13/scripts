#! /bin/bash

# Description:
# Maps omcBPPS identified pattern residues into pdb files.

# uses structures from ~/rhil_project/GT/pdb/str_H_nosplit_lab/ folder
# 	H added, chains not split

# Input:
# $1 - Prefix for omcBPPS output Eg: cazy_set2.mma without the .mma
# $2 - absolute path to the folder with the pdb files
# $3 - Full path to rungaps output pdb_seqres.faa_aln.cma file for the pdb database 
#		(../rungaps_*/pdb/pdb_seqres.faa_aln.cma)

# Output:
# Creates a pdb_map file containing .pml files for all mapped pdb structures.

# To run:
# map_pdb_afteromcBPPS.sh <file prefilx>			
# <FILE PREFILX> = cazy_set2_new.mma without the _new.mma

echo "==> Running map_pdb_afteromcBPPS";
if [[ ! -z "$3" ]]; then
	if [ -d "pdb_map" ]; then
	  rm -r pdb_map
	fi
	mkdir pdb_map
	cat $3 |grep '^>'|cut -f1 -d'_'|sort -u|cut -f2 -d'>'|sed 's/^/.\//;s/$/.pdb/' > pdb_map/pdb_list
	cd pdb_map
fi 
## This pdb_list true for all GT-A structures
# cp ~/GT/pdb/list_gta_pdb_gtrev8_sarp ./pdb_list
for i in `cat pdb_list`; do j=$(echo $i|cut -f2 -d'/');cp $2/$j .; done
sarp pdb_list ../$1
mv ../${1}_pdb.VSI .
mv ../${1}_pdb.klst .
mv ../${1}_pdb.eval .
mv ../${1}_pdb.best .
mv ../${1}.interact .
mv ../${1}.grph .
mv ../${1}.key_res .
mv ../${1}.ca_scores .

less ${1}_pdb.VSI|grep '^\~\$\=\|^File'|cut -f2 -d'='|cut -f1 -d' '|cut -f2 -d'/'|sed 's/\.$//g;s/^\s\+//g;s/\s\+$//g;s/:/_/' > pdb_list.mapped
name=$1;
export name;
cat pdb_list.mapped|perl -e 'while(<>){chomp;if ($_=~/^[0-9]+$/){$i=$_;$j=0;}else{$j++;system("chn_vsi $ENV{name}_pdb.VSI $j $i -T -skip=W -d2.5 -v -D -pml > $_.pml");}}'

#less ${1}_pdb.VSI|grep '^File\|Set\|Group'|grep -v 'Set1:'|cut -f2 -d'/'|cut -f1 -d'_'|uniq|tr '\n' ' '|tr ':' '\n'|awk -F "#" '{print $3,$1}'|sort -n > ../map_pdb_table
less $1_pdb.VSI|grep '^File\|Set\|Group'|cut -f2 -d'/'|perl -e '$p=0;$n=0;while(<>){chomp;$_=~s/ //g;$_=~s/#//g;if ($_=~/Set/){if ($n==1){print "\t";$n=0;}$p=1;$_=~s/# //;$_=~s/://;print "$_,";}else{$_=~s/.pdb\:/-/;if ($p==1){print "\n";$p=0;$n=1;print "$_,";}else{print "$_,";$n=1;}}}'|sed 's/,\t/\t/;s/,$//' > ../map_pdb_table


for i in `ls *pml`; do less $i|grep -v '^#'|grep 'load(\|cmd.color("bb_color1"\|create("Class_'|perl -e 'while(<>){chomp;if ($_=~/^cmd.load/){($id)=($_=~/\(\"\.\/([0-9a-zA-Z]+)/);print "\n$id";}elsif ($_=~/^cmd.color/){($num,$chain)=($_=~/resi ([0-9-]+) and chain ([A-Z]) /);print "\t$num,$chain";}elsif ($_=~/^cmd.create/){($cl,$res)=($_=~/\(\"(Class_[A-Z])\",\"(.*)\"\)/);$res=~s/ or / /g;print "\t$cl,$res";}}'; done|sed '1d'|sort -u -k1,1 --merge > pdb_list.mapped.details

echo "No. of pdbs with pml files generated:";
ls *pml|sed 's/_[A-Z].pml//g'|sort -u|wc