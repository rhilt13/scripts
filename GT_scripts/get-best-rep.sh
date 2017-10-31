#! /bin/bash

for i in `ls *.cma`; do
	n=$(echo $i|sed 's/\.cma//');
	j=$(tweakcma $n -phyla|grep 'number'|rev|cut -f1 -d ' '|rev);
	if [ "$j" -lt 20 ]; then
		tweakcma $n -Best=1:$j;
		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
		tweakcma $n -Best=2:$j;
		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
		tweakcma $n -Best=3:$j;
		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel;
	else
		tweakcma $n -Best=1:$j;
		cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel; 
	fi; 
done
