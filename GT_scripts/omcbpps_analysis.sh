#! /bin/bash

### omcBPPS output downstream analysis

## Run in the omcbpps output folder
## Will create the sets folder
## Will create the pdb_map folder

######################################################
## Input:
## $1 = _new.mma file with the mma
## $2 = absolute Full path to rungaps output pdb_seqres.faa_aln.cma file for the pdb database 
#		(~/GT/gta_revise*/rungaps_*/pdb/pdb_seqres.faa_aln.cma)
## $3 = specify method 
##		1 if sequence ID has family info
##		2 if need to run rungaps to get info
## $4 = absolute full path to the run_gaps profile (~/rhil_project/GT/gta_revise6/profile/gt_rev6)
## $5 = absolute path to order file (~/rhil_project/GT/gta_revise6/profile/order)
## $6 = absolute path to the folders with pdb files
######################################################
## Output:
## Generates a sets folder that has all files.
## check hits_details for detailed list.
## use hits_details_parse for getting heatmaps of hits

## Also runs map_pdb_afteromcBPPS.sh script
## Generates pdb_map folder and pdb_map_table fie
######################################################

## Uses the ~/rhil_project/GT/scripts/parse_omcbppsSets_hit_list.pl script
## Also runs map_pdb_afteromcBPPS.sh script

######################################################
## To run:
## bash ~/rhil_project/GT/scripts/omcbpps_analysis.sh cazy_nongt2_pdb.p99_new.mma ../rungaps*/pdb/pdb_seqres.faa_aln.cma 1
## bash ~/rhil_project/GT/scripts/omcbpps_analysis.sh nr_nongt2_pdb.p90_new.mma ../rungaps*/pdb/pdb_seqres.faa_aln.cma 2 ~/rhil_project/GT/gta_revise3/profile/gt_rev2 ~/rhil_project/GT/gta_revise3/profile/order
## 

mkdir sets
cp $1 sets/
file=$(echo $1|sed 's/\.[mc]ma$//g');
file_short=$(echo $1|sed 's/_new\.[mc]ma$//g');
cd sets

## Separate _new.mma file into sets
## Old one liner
## less ../rungaps_pdb_sprot.purge90_new.mma|tr '\n' '%'|perl -e 'while(<>){@a=split(/_0]./,$_);pop @a;foreach $set(@a){($file)=($set=~/=(Set\d+)\(/);open $output,">$file"; $set=~s/%/\n/g;print $output "$set\n_0].";}}'
tweakcma $file -write

######################################################
## If the sequence IDs have family information copy paste and use this section to get hits_details file 

if [ $3 -eq 1 ]; then
	for i in `ls *Set*cma`; do less $i|grep '^\[\|^>'|cut -f1 -d'|'|sort|uniq -c|perl -lne 'if ($_=~/Set/){($n)=($_=~/(Set[0-9]*)\(/);print $n;}else{print $_;}'; done > hits_details_direct
fi

######################################################
## If need to run rungaps to find matching family info 

if [ $3 -eq 2 ]; then
	## Get rid of the BPPS line which creates error in running rungaps
	for i in `ls *Set*cma`; do cat $i|sed 's/\;BPPS=.*/:/' > $i.edit.cma; done

	## Generate fa files from cma to use in rungaps
	for i in `ls *Set*cma.edit.cma`; do j=$(echo $i|sed 's/\.cma$//g'); cma2fa $j|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > $j.fa; done

	## Run rungaps back to the profiles to find out which families the omcBPPS set hits belong to
	for i in `ls *fa`; do run_gaps $4 $i -O &>>$i.hits; done

	## Get details of all the hits in one file
	for i in `ls *hits`; do j=$(echo $i|grep -o 'Set[0-9]*');k=$(cat $i|grep '^==');echo $j $k|sed 's/ =/\n\t/g'; done |sed 's/\s+$//g' > hits_details

	## Parse hits_details obtained from above to get a heatmap distribution of sets
	parse_omcbppsSets_hit_list.pl hits_details $5 > hits_details_parse 

	## Old one liner
	## cat hits_details |sed 's/\s+$//g'|perl -e 'while(<>){chomp;if ($_=~/^Set/){$_=~s/Set//g;$a=$_;push(@arr,$a);}else{($b,$c)=($_=~/GT-A\|(.*?)\|cons.* \((\d+)/);push (@arr2,$b);$hash{$a}{$b}=$c;}}print "\t";foreach $n(@arr){print "$n\t";}print "\n";for(@arr2){$foo{$_}++};@unique = (keys %foo);foreach $m(@unique){print "$m\t";foreach $n(@arr){if (defined $hash{$n}{$m}){print "$hash{$n}{$m}\t";}else{print "0\t"}}print "\n";}' > hits_details_parse
fi
cd ..
map_pdb_afteromcBPPS.sh $file_short $6 $2

less sets/hits_details|cut -f2 -d'|'|cut -f1 -d' '|sed 's/^Set/~/g'|tr '\n' ' '|tr '~' '\n' > map_fam_info
less map_fam_info |perl -e 'while(<>){@a=split(/ /,$_);$hash{$a[0]}=$a[1];}open(IN,"map_pdb_table");while(<IN>){chomp;($num)=($_=~/Set([0-9]+)/);print "$hash{$num}\t$_\n";}' > map_pdb_table_details
