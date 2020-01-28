#! /bin/bash

# $1 = Path to the cma files along with the prefix for the expanded sets generated from himsa 
#		run bpps 2 on the bpps 1 output
#		tweakcma -write to separate expanded sets into different cma files
# $2 = file prefix for the set cma files (nrrev13_sel1_himsa)
# $3 = Set number to run the analysis on. (Set24)
# 

cp ${1}/${2}_${3}.cma ${2}_${3}.mma
bpps 1 ${2}_${3} -maxcol=50 -maxdepth=5 -minnats=5