#! /bin/bash

# $1 - cma file with all the sequences with path
# $2 - pattern to replace in the cma file name (name in the first line of the $1 cma file [0...=**name**()...)

# Removed option
# $3 - total no. of levels in tree (check the highest num in _lnum.selID files inside the sub_cma folder)

# Things to look out for
# allcons
# *_l${j}.selID
# $1 - ../hum_gta.e1.cma
# $2 - sel3
# 

### First steps
# get-cma-seq.pl tree1.e2.txt.collapse_list.details tree1.e2.txt.nodes tree1.e2.txt.col.nodes
# cd sub_cma

for i in `ls *_tip.selID`; do 
	k=$(echo $i|sed 's/\_tip.selID//');
	parse_cma.pl $1 sel $i > $k.cma;
	tweakcma $k -csq > temp1;
	cat temp1 $k.cma > temp2.cma
	tweakcma temp2 -m
	mv temp2.merged.cma $k.cons.cma
	cat $k.cons.cma|sed "s/$2/$k/" > $k.cons.edit.cma; 
	cat $k.cons.edit.cma|head -6|tail -3 >>allcons
done

cat $1|head -2 > head
cat $1|tail -2 > tail

cat head allcons tail > allcons.cma

for i in `ls *_int.selID`; do 
	k=$(echo $i|sed 's/\_int.selID//');
	m=$(($j-1));
	parse_cma.pl allcons.cma sel $i > $k.cma;
	tweakcma $k -csq > temp1;
	cat temp1 $k.cma > temp2.cma
	tweakcma temp2 -m
	mv temp2.merged.cma $k.cons.cma
	cat $k.cons.cma|sed "s/$2/$k/" > $k.cons.edit.cma; 
	cat $k.cons.edit.cma|head -6|tail -3 >>allcons;
done
cat head allcons tail > allcons.cma
rm temp1 temp2.cma