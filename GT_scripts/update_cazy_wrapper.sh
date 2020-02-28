#! /bin/bash

## User input
# $1 - Total No of cazy families
# TSV List with fold and family names - cazy_fam_list.txt

## Output
# cazy_allIDlist = List of all sequence IDs from CAZy database

### Things to do Manually:

#	Create a new folder called CAZy_fam_update[]
#	cd into the directory. Sub folders will be created automatically.

#	Get number of CAzy families from http://www.cazy.org/GlycosylTransferases.html
# 	Adjust number range in input $1

## PART 1: Get family information General
#	Out: CAZy_fam_details
#	Sub: A, B, C, u and lyso

# mkdir html
# cd html
# mkdir seq_pages
# cd seq_pages
fam_num=$1
#### Section 1 : Download CAZy pages #####
for (( i=5; i<=$fam_num; i++ )); do 		#[num1]
	wget -q -O GT${i}_all.html "http://www.cazy.org/GT${i}_all.html#pagination_PRINC"
	pg_count=$(grep nofollow GT${i}_all.html |grep -v pagination|cut -f2 -d'>'|cut -f1 -d'<')
	for (( c=1; c<$pg_count; c++ )); do
		wget -O GT${i}_${c}.html "http://www.cazy.org/GT${i}_all.html?debut_PRINC=${c}000#pagination_PRINC";
	done
done
#### End Section 1 #######################

# #### Section 2 : Parse the downloaded pages to get alist of IDs #######
# if [ -d "../../Seq/Tables" ]; then
# 	rm ../../Seq/Tables/cazy_allTable
# else
# 	mkdir ../../Seq
# 	mkdir ../../Seq/Tables
# fi
# for k in `ls GT*`; do
# 	parse_cazy.pl $k >> ../../Seq/Tables/cazy_allTable
# done
# #### End Section 2 #######################
# cd ../../Seq/Tables

# #### Section 3 : Edit ID list to add tags and separate out GT-A,B,C.. families and keep only IDs ##########
# # Add GT fold tags to the all ID list:
# less cazy_allTable|perl -e 'open(IN,"../../cazy_fam_list.txt");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[1]}=$a[0];}while(<>){chomp;@a=split(/\t/,$_);if (exists $hash{$a[0]}){print "$hash{$a[0]}\t$_\n";}else{print "ERROR: GT family not assigned to $a[0]"; die;}}' |sed 's/\[//g;s/\]//g' > cazy_allTable.e1

# # Separate out GT fold family IDs:
# cat cazy_allTable.e1|grep '^GT-A' > cazy_GT-A_Table
# cat cazy_allTable.e1|grep '^GT-B' > cazy_GT-B_Table
# cat cazy_allTable.e1|grep '^GT-C' > cazy_GT-C_Table
# cat cazy_allTable.e1|grep '^GT-u' > cazy_GT-u_Table
# cat cazy_allTable.e1|grep '^GT-lyso' > cazy_GT-lyso_Table

# for i in `ls *_Table`; do 
# 	cat $i|cut -f5 >$i.IDs;
# done
# #### End Section 3 #######################

#### Section 4 : Get full length sequences and taxonomy report ##########

# for i in `ls *.IDs`; do
# 	j=$(echo $i|cut -f1,2 -d'_');
# 	get-seq-eutil.sh $i > ../${j}_genbank.faa;
# done

# mkdir ../tax

# for i in `ls *_Table`; do
# 	j=$(echo $i|cut -f1,2 -d'_');
#	cat $i|perl -lne '@a=split(/\t/,$_);print "$a[4]\t$a[3]";' |grep -v -P '^\t' > ../tax/${j}.list;
# 	get_tax_ete.py -i ../tax/${j}.list|grep -v '^ERROR' > ../tax/${j}_genbank.tax;
# done
# #### End Section 4 #######################

# cd ../

# #### Section 5 : Edit sequence IDs #######

# for i in `ls *genbank.faa`; do
# 	j=$(echo $i|cut -f2 -d'_');
# 	edit_cazyIDs.pl Tables/cazy_${j}_Table tax/cazy_${j}_genbank.tax $i > $i.IDedit;
# done
#### End Section 5 #######################
#### END PART 1 ##########################

## PART 2 STRUCTURES
# cd ../html
# mkdir str_pages
# cd str_pages

# #### Section 1 : Download CAZy pages #####
#for i in {1..106}; do wget www.cazy.org/GT${i}_structure.html; done
#### End Section 1 #######################

