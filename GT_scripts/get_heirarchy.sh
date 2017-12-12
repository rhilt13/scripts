## get GT-A CDs into separate folder
less cdtrack.txt |grep 'cd00761'|tr -s " "|sed 's/\s/\t/g'|cut -f1 > GT_cdd.IDlist

#### Option 1
for i in `less GT_cdd.IDlist`; do cp CDD/$i.FASTA > GT-A/; done
#### Option 2
for i in `less GT_cdd.IDlist`; do perl ~/rhil_project/scripts/remove_newline_fasta.pl CDD/$i.FASTA > GT-A/$i.FASTA.press; done

## Manually make a list of subtree families
nano GT_sub_fam.txt

## Create list of CDs that fall within subtrees
for i in `less GT_sub_fam.txt`; do less cdtrack.txt |grep "$i"|tr -s " "|sed 's/\s/\t/g'|cut -f1|grep -v "$i" > GT_cdd.IDlist.$i; done

## Move subtree CDs into respective subtree folders
#### Option 1
for i in `less GT_sub_fam.txt`; do mkdir GT-A/$i; rm GT-A/$i.FASTA; for j in `less GT_cdd.IDlist.$i`; do mv GT-A/$j.FASTA GT-A/$i; done; done;
#### Option 2
for i in `less GT_sub_fam.txt`; do mkdir GT-A/$i; rm GT-A/$i.FASTA.press; for j in `less GT_cdd.IDlist.$i`; do mv GT-A/$j.FASTA.press GT-A/$i; done; done;

## Get counts for number of sequences in each CD alignments
for i in `find . -type f`; do w=$(cat $i|grep '^>'|wc -l); echo "$i $w"; done > ../GT-A_counts.txt

## Press FASTA files to remove newlines between sequences
## No need to run if followed option 2
for i in `find . -type f`; do perl ~/rhil_project/scripts/remove_newline_fasta.pl $i > $i.press; done

##########################################################

## Get consensus sequences from CD alignments not in the subtrees or in main GT-A folder and cat into one cons file
#### Note: Consensus of consensus from subtrees need to be added to this file.
for i in `find . -maxdepth 1 -type f -name '*FASTA.press'`; do name=$(ls $i|cut -f2 -d'/'|cut -f1 -d'.');seq=$(head -2 $i|tail -1|sed 's/-//g');printf ">GT-A|$name|consensus\n$seq\n" >> GT-A.cons; done

## Get consensus sequence from each subtree CD alignment and cat into one cons file
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; for i in `find . -type f -name '*FASTA.press'`; do name=$(ls $i|cut -f2 -d'/'|cut -f1 -d'.');seq=$(head -2 $i|tail -1|sed 's/-//g');printf ">GT-A|$j|$name|consensus\n$seq\n" >> $j.cons; done;  cd ../../; done

## Run MAFFT to get multiple sequence alignment for each of the subtree consensus sequence files
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; for i in `find . -type f -name '*cons'`; do mafft --maxiterate 1000 --localpair $i > $i.msl; done;  cd ../../; done

## Press msl files to remove newlines
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; for i in `find . -type f -name '*press.cons.msl'`; do perl ~/rhil_project/scripts/remove_newline_fasta.pl $i > $i.press; done;  cd ../../; done

## Convert to cma
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; for i in `find . -type f -name '*cons.msl.press'`; do fa2cma $i > $i.cma; done;  cd ../../; done

## Get consensus
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; for i in `find . -type f -name '*msl.press.cma'`; do tweakcma -CSQ $i > $i.cons; done;  cd ../../; done

#####################

## Replace consensus ids within sub-sub family
for j in `less GT_sub_fam.txt`; do cd GT-A/$j;for i in `ls *FASTA.press.cma`; do k=$(ls $i|cut -f1 -d'.'); g="GT-A|${j}|${k}"; cat $i|sed "s/^>lcl/>$g/;s/fa2cma/$g/" > $i.idedit; done; cd ../../; done

## Replace consensus ids in sub family that have sub-sub family
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; cat $j.cons.tcof_aln.press.cma.cons|sed 's/_cons//;s/=cd/=GT-A|cd/' > $j.cons.tcof_aln.press.cma.cons.idedit; cd ../../; done

## Join sub-sub family cma files to a single sub family cma file
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; cat $j.cons.tcof_aln.press.cma.cons.idedit *FASTA.press.cma.idedit > $j.cma; cd ../../; done

## Move sub family cma file to profile_files folder
for j in `less GT_sub_fam.txt`; do cd GT-A/$j; mv $j.cma ../profile_files; cd ../../; done

## Run on GT-A folder on cdds with no sub-sub families
## Replace consensus ids in sub family with no sub sub family
for i in `ls *.FASTA.press.cma`; do k=$(ls $i|cut -f1 -d'.'); g="GT-A|${k}"; cat $i|sed "s/^>lcl/>$g/;s/fa2cma/$g/" > profile_files/$k.cma; done

## Run on profile_files folder
## Concatenate all sub family profiles in order
rm GT-A_subfam.cma; for i in `less ../ID_order`; do cat $i.cma >> GT-A_subfam.cma; done

## Concatenate all consensus sequences into one file.
for i in `less ID_order`; do cat $i.cons.tcof_aln.press|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}'>> GT-A_all.cons; done
for i in `less ID_order`; do head -6 profile_files/$i.cma|tail -2|sed 's/[{}()*]//g' >> GT-A_all.cons; done

## Manually reorder GT-A_all.cons 
## Generate MSA for GT-A_all.cons

## Copy this msa to "gta_profiles" folder and press
perl ~/rhil_project/scripts/remove_newline_fasta.pl %<MSA file>% > %<MSA file>%.press
## Convert fasta MSA to cma
fa2cma %<MSA file>%.press > %<MSA file>%.press.cma
## Generate consensus
tweakcma %<MSA file>%.press -CSQ > %<MSA file>%.press.cma.cons
## Replace IDs and make tpl file
cat %<MSA file>%.press.cma.cons|sed 's/fa2cma/GT-A/;s/ *consensus seq/\|consensus/' > gta_%<initial>%.tpl

## Copy GT-A_subfam.cma from profile_files folder 
cp ~/rhil_project/GT/GT-A/profile_files/GT-A_all.cons gta_%<initial>%.cma

## Generate profile
run_map gta_%<initial>%



############################################################
#######  Using the CDD Consensus sequences everywhere ######
############################################################

for j in `less GT_sub_fam.txt`; do { less CDD/$j.FASTA|perl -e '$i=1;while(<>){chomp;if ($_=~/^>/){if ($i > 1){die;}print "$_\n";$i++;}else{print "$_\n";}}' ; cat GT-A/$j/$j.cons ;} > GT-A/$j/$j.cons.new; done

