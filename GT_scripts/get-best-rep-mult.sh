#! /bin/bash

for i in `ls *.cma`; do
	echo $i;
	n=$(echo $i|sed 's/\.cma$//');
	echo $n;
	j=$(tweakcma $n -phyla|grep 'number'|rev|cut -f1 -d ' '|rev);
#	if [ "$j" -lt $(($1/3)) ]; then
		for k in $(seq 1 $(($1/$j+1))); do
			tweakcma $n -Best=$k:$j;
			cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
		done;
#	else
#		tweakcma $n -Best=1:$j;
#		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
#		tweakcma $n -Best=2:$j;
#		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
#		tweakcma $n -Best=3:$j;
#		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
#	fi;
done
