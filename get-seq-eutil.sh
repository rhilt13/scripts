#! /bin/bash

# Usage:
# get-seq-eutil.sh <file_with_list_of_Accession>

cat $1|awk '{$1=$1;print}'|sort -u|perl -e '$a=0;$c=0;$it=1000;@lines=<>;$b=int(scalar(@lines)/$it);foreach $id(@lines){chomp $id;$a++;$str.=$id.",";if ($c>=$b){$str1.=$id.",";}if ($c<$b){$c++;}if ($a % $it == 0){$c++;$str=~s/,$//;print "$str\n";$str="";$str1="";}}$str1=~s/,$//;print $str1,"\n";' > $1.groups
for i in `cat $1.groups`; do esearch -db protein -query $i |efetch -format fasta; done
rm $1.groups