for j in `less GT_sub_fam.txt`; do cd GT-A/$j/; k=">GT-A|${j}"; perl ~/rhil_project/scripts/remove_newline_fasta.pl $j.cons.new | perl -lne 'if ($_!~/^>/){$_=~s/-//g;print $_;}else{print $_}'|sed "s/>lcl/$k/" > $j.cons.new.edit; mv $j.cons.new.edit $j.cons.new.press; cd ../../; done

## Generate tcoffee alignments from .new.press files

for j in `less GT_sub_fam.txt`; do perl ~/rhil_project/scripts/remove_newline_fasta.pl GT-A/$j/$j.cons.new.tcof_aln |perl -lne 'if ($_=~/^>/){@a=split(/ /,$_);print $a[0];}else{print $_;}' > GT-A/$j/$j.cons.new.tcof_aln.press; fa2cma GT-A/$j/$j.cons.new.tcof_aln.press |sed "s/=fa2cma/=GT-A|$j/"> GT-A/$j/$j.cons.new.tcof_aln.press.cma; done

for i in `ls *.FASTA.press.cma`; do k=$(ls $i|cut -f1 -d'.'); g="GT-A|${k}"; cat $i|sed "s/^>lcl/>$g/;s/fa2cma/$g/"|sed 's/\[0_/[1_/;s/_0\]/_1]/' > new_profile_files/$k.cma; done

for j in `less GT_sub_fam.txt`; do cd GT-A/$j; { cat $j.cons.new.tcof_aln.press.cma|sed 's/\[0_/[1_/;s/_0\]/_1]/' ; cat *FASTA.press.cma.idedit |sed 's/\[0_/[2_/;s/_0\]/_2]/' ;} > $j.cma; cd ../../; done

for j in `less GT_sub_fam.txt`; do cd GT-A/$j; { cat $j.cons.new.tcof_aln.press.cma|sed 's/\[0_/[1_/;s/_0\]/_1]/' ; cat *FASTA.press.cma.idedit |sed 's/\[0_/[2_/;s/_0\]/_2]/' ;} > $j.cma; cd ../../; done

rm GT-A_subfam.cma; for i in `less ../ID_order`; do cat $i.cma >> GT-A_subfam.cma; done

.......
.......
#############################################
## Removing ends of consensus with GT-A|consensus as reference and building profi
#############################################
## Go backwards from above..
## Start with the gta_all.cons file containing 70 gt-a consensus sequences.
## The consensus sequences are all collected from CDD database alignments

## Align them using mafft, tcoffee...gta_all.cons.mafft (gta_all.cons.tcoffee)

## Remove blocks with leading and trailing gaps for the main GT-A consensus -- Using MEGA ... gta_all.cons.mafft.edit

## Remove gaps from the alignment to obtain trimmed sequences 
cat gta_all.cons.mafft.edit|perl -lne 'if($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > gta_all.cons.mafft.edit.nogaps

##Get alignments for all sub families (29+35) ( 6 will need consensus from sub-sub families) and put them in respective folders
## Copy everything inside GT-A/seed folder
## organization : sub/ 29
## 				: sub-sub/6/...

## Use perl script to use the nogaps file as reference to cut all alignments for sub families and sub-sub families
perl ~/rhil_project/scripts/edit_all_alignments.pl ../GT_sub_fam.txt gta_all.cons.mafft.edit.nogaps
## Output in files *.FASTA.press.edit

## Run inside sub-sub folder
cd sub-sub

## Get trimmed consensus sequences from sub-sub families and sub-families and remove gaps to get ready for alignment
for i in `ls *cons.edit`; do less $i|head -2 > $i.2; done
for j in `less ../../GT_sub_fam.txt`; do for i in `ls $j/*.FASTA.press.edit`; do less $i|head -2 >> $j.cons.edit.2; done; done
for i in `ls *.cons.edit.2`; do less $i|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > $i.nogaps; done

## Run inside sub-sub folder

#########################################################
### If run tcoffee locally

## Get tcoffee alignments from .nogaps file 
for j in `less ../../GT_sub_fam.txt`; do t_coffee -in=$j.cons.edit.2.nogaps -mode=expresso -pdb_db=/home/esbg/rhil_project/datasets/pdb_seqres.faa -evaluate_mode=t_coffee_slow -output=fasta_aln -case=upper -seqnos=off -outorder=input -multi_core=4 -quiet=stdout; done

for j in `less ../../GT_sub_fam.txt`; do rm $j.cons.edit.2.dnd $j.cons.edit.2_pdb1.template_list; done

###else if tcoffee expresso online server then
##manually
nano cd06423.aln_tcof
nano cd04181.aln_tcof
nano cd04180.aln_tcof
nano cd04179.aln_tcof
nano cd02507.aln_tcof
nano cd00505.aln_tcof
#########################################################

## Run inside sub-sub folder
## make and edit cma files out of the alignment
for i in `ls *.fasta_aln`; do perl ~/rhil_project/scripts/remove_newline_fasta.pl $i|perl -lne 'if ($_=~/^>/){@a=split(/ /,$_);print $a[0];}else{print $_;}' > $i.press; done

## Run inside sub-sub folder
for j in `less ../../GT_sub_fam.txt`; do for i in `ls $j/*.FASTA.press.edit`; do k=$(ls $i|cut -f1 -d'.'|sed 's/\//|/');l=$(echo $k|cut -f2 -d'|');g="GT-A|${k}";fa2cma $i |sed "s/fa2cma/$g/;s/\[0_/[2_/;s/_0\]/_2]/" > $j/$l.cma; done; done

## Run inside sub-sub folder
for i in `ls *fasta_aln.press`; do j=$(ls $i|cut -f1 -d'.');g="GT-A|${j}"; fa2cma $i |sed "s/fa2cma/$g/;s/\[0_/[1_/;s/_0\]/_1]/" > $i.cma; done

