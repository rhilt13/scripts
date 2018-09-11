#! /bin/bash

## To get the tree distribution to select sub-clades
# build_sma.sh nrrev9_sel1.hpt list

## To get the final sma file ( and edit hpt file - to do)
# build_sma.sh tree1.edit2.txt.hpt print hum_gta.cma nrrev9_sel1 sel3 tree_dist_e1

# $1 - hpt file (nrrev9_sel1.hpt)
# $2 - 'print' ; for the final refined round once the hpt files are defined
# $3 - cma file with all sequences
# $4 -output prefix
# $5 - header name in cma file above in $3
# $6 (if $2='print') - edited tree_dist )tree_dist_e1

# Change the way IDs are written to file in the following script.

if [ "$2" == "print" ]; then
	pref=$4;
	rm $pref.sma;
	get-sma-from-hpt.pl $1 print $6 $4.hpt;
	for i in `ls -v *selSeq`; do
		head=$(echo $i|sed 's/^[0-9]\+_//;s/_Hier.\+//');
		parse_cma.pl $3 sel $i |sed "s/)=$5(/)=$head(/"> $i.cma;
		tweakcma $i -CSQ >> $pref.sma;
	done
else
	get-sma-from-hpt.pl $1 list > tree_dist;

fi

#rm *selSeq;
#rm *selSeq.cma;
