#!/bin/bash

# USAGE: ./commands <input.cma>
# INPUT FILE MUST BE Aligned CMA

INPUT=$1
PDB=$2
CHAIN=$3

#run_gaps profile/TK-Group_01_25_2017 $INPUT
#   creates: ${INPUT}_aln.cma
#   creates: ${INPUT}_aln.seq
cma2aln ${INPUT} $INPUT -ccm
mv ${INPUT}.in ${INPUT}.aln
#   creates: ${INPUT}.aln
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
