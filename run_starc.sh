#!/bin/bash

# USAGE: ./commands <input.cma>
# INPUT FILE MUST BE Aligned CMA

# run_starc.sh nrrev9_sel1_new_GT6.cma 1lzj.pdb A

# Needs the libgomp.so.1 library which is present in ~/bin
export LD_LIBRARY_PATH=~/bin/:${LD_LIBRARY_PATH}

INPUT=$1
PDB=$2
CHAIN=$3
START=$4 # Residue 1 in alignment is residue START in pdb file

#################################################
## Comment out based on what type of input file you start with ##
# # If FASTA, start here:
# run_gaps profile/TK-Group_01_25_2017 $INPUT
# #   creates: ${INPUT}_aln.cma
# #   creates: ${INPUT}_aln.seq
# # If cma file, start here:
cma2aln ${INPUT} $INPUT -ccm
less ${INPUT}.in|sed '1d'|sed '1 s/-/X/g' > ${INPUT}.aln
#   creates: ${INPUT}.aln
##################################################
#### Edit the aln file so that the pdb sequence is at the top 
#### and the - are replaced with X for this first sequence
#### to get the right template_seq
##### less $INPUT.aln |head -1 > template_seq
# If aln aligned file, start here:
ccm $INPUT.aln $INPUT.dca
#   creates: ${INPUT}.dca
cp ${INPUT}.aln temp.aln
cp ${INPUT}.dca temp.dca
# REQUIRES ${INPUT}.dca & ${INPUT}.aln
# use the renamed versions because it does not allow periods
starc ${PDB} ${CHAIN} temp
mv temp ${INPUT}.starc
#    creates: ${INPUT}.starc

# cleanup
rm {temp.aln,temp.dca}
#rm {${INPUT}.dca,${INPUT}.aln,${INPUT}_aln.cma,${INPUT}_aln.seq}

cat ${INPUT}|grep -A1 '^>'|head -2|tail -1|sed 's/[(){}*]//g' > template_seq
less ${INPUT}.starc|sort -t, -k3,3nr |perl -e '$adj='$START'-1;
	open(IN,"template_seq");
	while (<IN>){chomp;@a=split(//,$_);$i=0;$add=0;$subs=0;$gaps=0;$ct{$i}=0;
		foreach $res(@a){if ($res=~/^[a-z]$/){$subs=0;$add++;}
			elsif($res=~/^[A-Z-]$/){$i++;$subs=$i;if ($res=~/^-$/){$gaps++;}}
		$ct{$subs}=$add;$ct_gaps{$subs}=$gaps;}}
	while(<>){chomp;@a=split(/,/,$_);
	print "$_\t",$a[0]+$ct{$a[0]}+$adj-$ct_gaps{$a[0]},"\t",$a[1]+$ct{$a[1]}+$adj-$ct_gaps{$a[1]},"\n";}' > ${INPUT}.posmap

