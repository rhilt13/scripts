#! /bin/bash

## Input:
# 1 - input file
# 2 - file with list of start end positions
#	~/GT/gta_revise9/analysis/weblogo/test/test_pos.txt
# 3 - input file type (cma or fa)
# 4 - remove consensus (cons if yes) 

# Sample run for seqlogo
# for i in `cat list`; do ~/tools/weblogo1/seqlogo -f $i.fa -F PNG -l 346 -m 347 -o ${i}-1 -c -Y -h 5 -T 1 -a; done

## If starting from a cma file with consensus
#Remove consensus if needed
if [[ $4 == "cons" ]]; then
	cat $1|sed '1,6d' > temp_file1
else
	cp $1 temp_file1
fi

## If starting from a cma file without consensus
# Change cma to regular fa file
if [[ $3 == "cma" ]]; then
	cat temp_file1|grep '^>\|^\{'|perl -lne 'if ($_=~/^{/){$_=~s/^{\(\)//;$_=~s/\(\)}\*$//;$_=~s/[a-z]//g;print $_;}else{print $_;}' > $1.fa
else
	if [[ $4 == "cons" ]]; then
		cp temp_file1 $1.fa
	else
		cp $1 $1.fa
	fi
fi
## If starting from a fasta file
# get postitions from pos file and generate logo
i=0;
while read line; do
	i=$(($i+1));
	first=$(echo $line|cut -f1 -d' ');
	# echo $first
	second=$(echo $line|cut -f2 -d' ');
	# echo $second
	j=$(($second-$first+3));
	seqlogo -f $1.fa -F EPS -h 5 -k 0 -l $first -m $second -o $1.$i -w $j -c -M;
	# weblogo -f LRRIII_IRAK_TKL.short.fa -D fasta -o lrriii_3 -A protein -s large -X NO --scale-width NO --errorbars NO -C black AVLIPWMF 'nonpolar' -C blue HRK 'basic' -C purple NQ 'amides' -C green GYSTC 'polar' -C red DE 'acidic' -y ' ' -P' ' --logo-font Arial-BoldMT -l 27 -u 30
done < $2
# save logo to filename as cma with numeric extension
# rm temp_file1 $1.fa 
