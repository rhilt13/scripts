#! /bin/bash

# $1 --> Location of profile ( ../../../profile/gt_rev9)
# $2 --> FASTA file (CAZy_allGT_genbank.faa.IDedit)

j=$(echo $1|sed 's/.tpl//'|rev|cut -f1 -d'/'|rev);
mkdir $j;
cp $2 $j;
cd $j;
run_gaps ../$1 $2 -O &>>$2.hits;
cp ${2}_aln.cma ../main_hits.cma 
# cat ${2}_aln.cma|sed '1,7d'|head -n -2 > ../${2}_main_hits
# cat ../${2}_main_hits|grep '^>'|sed 's/^>//'|sort > ../${2}_main_hits.ids
rm $2;
cd ..;
for i in `ls $1_*.tpl`; do 
	j=$(echo $i|sed 's/.tpl//'|rev|cut -f1 -d'/'|rev);
	k=$(echo $i|sed 's/.tpl//');
	mkdir $j; 
	cp $2 $j; 
	cd $j;run_gaps ../$k $2 -O &>>$2.hits;

	# cat ${2}_aln.cma|grep '^>'|sed 's/^>//'|sort > ${2}_hits.ids
	# comm -1 ../${2}_main_hits.ids ${2}_hits.ids > ${2}_sel.ids
	# parse_cma.pl ${2}_aln.cma sel ${2}_sel.ids|sed '1,2d'|head -n -2 >> ../${2}_added_hits
	rm $2;
	cd ..; 
done

find . -name *_aln.cma > filenames
parse_cma.pl main_hits.cma compare list filenames >${2}_final.cma
parse_cma.pl main_hits.cma len 140 600 >${2}_final.l140.cma
# cat ${2}_main_hits ${2}_added_hits > ${2}_final_hits

# rm main_hits.cma filenames
