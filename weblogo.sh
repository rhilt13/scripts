#! /bin/bash

## Input:
# 1 - cma file
# 2 - file with list of start end positions
# 3 - remove consensus

# Remove consensus if needed
if [[ $3 == "cons" ]]; then
	cat $1|sed '1,6d' > temp_file1
else
	cp $1 temp_file1
fi
# Change cma to regular fa file
cat temp_file1|grep '^>\|^\{'|perl -lne 'if ($_=~/^{/){$_=~s/^{\(\)//;$_=~s/\(\)}\*$//;$_=~s/[a-z]//g;print $_;}else{print $_;}' > $1.fa
# get postitions from pos file and generate logo
i=0;
while read line; do
	i=$(($i+1));
	first=$(echo $line|cut -f1 -d' ');
	second=$(echo $line|cut -f2 -d' ');
	j=$(($second-$first+3));
	seqlogo -f $1.fa -F EPS -h 5 -k 0 -l $first -m $second -o $1.$i -w $j -c -M -n;
done < $2
# save logo to filename as cma with numeric extension
rm temp_file1 $1.fa 