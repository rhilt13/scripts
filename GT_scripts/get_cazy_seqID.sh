#! /bin/bash

## First create folder GT-A, GT-B, ... and cd into it

## perl ~/rhil_project/GT/scripts/get_cazy_seqID.sh > multi_list

####Section 1 : Download CAZy pages,    #####
###### list families with multiple pages#####
## Output: list of files one for each family .0 extension

# # for i in 2 6 7 8 12 13 15 21 24 27 43 55 64 78 81 82 84; do 	# GT-A
# for i in 1 3 4 5 9 10 19 20 23 28 30 33 35 41 63 65 68 70 72 80; do 	# GT-B
# for i in 22 39 50 57 58 59 66 83 85 87; do 	# GT-C
# for i in 51; do 	# GT-lyso
# # for i in 11 14 16 17 18 25 26 29 31 32 34 36 37 38 40 42 44 45 46 47 48 49 52 53 54 56 60 61 62 67 69 71 73 74 75 76 77 79 86 88 89 90 91 92 93 94 95 96 97 98; do 	# GT-unknown
# # # for i in 2 8 12; do 	# test

#  	wget -q -O GT$i.0 "http://www.cazy.org/GT${i}_all.html#pagination_PRINC"
#  	j=$(cat GT$i.0|grep 'pagination'|wc -l)
#  	# echo $j;
# 	if [ "$j" -ne 0 ] 2>/dev/null; then
# 		echo $i;
# 	fi 
# # 	j=$(cat GT$i.0|grep 'nofollow'|grep '/span'| sed 's/nofollow.>/~/'|cut -f2 -d'~'|cut -f1 -d'<')
# # 	# echo $j;
# # 	echo "$i  $j"
# done
### End Section 1 ###############

#### Section 2 : For listed families above, either ########
#### in <STDIN> or if redirected output when running 
#### above section in multi_list,
#### manually enter below lines based on last page number (look up manually from CAZy)
#### to download all pages after the first
#### enter number from 1.. one less than final page number
## Output: list of files one for each family .1, .2, ... extension

# for i in {1..4}; do wget -O GT8.$i "http://www.cazy.org/GT8_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..76}; do wget -O GT2.$i "http://www.cazy.org/GT2_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# wget -O GT15.1 "http://www.cazy.org/GT15_all.html?debut_PRINC=1000#pagination_PRINC"

# for i in {1..2}; do wget -O GT25.$i "http://www.cazy.org/GT25_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..3}; do wget -O GT26.$i "http://www.cazy.org/GT26_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..2}; do wget -O GT61.$i "http://www.cazy.org/GT61_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# wget -O GT32.1 "http://www.cazy.org/GT32_all.html?debut_PRINC=1000#pagination_PRINC"
# wget -O GT69.1 "http://www.cazy.org/GT69_all.html?debut_PRINC=1000#pagination_PRINC"

# for i in {1..10}; do wget -O GT1.$i "http://www.cazy.org/GT1_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..58}; do wget -O GT4.$i "http://www.cazy.org/GT4_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..8}; do wget -O GT5.$i "http://www.cazy.org/GT5_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..9}; do wget -O GT9.$i "http://www.cazy.org/GT9_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..3}; do wget -O GT19.$i "http://www.cazy.org/GT19_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..3}; do wget -O GT20.$i "http://www.cazy.org/GT20_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..7}; do wget -O GT28.$i "http://www.cazy.org/GT28_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..3}; do wget -O GT30.$i "http://www.cazy.org/GT30_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# for i in {1..5}; do wget -O GT35.$i "http://www.cazy.org/GT35_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# wget -O GT41.1 "http://www.cazy.org/GT41_all.html?debut_PRINC=1000#pagination_PRINC"

# wget -O GT39.1 "http://www.cazy.org/GT39_all.html?debut_PRINC=1000#pagination_PRINC"
# for i in {1..3}; do wget -O GT83.$i "http://www.cazy.org/GT83_all.html?debut_PRINC=${i}000#pagination_PRINC"; done
# wget -O GT87.1 "http://www.cazy.org/GT87_all.html?debut_PRINC=1000#pagination_PRINC"

# for i in {1..16}; do wget -O GT51.$i "http://www.cazy.org/GT51_all.html?debut_PRINC=${i}000#pagination_PRINC"; done

### End Section 2 ###############

####Section 3 : Parse the downloaded pages to get alist of IDs #######
rm cazyID_list.txt
for k in `ls GT*`; do
	perl ~/rhil_project/GT/scripts/parse_cazy.pl $k >> cazyID_list.txt
done
#### End Section 3 ##############

####Section 4 : Edit ID list ##########
## Move the file to main folder with different name

# mv cazyID_list.txt ../CAZy_*_ID_list.txt

## Filter to get only the IDs list

# less cazy_*_ID_list.txt|cut -f4|sort -u > cazy_*_ID_list.txt.ID

####Section 4 ########
## Run script get_seq_eutil.pl in ~/rhil_project/scripts folder 
## to get sequences from the listed IDs
## Output: CAZy_*_genbank.faa

# perl ~/rhil_project/scripts/get_seq_eutil.pl cazy_*_ID_list.txt.ID > CAZy_*_genbank.faa

### End Secion 4 ###############

####Section 5 #########
## Run script get_tax_eutil.pl in ~/rhil_project/scripts folder 
## to get taxonomic information from the listed IDs
## Output: CAZy_*_genbank.tax_map

# perl ~/rhil_project/scripts/get_tax_eutil.pl cazy_*_ID_list.txt.ID > CAZy_*_genbank.tax_map

## Filter the above output to remove ones that do not have taxonomic info
## Output: CAZy_*_genbank.tax_map.filter

# perl ~/rhil_project/GT/scripts/get_edited_ID.gt.pl cazy_*_ID_list.txt CAZy_*_genbank.tax_map CAZy_*_genbank.faa > CAZy_*_genbank.faa.IDedit

### End Section 5 ##############

####Section 6 #################
## Run script get_edited_ID.gt.pl in ~/rhil_project/GT/scripts folder 
## to get edited sequences from the listed IDs
## Output: CAZy_GT-A_genbank.faa.IDedit

# perl 

### End Section 6 ##############