# #### Section 2 : Generate Structure list table for each family #####
# Get tables from the html pages
# for i in `ls *_structure.html`; do 
# 	less $i|grep '<title\|db=protein&val\|structureId'| \
# 	sed 's/"//g;s/<br>/,/g;s/<b>//g;s/<\/b><\/a>//g;s/<\/td>//g'| \
# 	perl -e 'while(<>){$_=~s/\n//g;$_=~s/\r//g;chomp;if ($_=~/^<title/){($fam)=($_=~/ (GT[0-9]+)</);}else{($a)=($_=~/_link>(.*)$/);if ($a=~/\[/){$a=lc($a);@b=split(/</,$a);print "$b[0],";}else{print "\n$fam\t$a\t";}}}print "\n";'| \
# 	sed '1d' >${i}.table; 
# done
#### End Section 2 #######################

# #### Section 3 : Move to directories and compile final lists #####
# mkdir ../../Str
# mkdir ../../Str/fam_str_tables
# mv *table ../../Str/fam_str_tables
# cd ../../Str/
# cat fam_str_tables/* > GT_str_table
#### End Section 3 #######################
#### END PART 2 ##########################

### PART 3 CHARACTERIZED
# cd ../html/
# mkdir characterized_pages
# cd characterized_pages

# #### Section 1 : Download CAZy pages #####
# for (( i=1; i<=$fam_num; i++ )); do 		#[num1]
# 	wget -q -O GT${i}_characterized.html "http://www.cazy.org/GT${i}_characterized.html"
# 	pg_count=$(grep nofollow GT${i}_characterized.html|tail -1|rev|cut -f3 -d'>'|rev|cut -f1 -d'<')
# 	for (( c=1; c<$pg_count; c++ )); do
# 		wget -O GT${i}characterized_${c}.html "http://www.cazy.org/GT${i}_characterized.html?debut_FUNC=${c}00#pagination_FUNC";
# 	done
# done

# #### Section 2 : Parse the downloaded pages to get alist of IDs #######
# if [ -d "../../Characterized/Tables" ]; then
# 	rm ../../Characterized/cazy_allCharacterizedTable
# else
# 	mkdir ../../Characterized
# 	mkdir ../../Characterized/Tables
# fi
# for k in `ls GT*`; do
# 	parse_cazy.pl $k >> ../../Characterized/Tables/cazy_allCharacterizedTable
# done
# #### End Section 2 #######################

# cd ../../Characterized/Tables

# #### Section 3 : Edit ID list to add tags and separate out GT-A,B,C.. families and keep only IDs ##########
# # Add GT fold tags to the all ID list:
# less cazy_allCharacterizedTable|perl -e 'open(IN,"../../cazy_fam_list.txt");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[1]}=$a[0];}while(<>){chomp;@a=split(/\t/,$_);if (exists $hash{$a[0]}){print "$hash{$a[0]}\t$_\n";}else{print "ERROR: GT family not assigned to $a[0]"; die;}}' |sed 's/\[//g;s/\]//g' > cazy_allCharacterizedTable.e1

# # Separate out GT fold family IDs:
# cat cazy_allCharacterizedTable.e1|grep '^GT-A' > cazy_Char_GT-A_Table
# cat cazy_allCharacterizedTable.e1|grep '^GT-B' > cazy_Char_GT-B_Table
# cat cazy_allCharacterizedTable.e1|grep '^GT-C' > cazy_Char_GT-C_Table
# cat cazy_allCharacterizedTable.e1|grep '^GT-u' > cazy_Char_GT-u_Table
# cat cazy_allCharacterizedTable.e1|grep '^GT-lyso' > cazy_Char_GT-lyso_Table

# for i in `ls *_Table`; do 
# 	cat $i|cut -f5 >$i.IDs;
# done
# #### End Section 3 #######################

#### Section 4 : Get full length sequences and taxonomy report ##########
# Problems with running this section.. not able to retrieve all sequences (record removed, old..)

# for i in `ls *.IDs`; do
# 	j=$(echo $i|cut -f1,2 -d'_');
# 	get-seq-eutil.sh $i > ../${j}_characterized_genbank.faa;
# done

# mkdir ../tax

# for i in `ls *_Table`; do
# 	j=$(echo $i|cut -f1,2,3 -d'_');
#	cat $i|perl -lne '@a=split(/\t/,$_);print "$a[4]\t$a[3]";' |grep -v -P '^\t' > ../tax/${j}.list;
# 	get_tax_ete.py -i ../tax/${j}.list|grep -v '^ERROR' > ../tax/${j}_genbank.tax;
# done
# #### End Section 4 #######################

# cd ../

# #### Section 5 : Edit sequence IDs #######

# for i in `ls *genbank.faa`; do
# 	j=$(echo $i|cut -f2 -d'_');
# 	edit_cazyIDs.pl Tables/cazy_Char_${j}_Table tax/cazy_Char_${j}_genbank.tax $i > $i.IDedit;
# done
#### End Section 5 #######################
#### END PART 1 ##########################