#! /bin/bash

# Ver: 0.2

# Usage:
# get-seq-eutil.sh <file_with_list_of_Accession> > <outfile>
# get-seq-eutil.sh <file_with_list_of_Accession> local <full_path_to_local_BLAST_database> > <outfile>

# Log:
# Ver 0.2: added an option $2="local" to retrieve sequences from a local version of nr database. Previous functions still compatible.

cat $1|awk '{$1=$1;print}'|sort -u|perl -e '$a=0;$c=0;$it=1000;@lines=<>;$b=int(scalar(@lines)/$it);foreach $id(@lines){chomp $id;$a++;$str.=$id.",";if ($c>=$b){$str1.=$id.",";}if ($c<$b){$c++;}if ($a % $it == 0){$c++;$str=~s/,$//;print "$str\n";$str="";$str1="";}}$str1=~s/,$//;print $str1,"\n";' > $1.groups

if [ "$2" == "local" ]
then
	>&2 echo "Retrieving sequence from $3";
	for i in `cat $1.groups`; do blastdbcmd -db $3 -entry $i; done
else
	>&2 echo "Retrieving sequence from nr databse."
	for i in `cat $1.groups`; do esearch -db protein -query $i |efetch -format fasta; done
fi
rm $1.groups
