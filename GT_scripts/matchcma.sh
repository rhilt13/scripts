#! /bin/bash

# bash ~/rhil_project/GT/scripts/matchcma.sh cazy_allgt2.cma DH104 ../../run_gaps_separate/seq_partition_lookup_table

matchcma $1 $2 -M

mv Match_$1 $2.yes.cma
cat $2.yes.cma|grep '^>'|cut -f2 -d'>' > $2.yes.cma.IDtemp
perl ~/rhil_project/scripts/match.pl $2.yes.cma.IDtemp $3 > $2.yes.cma.partition

perl ~/rhil_project/scripts/parse_cma.pl $1 unsel $2.yes.cma.IDtemp > $2.not.cma
cat $2.not.cma|grep '^>'|cut -f2 -d'>' > $2.not.cma.IDtemp
perl ~/rhil_project/scripts/match.pl $2.not.cma.IDtemp $3 > $2.not.cma.partition

echo '####### $2.yes Set ############' > $2.hits_count
cat $2.yes.cma.partition |cut -f2|sort|uniq -c >>$2.hits_count
echo '####### $2.yes CDD ############' >>$2.hits_count
cat $2.yes.cma.partition |cut -f3|sort|uniq -c >>$2.hits_count
echo '####### $2.not Set ############' >>$2.hits_count
cat $2.not.cma.partition |cut -f2|sort|uniq -c >>$2.hits_count
echo '####### $2.not CDD ############' >>$2.hits_count
cat $2.not.cma.partition |cut -f3|sort|uniq -c >> $2.hits_count

rm ${1}_exel.rtf $1.pdb $1.ras *.IDtemp