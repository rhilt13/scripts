#! /bin/bash

printf "#Metabolite\tExperiment\tTOC_1NS\tTOC_1TD\tTOC_1O1\tTOC_1SW\tTOC_2SFO1\tTOC_2TD\tTOC_2O1\tTOC_2SW\tHS_1NS\tHS_1TD\tHS_1O1\tHS_1SW\tHS_2SFO1\tHS_2TD\tHS_2O1\tHS_2SW\n";
for i in `ls`; do 
	if [[ -d $i/HH_TOCSY && -d $i/1H_13C_HSQC ]]; then 
		met=$(echo $i|cut -f1 -d'.');
		exp=$(echo $i|cut -f2 -d'.');
		nstoc1=$(cat $i/HH_TOCSY/acqu|grep '^##$NS='|cut -f2 -d' '|sed 's/\n//g'); 
		tdtoc1=$(cat $i/HH_TOCSY/acqu|grep '^##$TD='|cut -f2 -d' '|sed 's/\n//g');
		o1toc1=$(cat $i/HH_TOCSY/acqu|grep '^##$O1='|cut -f2 -d' '|sed 's/\n//g');
		swtoc1=$(cat $i/HH_TOCSY/acqu|grep '^##$SW='|cut -f2 -d' '|sed 's/\n//g');
		
		sfo1toc2=$(cat $i/HH_TOCSY/acqu2|grep '^##$SFO1='|cut -f2 -d' '|sed 's/\n//g');
		tdtoc2=$(cat $i/HH_TOCSY/acqu2|grep '^##$TD='|cut -f2 -d' '|sed 's/\n//g');
		o1toc2=$(cat $i/HH_TOCSY/acqu2|grep '^##$O1='|cut -f2 -d' '|sed 's/\n//g');
		swtoc2=$(cat $i/HH_TOCSY/acqu2|grep '^##$SW='|cut -f2 -d' '|sed 's/\n//g');
		
		nshs1=$(cat $i/1H_13C_HSQC/acqu|grep '^##$NS='|cut -f2 -d' '|sed 's/\n//g');
		tdhs1=$(cat $i/1H_13C_HSQC/acqu|grep '^##$TD='|cut -f2 -d' '|sed 's/\n//g');
		o1hs1=$(cat $i/1H_13C_HSQC/acqu|grep '^##$O1='|cut -f2 -d' '|sed 's/\n//g');
		swhs1=$(cat $i/1H_13C_HSQC/acqu|grep '^##$SW='|cut -f2 -d' '|sed 's/\n//g');
		
		sfo1hs2=$(cat $i/1H_13C_HSQC/acqu2|grep '^##$SFO1='|cut -f2 -d' '|sed 's/\n//g');
		tdhs2=$(cat $i/1H_13C_HSQC/acqu2|grep '^##$TD='|cut -f2 -d' '|sed 's/\n//g');
		o1hs2=$(cat $i/1H_13C_HSQC/acqu2|grep '^##$O1='|cut -f2 -d' '|sed 's/\n//g');
		swhs2=$(cat $i/1H_13C_HSQC/acqu2|grep '^##$SW='|cut -f2 -d' '|sed 's/\n//g');
		printf "$met\t$exp\t$nstoc1\t$tdtoc1\t$o1toc1\t$swtoc1\t$sfo1toc2\t$tdtoc2\t$o1toc2\t$swtoc2\t$nshs1\t$tdhs1\t$o1hs1\t$swhs1\t$sfo1hs2\t$tdhs2\t$o1hs2\t$swhs2\n"; 
	fi; 
done