## Run inside sub-sub folder
## Join sub-sub cma files to make sub cma 
for j in `less ../../GT_sub_fam.txt`; do cat $j.cons.edit.2.fasta_aln.press.cma $j/*.cma > $j.cma; done

## Run inside sub folder
cd ../sub/
for i in `ls *.FASTA.press.edit`; do k=$(ls $i|cut -f1 -d'.');g="GT-A|${k}"; fa2cma $i |sed "s/fa2cma/$g/;s/\[0_/[1_/;s/_0\]/_1]/" > $k.cma; done

## Run in profile_files folder
cd ..
## Copy required cma files to profile_files folder
mkdir profile_files
cd profile_files
cp ../sub/*cma .
for i in `less ../../GT_sub_fam.txt`; do cp ../sub-sub/$i.cma .; done

## Run in profile_files folder
## Concatenate all sub profiles
rm gta_m.cma; for i in `less ../../GT-A/ID_order`; do cat $i.cma >> gta_m.cma; done

## Move to main folder. This is the cma file for profile
mv gta_m.cma ../gta_mus.cma
cd ..

## Get the tpl file
perl ~/rhil_project/scripts/remove_newline_fasta.pl gta_all.cons.muscle.edit > gta_all.cons.muscle.edit.press
fa2cma gta_all.cons.muscle.edit.press > gta_mus.tpl

## Build profile
run_map gta_mus

## Make executable
chmod 755 gta_mus.*


### Most of the useful stuff from above written as a script in update_profile.sh which usees other perl scripts as well like edit_all_alignment.pl variants.

################################################################################
### Parse separated run gaps output to identify hits
### Written as a script in parse_rungapsOut.sh

run_gaps ~/rhil_project/GT/gta_muscle_long/gta_mus_longer pdb_seqres.faa -O &>>pdb_seqres.faa.hits

less pdb_seqres.faa.hits|grep '^=='|cut -f3,4 -d' '|sed 's/: /\t/g' > fam_num_list

for i in `ls *cma`; do j=$(echo $i|cut -f4 -d'_'|cut -f1 -d'.');k=$(cat $i|grep '^>'); echo $j $k |sed 's/>/\n\t/g'; done > list_hits.txt

cat fam_num_list |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s//g;print "$hash{$_}\n";}}'|less


### To get counts of GT families instead of list of IDs:
for i in `ls CAZy_allGT_genbank.faa.IDedit_*.cma`; do j=$(echo $i|cut -f4 -d'_'|cut -f1 -d'.');k=$(cat $i|grep '^>'|cut -f1 -d'|'|sort|uniq -c); echo $j $k |sed 's/ >/\t/g;s/ /\n\t/g'; done > list_hits.txt.count

cat fam_num_list |perl -e 'while(<>){@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}open(IN,"list_hits.txt.count");while(<IN>){chomp;if ($_=~/^\t/){print "$_\n";}else{$_=~s/\s*//g;print "$_\t$hash{$_}\n";}}'|less


#####################################################################################

### Get rtf files from omcBPPS output

## from a Completed run of omcBPPS
omcBPPS CAZy_allGT_genbank.faa.IDedit_aln.purge90_chk -bst -print=R -rtf -Seed

## from incomplete run of omcBPPS ( Using checkpoint files)



## to print partition mma files and patterns files
omcBPPS gta_156 -print=P

omcBPPS gta_156 -print=R -Seed -rtf


#######################################################################################

## parse omcBPPS output sets to do run_gaps back to the profiles:
## Written as ascript in omcbpps_analysis.sh

tweakcma [_new.mma file] -write
for i in `ls *Set*cma`; do cat $i|sed 's/\;BPPS=.*/:/' > $i.edit.cma; done
for i in `ls *Set*cma.edit.cma`; do j=$(echo $i|sed 's/\.cma$//g'); cma2fa $j|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > $j.fa; done
for i in `ls *fa`; do run_gaps ~/rhil_project/GT/gta_muscle_long/gta_mus_longer $i -O &>>$i.hits; done

## Edit coulumn number in cut command to get set number
for i in `ls *hits`; do j=$(echo $i|grep -o 'Set[0-9]*');k=$(cat $i|grep '^==');echo $j $k|sed 's/ =/\n\t/g'; done |sed 's/\s+$//g' > hits_details


## Parse hits_details obtained from above to get a heatmap distribution of sets

perl ~/rhil_project/GT/scripts/parse_omcbppsSets_hit_list.pl hits_details ~/rhil_project/GT/new_ID_order > hits_details_parse

## Old one liner
## cat hits_details |sed 's/\s+$//g'|perl -e 'while(<>){chomp;if ($_=~/^Set/){$_=~s/Set//g;$a=$_;push(@arr,$a);}else{($b,$c)=($_=~/GT-A\|(.*?)\|cons.* \((\d+)/);push (@arr2,$b);$hash{$a}{$b}=$c;}}print "\t";foreach $n(@arr){print "$n\t";}print "\n";for(@arr2){$foo{$_}++};@unique = (keys %foo);foreach $m(@unique){print "$m\t";foreach $n(@arr){if (defined $hash{$n}{$m}){print "$hash{$n}{$m}\t";}else{print "0\t"}}print "\n";}' > hits_details_parse


######################################################################################

## Get a sequence partition lookup table

#perl ~/rhil_project/GT/scripts/temp_match_rungaps_hits.pl fam_num_list list_hits.txt ../CAZy_families/..../fam_num_list ../CAZy_families/..../list_hits.txt > seq_partition_lookup_table


###########################################

 cat GT-A.cons.gismo2.cma|grep '^>\|^\{'|perl -lne 'if ($_=~/^\{/){($a)=($_=~/[A-Z]\(([\w-]+)\)\}/);print $a;}else{print $_;}'|less

 less with_GT31-2/GT-A.cons.gismo2.fa |perl -lne 'if ($_=~/^>/){print $_;}else{$sub=substr $_,-47,47;print $sub;}'|less

 ###########################################

## Get pdb ids of 99% similar sequences in one row from a blast output
## Run in /home/rtaujale/rhil_project/GT/CAZy_families/run_gaps_rev3/pdb/map_self folder
 less pdb_seqres.faa_aln.faa_blout|cut -f1,2,3|perl -e 'while(<>){chomp;@a=split(/\t/,$_);if ($a[2]>99){$a[0]=~s/_.*//g;$a[1]=~s/_.*//g;if (grep( /^$a[1]$/,@{$hash{$a[0]}})){}else{push @{$hash{$a[0]}}, $a[1];}}};foreach $key(sort keys %hash){@a=sort @{$hash{$key}}; foreach $elem(@a){print "$elem\t"}print "\n";};'|sort -u > pdb_map

 ##############################################

## Written As a script in run_hieraln_omcbpps.sh
## Run hieraln to get profiles from omcbpps output
## Start from omcBPPS output directory
## Must have 	*.mma ( original mma file, not the _new.mma)
##				*_new.sets or *_chk.sets
##				*_new.hpt or *_chk.hpt

mkdir hier 
cp <main_prefix>.mma hier/<new_prefix>.mma
## Check to see if _new.sets and _new.hpt files present
if [ -f <main_prefix>_new.sets ]; then 
	cp <main_prefix>_new.sets hier/<new_prefix>.sets
