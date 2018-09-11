#! /bin/bash

##
# $1 -pattern to replace in the cma file name 
#     from the first line of allcons.cma file
### First steps
# Follow steps listed in get_hierarchy.sh file under mcBPPS workflow Method 2
# cd sub_cma

for i in `ls *_int.selID`; do 
	k=$(echo $i|sed 's/\_int.selID//');
	parse_cma.pl allcons.cma sel $i > $k.cma;
	tweakcma $k -csq > temp1;
	cat temp1 $k.cma > temp2.cma
	tweakcma temp2 -m
	mv temp2.merged.cma $k.cons.cma
	cat $k.cons.cma|sed "s/${1}_/$k /;s/$1/$k/" > $k.cons.edit.cma; 
	cat $k.cons.edit.cma|head -6|tail -3 >>allcons;
done
cat head allcons tail > allcons.cma
rm temp1 temp2.cma