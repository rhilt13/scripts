#! /bin/bash

# Description:
# Maps omcBPPS identified pattern residues into pdb files.

# uses structures from ~/rhil_project/GT/pdb/str_H_nosplit_lab/ folder
# 	H added, chains not split

# Input:
# Required: Prefix for omcBPPS output Eg: cazy_set2.mma without the .mma
# Uses pdb list from rev6 pdb rungaps. If need to change, refer to line with cp ....../pdb_list

# Output:
# Creates a pdb_map file containing .pml files for all mapped pdb structures.


# To run:
# map_pdb_afteromcBPPS.sh <file prefilx>			
# <FILE PREFILX> = cazy_set2_new.mma without the _new.mma

echo "==> Running map_pdb_afteromcBPPS";

if [ -d "pdb_map" ]; then
  rm -r pdb_map
fi
mkdir pdb_map
cd pdb_map
## This pdb_list true for all GT-A structures
cp ~/GT/pdb/list_gta_pdb_gtrev8_sarp ./pdb_list
for i in `cat pdb_list`; do j=$(echo $i|cut -f2 -d'/');cp ~/GT/pdb/str_H_nosplit_lab/$j .; done
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

less ${1}_pdb.VSI|grep '^File\|Set'|grep -v 'Set1:'|cut -f2 -d'/'|cut -f1 -d'_'|uniq|tr '\n' ' '|tr ':' '\n'|awk -F "#" '{print $2,$1}'|sort -n > ../pdb_map_table

echo "No. of pdbs with pml files generated:";
ls *pml|sed 's/_[A-Z].pml//g'|sort -u|wc