elif [ -f <main_prefix>_chk.sets ]; then
	cp <main_prefix>_chk.sets hier/<new_prefix>.sets
else
	echo "No sets file. Check for *.sets file."
	exit 1

if [ -f <main_prefix>_new.hpt ]; then 
	cp <main_prefix>_new.hpt hier/<new_prefix>.hpt
elif [ -f <main_prefix>_chk.hpt ]; then
	cp <main_prefix>_chk.hpt hier/<new_prefix>.hpt
else
	echo "No hpt file. Check for *.hpt file."
	exit 1

cd hier
hieraln <new_prefix>

###########################################################

## Run hierview
## Written as a script in run_hierview_omcbpps.sh

###########################################################

## Written as rungaps_nr.sh
## Running rungaps on nr database and concatenating the results (nr_rungaps)
## First run rungaps submitting a job with the command as follows:
## Sample in /home/nknlab/rt33095/GT/rt33095_Mar_18/qsub_rev4/qsub_rungaps_rev4_nr.sh

## cd /home/nknlab/rt33095/db/rt33095_Mar_23
## export PATH=/home/nknlab/rt33095/scripts:$PATH
## for i in `ls nr.part-*`; do run_gaps ~/GT/rt33095_Mar_18/gt_rev2 $i -O; done

## Run rungaps on all nrtx partitions
for i in `ls nrtx.part-*`; do run_gaps ~/GT/gta_revise8/profile/gt_rev8 $i -O &>>$i.hits; done

mv *.cma <target_dir>/nr/run_gaps/part/
mv *.seq <target_dir>/nr/run_gaps/part/
cd <target_dir>/nr/run_gaps/
# cp part/*aln*.cma .
get head and tail -- copy from somewhere # check /home/nknlab/rt33095/GT/rt33095_Mar_18/cazy_pdb_revise4/non-gt2/nr/run_gaps
# Change number of seq to "numnumseq" in head
less part/nr.part-01.hits|grep '^=='|cut -f3,4 -d' '|sed 's/: /\t/g' > map_fam_info
for i in `ls part/nrtx.part*aln.cma`; do cat $i|sed '1,2d'|head -n -2 >> nr_<filesp>; done
## Adding head and tail in step below

## Separate out sets of hits
mkdir sets
for i in `ls part/nrtx.part-*[0-9].cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');cat $i|sed '1,7d'|head -n -2 >> sets/nr_gtrev8_$j; done
cd sets;
for i in `ls *`; do j=$(cnt $i|sed 's/^\s\+//g'|cut -f1 -d' ');cat ../head $i ../tail|sed "s|numnumseq|$j|" >$i.cma ; done

#### 

## To get nongt2 hits from nr rungaps
## decide pattern of part file numbering using fam_num_list file from rungaps folder to get all nongt2 families
cp ../cazy/fam_num_list .
for i in `ls part/nrtx.part*_2[4-9].cma`; do cat $i|sed '1,7d'|head -n -2 >> nr_nongt2; done
for i in `ls part/nrtx.part*_[3-5][0-9].cma`; do cat $i|sed '1,7d'|head -n -2 >> nr_nongt2; done

## Get gt2 similarly
## Join head and tail
for i in `ls nr_*`; do j=$(cnt $i|sed 's/^\s\+//g'|cut -f1 -d' ');cat ../head $i ../tail|sed "s|numnumseq|$j|" >$i.cma ; done


## Filter nr rungaps to get dataset to run omcBPPS on
## Get separate nongt2 and gt2 sets and filter separately

## Nongt2
parse_cma.pl nr_nongt2.cma len > nr_nongt2.l140.cma
## Gt2
parse_cma.pl nr_gt2.cma len > nr_gt2.l140.cma


##############################################################
# Get phyla distribution of all sets from nr
for i in `ls *.cma`; do n=$(echo $i|sed 's/\.cma//');j=$(tweakcma $n -phyla|grep 'number'|rev|cut -f1 -d ' '|rev);echo $n $j; done > ../phyla_distribution
less ../../../gta_revise8/rungaps_rev8/nr/phyla_distribution |perl -e 'open(IN,"../../../gta_revise8/rungaps_rev8/nr/fam_num_list");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}while(<>){chomp;($num)=($_=~/_([0-9]+)\s/);print "$_\t$hash{$num}\n";}'|less

##############################################################
# Written as script: get-best-rep.sh
## Select best representative sequences for each phyla from each hit set from nr rungaps
for i in `ls *.cma`; do n=$(echo $i|sed 's/\.cma//');j=$(tweakcma $n -phyla|grep 'number'|rev|cut -f1 -d ' '|rev);for ((k=1; k<=j; k++)); do tweakcma $n -Best=$k:10;cat ${n}_best.cma|sed '1,3d'|head -n -2 >> ${n}_sel; done; done


##############################################################

## Download pdb files from a list:
## in script ~/rhil_project/scripts/get_pdb.pl

## Do a chn_pdb analysis of specific residue withall interactions

# reduce -BUILD 1g8o.pdb > 1g8oH.pdb
# chn_pdb 1g8oH -p195
# chn_pdb 1g8o -r195
 #q-k

################################################################
####### Getting display sets
tweakcma hier_gt6_disp -c=hier_gt6.merged.cma
chn_see hier_gt6_disp -B=71:83 -S='P' -F=12


################################################################
# Get all pdb files, split the chains and reduce to add H 
# in GT/pdb/ folders
get_pdb.pl ../all_GTstr_list
for i in `ls *.pdb`;do split_chain $i; done
mv *_[A-Z].pdb ../str_split/
for i in `ls`; do j=$(echo $i|cut -f1 -d'.');k=$(echo $i|cut -f2 -d'_'); l=$j"_"$k;mv $i $l; done
for i in `ls`; do j=$(echo $i|sed 's/\.pdb//g');k=$j"_H.pdb";reduce -BUILD $i > ../str_H_nosplit/$k; done
for i in `cat ../all_GTstr_list`; do chn_pdb $i -L > ../str_H_nosplit_lab/${i}_H.pdb; done

##################################################################
## Written as bash script in ~/rhil_project/GT/scripts/map_pdb_afteromcBPPS.sh

### Run sarp to get all res mapped to pdb
# in omcBPPS/pdb folder
# Create pdb_list with desired pdb ids.( check /home/rtaujale/rhil_project/GT/gta_revise3/omcbpps_revise3/nr-non-gt2/no_minsize/pdb_all/pdb_list)
for i in `cat pdb_list`; do j=$(echo $i|cut -f2 -d'/');cp ~/rhil_project/GT/pdb/str_H_nosplit_lab/$j .; done
# check omcBPPS2PML.README file to run sarp and map residues to pml files

# Step 4 (with all pdb strucutres namelist in pdb_list)
# Sample pdb_list file in ~/rhil_project/GT/gta_revise3/omcbpps_revise3/nr-non-gt2/no_minsize/pdb_all/pdb_list
sarp pdb_list ../nr_nongt2_pdb.p90

TEMPFILE=cazy_set1.p90.l100
mv ../${TEMPFILE}_pdb.VSI .
mv ../${TEMPFILE}_pdb.klst .
mv ../${TEMPFILE}_pdb.eval .
mv ../${TEMPFILE}_pdb.best .
mv ../${TEMPFILE}.interact .
mv ../${TEMPFILE}.grph .
mv ../${TEMPFILE}.key_res .
mv ../${TEMPFILE}.ca_scores .

# Get the list of pdb mapped by sarp
less nr_nongt2_pdb.p90_pdb.VSI|grep '^\~\$\=\|^File'|cut -f2 -d'='|cut -f1 -d' '|cut -f2 -d'/'|sed 's/\.$//g;s/^\s\+//g;s/\s\+$//g;s/:/_/' > pdb_list.mapped

# Generate pml files for all pdb files
## $j = file number
## $i = vsi file ID generated by sarp
cat pdb_list.mapped|perl -e 'while(<>){chomp;if ($_=~/^[0-9]+$/){$i=$_;$j=0;}else{$j++;system("chn_vsi nr_nongt2_pdb.p90_pdb.VSI $j $i -T -skip=W -d2.5 -v -D -pml > $_.pml");}}'

# Count for pdbs with pml files
ls *pml|sed 's/_[A-Z].pml//g'|sort -u|wc

##########################################################################################
#parse hmmsearch output
less hmm.out |sed 's/ \+/\t/g'|awk 'BEGIN{FS="\t"}{if (NF==11){print $0}}'|grep 'GT' > hmm.out.hits.details

###################################################
## Use parse_cazy.pl to 
##		get list of ids and species
## 		map ids for same sequences together

####################################################
## Remove redundant sequences from CAZy_allGT_genbank.faa.IDedit
# Written as script rem_redundant.pl

# Generate a CAZy_GT-A.id_map file using parse_cazy.pl script
# for i in `ls`; do parse_cazy.pl $i map >> CAZY_GT-A.id_map; done

#make a list of all ids (for which you want to remove redundant) - organism specific, taxa specific
cat CAZy_allGT_genbank.faa.IDedit_aln.cma|grep '^>'|grep sapiens|cut -f2 -d'|' > sel_hum.ids

# use match.pl to select only single matched id from id_map 
match.pl sel_hum.ids ~/rhil_project/GT/CAZy_families/CAZy_GT-A.id_map > sel_hum.ids.uniq

# get cma sequences
parse_cma.pl CAZy_allGT_genbank.faa.IDedit_aln.cma sel sel_hum.ids.uniq > sel_hum.ids.uniq.cma

########################################################

# select representative GT2 sequences from rungaps output
# change [0-9], 1[0-9], 2[0-3]
for i in `ls CAZy_allGT_genbank.faa.IDedit_2[0-3].cma`; do head -603 $i >> cazy_gt2_rep.cma; done
# edit to remove cma partitions to merge as a single cma file


##########################################################

## change cma to fa
cma2fa cazy_pdb.p90.l100 >cazy_pdb.p90.l100.fa
cat cazy_pdb.p90.l100.fa|perl -lne 'if ($_!~/^>/){$_=~s/-//g;print $_;}else{print $_;}'> a
tail -n+4 a > b
cat b new_seq.fa > c


gismo++ new_aln.fa -fast

##########################################################

# Find out which omcBPPS sets contain a pdb file

for i in `ls cazy_set1.p90.l100_new_Set*.cma`;do echo $i;cat $i|grep '^>'|grep -v '^>GT'; done|less

###################
## Add CAZy family and species annotation to rungaps output:
for i in `ls toxo_all.faa_[0-9][0-9].cmqa`; do j=$(cat $i|grep '^>'|head -1|cut -f2 -d'|');export j;cat $i|sed '1,7d'|head -n -2|perl -lne 'if($_=~/^>/){@a=split(/ /,$_);$a[0]=~s/>//;print ">$ENV{j}|$a[0]|T.gondii_Apicomplexa";}else{print $_;}'; done|less

###############################################################################

## Get species-specific datasets and build trees (organism-specific analyses)

#get species specific sequence ids to remove redundant
for i in `cat crg_5metazoa.sp_list`; do j=$(echo $i|cut -c1-5);cat cazy_gt_rev6_gambit.cma|grep $i|cut -f2 -d'|' |sort -u > cazy_rev6_gambit_${j}.id; done

grep -f ~/rhil_project/GT/organism/ecoli/cazy_table_K12_GT_id cazy_rev6_gambit_E.col.id > cazy_rev6_gambit_E.col.K12.id

# remove redundant and get cma or fa seqs from source.
rem_redundant.sh crg_5metazoa.id ~/rhil_project/GT/CAZy_families/CAZy_allGT.id_map cazy_gt_rev6_gambit.cma cma

# Get labels for itol
i=;less $i|grep '^>'|cut -f2 -d'>'|perl -lne 'if($_=~/GT1-B/){print "$_\tlabel\t#ff0000";}elsif($_=~/GT31-u/){print "$_\tlabel\t#0000ff";}elsif($_=~/GT27-A/){print "$_\tlabel\t#00ff00";}elsif($_=~/GT29-u/){print "$_\tlabel\t#00ffff";}elsif ($_=~/GT7-A/){print "$_\tlabel\t#ffff00";}elsif($_=~/GT14-A/){print "$_\tlabel\t#ff00ff";}elsif($_=~/GT8-A/){print "$_\tlabel\t#33aa66";}elsif($_=~/GT10-B/){print "$_\tlabel\t#ff6622";}else{print "$_\tlabel\t#000000";}' > ${i}.lab.txt;
cat ${i}.lab.txt|sed 's/label/branch/'|perl -lne 'print "$_\tnormal";' > ${i}.bra.txt

cat gt32.fa|grep '^>'|sed 's/^>//'|perl -lne '@a=split(/  /,$_);($fam)=($a[1]=~/\(([A-Z])\)>\}/);if ($fam=~/B/){print "$a[0]\tlabel\t#800000";}elsif($fam=~/E/){print "$a[0]\tlabel\t#00FFFF";}elsif($fam=~/F/){print "$a[0]\tlabel\t#ff5733";}elsif($fam=~/M/){print "$a[0]\tlabel\t#8E44AD";}elsif($fam=~/V/){print "$a[0]\tlabel\t#FFFF00";}' > gt32.fa.lab.txt
cat gt32.fa.lab.txt|sed 's/label/branch/g'|perl -lne 'print "$_\tnormal";' > gt32.fa.bra.txt
# Remove consensus sequence from fa file before making tree
# Add to the top
TREE_COLORS
SEPARATOR TAB
DATA
#NODE_ID,TYPE,COLOR

cat gt32_sepPurge.l140.fa|perl -lne 'if ($_=~/^>/){@a=split(/  /,$_);($sp)=($a[1]=~/ \[([A-Z].*?)\]$/);$sp=~s/ /_/g;print "$a[0]|$sp";}else{print $_;}' > gt32_sepPurge.l140.fa.idedit

cat cr7_sel10.ordered.p95.idedit.fa|grep '^>'|sed 's/>//'|perl -lne 'if ($_=~/elegans/){if ($_=~/GT31/){print "$_\tlabel\t#8B1C62";}elsif ($_=~/GT27/){print "$_\tlabel\t#0000EE";}elsif ($_=~/GT43/){print "$_\tlabel\t#2E8B57";}elsif ($_=~/GT8-/){print "$_\tlabel\t#CD6600";}elsif ($_=~/GT2-/){print "$_\tlabel\t#CD0000";}elsif ($_=~/GT7-/){print "$_\tlabel\t#6E8B3D";}elsif ($_=~/GT13/){print "$_\tlabel\t#CD00CD";}elsif ($_=~/GT21/){print "$_\tlabel\t#CD9B1D";}elsif ($_=~/GT24/){print "$_\tlabel\t#00868B";}elsif ($_=~/GT16/){print "$_\tlabel\t#CD3700";}elsif ($_=~/GT64/){print "$_\tlabel\t#8B4789";}}else{print "$_\tlabel\t#919191";}' > cr7_sel10.ordered.p95.idedit.lab.txt

## More general form
cat sel_rev9.fa|grep '^>'|sed 's/>//'|perl -lne 'if ($_=~/GT31/){print "$_\tlabel\t#8B1C62";}elsif ($_=~/GT27/){print "$_\tlabel\t#0000EE";}elsif ($_=~/GT43/){print "$_\tlabel\t#2E8B57";}elsif ($_=~/GT8[-|]/){print "$_\tlabel\t#CD6600";}elsif ($_=~/GT2[-|]/){print "$_\tlabel\t#CD0000";}elsif ($_=~/GT7[-|]/){print "$_\tlabel\t#6E8B3D";}elsif ($_=~/GT13/){print "$_\tlabel\t#CD00CD";}elsif ($_=~/GT21/){print "$_\tlabel\t#CD9B1D";}elsif ($_=~/GT24/){print "$_\tlabel\t#00868B";}elsif ($_=~/GT16/){print "$_\tlabel\t#CD3700";}elsif ($_=~/GT64/){print "$_\tlabel\t#8B4789";}' >sel_rev9.fa.lab.txt

cat sel_rev9.single.short.fa.idedit|grep '^>'|sed 's/>//'|perl -lne 'if ($_=~/GT2[-|]/){print "$_\tlabel\t#e6194b";}elsif ($_=~/GT27/){print "$_\tlabel\t#800000";}elsif ($_=~/GT64/){print "$_\tlabel\t#fabebe";}elsif ($_=~/GT7[-|]/){print "$_\tlabel\t#aa6e28";}elsif ($_=~/GT21/){print "$_\tlabel\t#f58231";}elsif ($_=~/GT84/){print "$_\tlabel\t#ffd8b1";}elsif ($_=~/GT55/){print "$_\tlabel\t#808000";}elsif ($_=~/GT78/){print "$_\tlabel\t#ffe119";}elsif ($_=~/GT81/){print "$_\tlabel\t#fffac8";}elsif ($_=~/GT82/){print "$_\tlabel\t#d2f53c";}elsif ($_=~/GT8[-|]/){print "$_\tlabel\t#000080";}elsif ($_=~/GT32/){print "$_\tlabel\t#0082c8";}elsif ($_=~/GT6/){print "$_\tlabel\t#008080";}elsif ($_=~/GT24/){print "$_\tlabel\t#46f0f0";}elsif ($_=~/GT31/){print "$_\tlabel\t#3cb44b";}elsif ($_=~/GT15/){print "$_\tlabel\t#aaffc3";}elsif ($_=~/GT43/){print "$_\tlabel\t#911eb4";}elsif ($_=~/GT12/){print "$_\tlabel\t#f032e6";}elsif ($_=~/GT13/){print "$_\tlabel\t#00FF7F";}elsif ($_=~/GT16/){print "$_\tlabel\t#006400";}'|less
#################################################################################

## DALI output processing

## Get fasta alignment form dali text

cat pdb_align_1fo8|sed '/^$/d'|awk -F' ' '{print ">"$2"\n"$3}' > pdb_align_1fo8.fa
less pdb_align_1fo8.fa|grep '^>'|cut -f2 -d'>'|sed 's/[A-Z]$//'|sort -u > pdb_align_1fo8.fa.id
grep -f pdb_align_1fo8.fa.id /home/rtaujale/rhil_project/GT/CAZy_families/CAZy_fam_structure_list_id > yes_cazy
grep -v -f /home/rtaujale/rhil_project/GT/CAZy_families/CAZy_fam_structure_list.id pdb_align_1fo8.fa.id > no_cazy
grep -f pdb_align_1fo8.fa.id /home/rtaujale/rhil_project/GT/CAZy_families/CAZy_fam_structure_list_GT-A.id |sort -u > yes_gta

################################################################################

## Parse PCI-SS output

## Run PCI-SS from the server
## Select and Copy the alignment graphical output to a text file.
## Run following on the text file to get a table:

less test1 |sed '/^\s\+$/d;/^~$/d;/^(/d'|perl -e '$ct=0;while(<>){chomp;if ($_=~/Sequence:/){$ind=1;$ct_hold=$ct;next;}elsif($_=~/Confidence:/){$ind=2;$ct=$ct_hold;next;}elsif($_=~/Prediction:/){$ind=3;$ct=$ct_hold;next;}$ct++;$hash{$ct}{$ind}=$_;}foreach $key(sort { $a <=> $b } keys %hash){print "$key\t$hash{$key}{1}\t$hash{$key}{2}\t$hash{$key}{3}\n";}' >

##Get full length consensus sequences into a file gta_cons.fa
for i in `ls ../sel_sub/*.FASTA.press`; do cat $i|head -2; done|perl -lne 'if($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > gta_cons.fa

## Merge the ssp maps with the seq ids and the sequences in a single file:
cat gta_cons.fa |perl -e 'while(<>){chomp;$_=~s/\r//g;if ($_=~/^>/){@a=split(/\|/,$_);print "$_\t";}else{print "$_\n";$i=`cat ${a[1]}.ssp`;print $i;}}' > gta_cons.fa.sspmap

## Get ss maps into the given template alignment
perl ~/rhil_project/GT/scripts/map_ss.pl ../../../gta_revise6/profile/gt_rev6.fas.fa gta_cons.fa.sspmap ../../../gta_revise6/profile/order > gt_rev6_sspred.fa

############################################################
## Process MEGA output fasta file
remove_newline_fasta.pl new_cons3.fas|perl -lne 'if ($_=~/^>/){print $_;}else{$_=uc($_);print $_;}' > new_cons3.fas.fa

cd new_aln/
remove_newline_fasta.pl new_cons9_addgt32.fas|perl -lne 'if ($_=~/^>/){print $_;}else{$_=uc($_);print $_;}' > new_cons9_addgt32.fas.fa
order_fasta.pl ../order new_cons9_addgt32.fas.fa > new_cons9_addgt32.fas.fa.ordered
cp new_cons9_addgt32.fas.fa.ordered ../gt_rev7.fas.fa
cd ..
update_profiles.sh gt_rev7.fas.fa sel_sub order gt_rev7|less

#####################################################
## Parse hmmsearch --tblout output

# run hmmsearch against all nrtx parts
for i in `ls /auto/share/db/fasta/rungaps_partitions/nrtx.part-[0-9][0-9]`; do j=$(echo $i|rev|cut -f1 -d'/'|rev);hmmsearch --tblout $j.hmmout gt74_cazy.hmm $i; done
# merge all nr parts into one file
for i in `ls nrtx.part-*.hmmout`; do cat $i|grep -v '^#'|sed 's/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/;s/ \+/\t/'; done|sort -k5,5g|less
## Use the hmmout to get description and taxonomy
perl ~/rhil_project/scripts/temp1.pl gt32-mafft.hmmout gt32-mafft.hmmout.fa.selid.fa > a


#######
## Quick commands to work with hmm output and fasta collected from hmm

## Count aligned positions from hmmalign output stockholm to fasta file (stockholm2fasta.pl)
perl ~/rhil_project/scripts/temp2.pl gt32_refsel.1e10.hmmalign.fa len|sort -t$'\t' -k2,2nr|cat -n|less
## Count different taxa
cat gt32_refsel.hmmout.1e-10.fa.IDedit|grep '^>'|cut -f2 -d'('|cut -f1 -d')'|sort|uniq -c|less
## Select different taxa
cat gt32_refsel.hmmout.1e-10.fa.IDedit|grep '^>'|grep '(M)>}'|less
## Get counts of species in a fasta file
less gt32_refsel.hmmout.1e-10.fa.b600.IDedit|grep '^>'|rev|cut -f1 -d'['|rev|sort|uniq -c|less
## Parse selected IDs based on species name and best e value hit from hmmout file
grep -f sep_E.sel.ID gt32_refsel.hmmout|perl -lne '@a=split(/\t/,$_);($sp)=($a[18]=~/ \[([^\[]*)\]/);if (!defined $hash{$sp}){print $a[0];$hash{$sp}=1;}'


#######################################
### Parse signal peptide3.0 standard output

## Copy the output from browser to a file: signal_pep3.0_raw_* (eukaryotes,bact)

less signal_pep3.0_raw_eukaryotes|grep '^>\|^# Most' > c
# Remove lines not followed by # manually
nano c
less c|tr '\n' ' '|tr '>' '\n' > d
cat d|sed 's/ # Most likely cleavage site between pos. / /g;s/ and / /g'|cut -f1,2 -d' '|sed 's/ /\t/' > e
grep -v -f bact_list e > f
# Replace underscores in IDs to |
nano f
mv f signal_pep3.0_filter_eukaryotes

# Repeat for bacteria

#######################################
### Edit nrtx ids to format it as CAZy edited IDs
less 2AddTo_cr7_sel10.cma |grep '^>'|sed 's/^>//'|perl -lne 'if ($_=~/^GT-A\|/){@a=split(/\|/,$_);$fam=$a[1];}else{($id)=($_=~/^(.*?) /);$id=~s/.[0-9]$//;($t)=($_=~/\((.)\)>/);($tax)=($_=~/<(.*?)\(.\)>/);$tax=~s/ /./g;($sp)=($_=~/\[(.*?)\]/);@c=split(/ /,$sp);$init=substr $c[0],0,1;print "$fam|$id|$init.$c[1]_$tax.$t";}' > 2AddTo_cr7_sel10.edited
cat AddTo_cr7_sel10.fa|perl -e 'open(IN,"AddTo_cr7_sel10.edited");while(<IN>){chomp;@a=split(/\|/,$_);$hash{$a[1]}=$_;}while(<>){chomp;if ($_=~/^>/){@b=split(/ /,$_);$b[0]=~s/^>//;$b[0]=~s/\.[0-9]$//;if (exists($hash{$b[0]})){print ">$hash{$b[0]}\n";}else{print "$_\n";}}else{print "$_\n";}}' > AddTo_cr7_sel10.fa.idedit

#######################################
## Print sequence lengths of cma file sequences
less gtatree_comb2_ref1.cma |grep '^>\|^\$'|tr '\n' ' '|tr '$' '\n'|cut -f2 -d'='|sed 's/(225)//'|sort -n|less

#######################################
## Remove newline and convert to all caps for FASTA files
remove_newline_fasta.pl sel_rev9.c4.short.p90.fa|perl -lne 'if($_=~/^>/){print $_;}else{$_=uc($_);print $_;}' > a
#######################################
## Get a table with mapped pdbs to omcBPPS sets using VSI file
## Map pdbs to omcBPPS sets 

##Included as part of map_pdb_afteromcBPPS.sh script
less nr_set1_pdb.VSI|grep '^File\|Set'|grep -v 'Set1:'|cut -f2 -d'/'|cut -f1 -d'_'|uniq|tr '\n' ' '|tr ':' '\n'|awk -F "#" '{print $2,$1}'|sort -n > ../pdb_map_table


#####################################################
## Get mapping files for families mapped to omcBPPS and pdb files
## Added to omcBPPS_analysis.sh
less sets/hits_details|cut -f2 -d'|'|cut -f1 -d' '|sed 's/^Set/~/g'|tr '\n' ' '|tr '~' '\n' > map_fam_info
less sets/map_fam_info |perl -e 'while(<>){@a=split(/ /,$_);$hash{$a[0]}=$a[1];}open(IN,"map_pdb_table");while(<IN>){chomp;($num)=($_=~/Set([0-9]+)/);print "$hash{$num}\t$_\n";}' > map_pdb_table_details

#####################################################
## Find pdb files that have UDP substrates in them.
for i in `ls pdb_map/*.pml|sed 's/_[A-Z].pml$//'|sort -u`; do j=$(cat $i|grep HETATM|grep -v HOH|grep UDP);echo $i $j; done|grep UDP|cut -f1 -d' ' > yes_substrates


#####################################################

cat human_gt16.fa|tail -1|sed 's/\(.\)/\1\n/g' > temp1
cat temp1|perl -e '$line=1;$ct=120;while(<>){print "$line\t$ct\t$_";if ($_!~/-/){$ct++;}$line++;}' > human_gt16.pos_map


#####################################################
## Get IDs froma  newick tree
cat gt8_prune1500.nwk |tr ',' '\n'|cut -f1 -d':'|sed 's/(//g'|grep '\.1\|\.2\|.3' > gt8_prune1500.nwk.ids

#####################################################
## Get weblogo from cma files
## Written as bash script in weblogo.sh

#####################################################
# MD simulation

# To generate more refined pdb strucures with sec. str.
load_pdbs.py 
head_trj.py

# Refer to md_simulation script in ~/scripts folder







############################################################
## Build multiple profiles for subsets of GT-As
for i in `ls order_*`; do j=$(echo $i|sed 's/order_//');order_fasta.pl $i gt_rev9.fas.fa > gt_rev9_${j}.fa; done
for i in `ls *fa`;do cat ../cons $i > temp; mv temp $i; done
for i in `ls gt_rev9_*.fa`; do j=$(echo $i|sed 's/gt_rev9/order/;s/.fa//;');k=$(echo $i|sed 's/.fa//');update_profiles.sh $i sel_sub $j $k; done
batch_rungaps.sh <fafile>


############################################################
## Count lenght of aligned residues in a cma file
less gt_rev9_gt2_7/c4_sel.fa_6.cma |perl -e 'while(<>){chomp;if ($_=~/^>/){print ">";}elsif($_=~/^\{/){$re=0;$re++ while($_ =~ m/\p{Uppercase}/g);print "$re\n"}}'|sort -k2,2n|cat -n|less

############################################################
# Extract and annotate species specific information from CAZy
# Manually copy cazy organism page table to <organism>_cazy_<date>
cat hum_cazy_09.01.2017 |cut -f3 > ids
get-seq-eutil.sh ids > seq
remove_newline_fasta.pl seq > a; mv a seq
# Check to see whether uniprot ids (like QE123S) are present
# If yes, change seq ids in seq file

cat hum_CAZy_GT_09.01.2017 | perl -e 'while(<>){chomp;@a=split(/\t/,$_);$a[1]=~s/,/-/g;$hash{$a[2]}=$a[1];}open(IN,"seq");while(<IN>){chomp;if ($_=~/^>/){$_=~s/^>//;@b=split(/ /,$_);$b[0]=~s/^>//;@c=split(/\./,$b[0]);print ">$hash{$b[0]}|$c[0] $_\n";}else{print "$_\n";}}' > hum_cazy.fa
cat hum_cazy.fa |grep '^>'|cut -f1 -d'|'|grep GT|sort|uniq -c > hum_cazy_GT.freq
cat hum_cazy.fa |grep -A1 '>GT'|grep -v '^--$' > hum_cazy_GT.fa
less hum_cazy_GT.fa|perl -lne 'if ($_=~/^>/){@a=split(/ /,$_);$id=shift @a;$lines=join " ",@a;print "$id|H.sapiens_Metazoa $lines";}else{print $_;}' > hum_cazy_GT.fa.edit
## Following 2 steps if you want to add additional annotations
blastp -query hum_cazy_GT.fa.edit -db ~/GT/glycogene/hum.fa -evalue 1e-10 -outfmt 6 -out hum_cazy_wormbase_map.blout
cat /home/rtaujale/GT/glycogene/hum_glycogene_details_combined|perl -e 'while(<>){chomp;@a=split(/\t/,$_);$a[11]=~s/Protein: //g;$hash{$a[11]}=$a[1];}open(IN,"hum_cazy_glycogene_map.blout.best");while(<IN>){chomp;@b=split(/\t/,$_);@c=split(/\./,$b[0]);@f=split(/\|/,$b[1]);$map_hash{$f[1]}=$c[0];}open(IN2,"hum_cazy_GT.fa.edit");while(<IN2>){chomp;if ($_=~/^>/){@d=split(/ /,$_);$id=shift @d;shift @d;$desc=join " ", @d;@e=split(/\|/,$id);if ($hash{$map_hash{$e[1]}}){print "$id|$hash{$map_hash{$e[1]}} $desc\n";}else{print "$id|- $desc\n";}}else{print "$_\n";}}' > hum_cazy_GT_final.fa

grep -f ~/GT/CAZy_families/cazy_gta.famlist scer_cazy_GT.fa.edit|grep -v -f ~/GT/CAZy_families/cazy_gta.famlist.remove|sed 's/^>//'|cut -f1 -d' ' > scer_cazy_GT-A.ids
get-seq-bioperl_nochange2.pl scer_cazy_GT-A.ids scer_cazy_GT.fa.edit > scer_cazy_GT-A.fa
## Other manual way for above 2 steps
grep -A1 -f ~/GT/CAZy_families/cazy_gta.famlist hum_cazy_GT_final.fa|grep -v '^--$' > hum_cazy_GT-A_final.fa
# Manually remove other families caught by GT2,6,7,8

############################################################
cat list_hits.txt.details |head -1577|perl -lne '@a=split(/\t/,$_);if ($a[0]=~/\d/){$fam=$a[1];}else{print "$fam\t$a[1]"}' > list_hits.txt.details.map

############################################################
## Long term work
## Update everything associated with CAZy 
## 1) CAZy pages
## 2) CAZy structures 
## 3) CAZy sequences
## 4) CAZy characterized sequences
## 5) CAZy families list 
## 6) CAZy ID maps 

get_cazy_seqID.sh 

## The following two scripts
get_tax_eutil.pl 
parse_gb.pl 
# Could be replavced by e-utils esearch,efetch


# Generate a CAZy_GT-A.id_map file using parse_cazy.pl script
for i in `ls`; do parse_cazy.pl $i map >> CAZY_GT-A.id_map; done

# Get all map IDs from genbank 
# Use esearch and efetch
