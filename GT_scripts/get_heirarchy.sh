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

#omcbpps_analysis.sh without running rungaps from previously categorized ids from rungaps

# Inside the omcbpps output folder
mkdir sets
cp <file>_new.mma sets
cd sets
tweakcma <file>_new -write
rm <file>_new.mma
for i in `ls *Set*cma`; do j=$(cat $i|grep '^>'|cut -f1 -d' '|cut -f2 -d'>');echo $i $j; done|perl -lne '@a=split(/ /,$_);$set=shift(@a);($s)=($set=~/_(Set[0-9])\.cma/);foreach $id(@a){print "$s\t$id";}' > ../set_map_ids
cd ..
match.pl ~/GT/gta_revise13/mapping_files/GTSeq-omcmc40Sets.txt 1 set_map_ids 2 '\t' both all > set_map_ids_details

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
## Alternative to run_hieraln.sh
# Manually create a profile for omcBPPS partitions
mkdir hier 
cd hier 
cat -n ../nrrev10_sel1_new.mma|less # Find Random and head lines till before that
less ../nrrev10_sel1_new.mma |head -<num_from_above>|sed 's/\;BPPS=.*/:/g' > nrrev10_sel1_prof.cma
less nrrev10_sel1_prof.cma|grep 'BPPS='|cut -f2 -d'='|cut -f1 -d'(' > order
grep -A1 -f order ../nrrev10_sel1_usr.sma |grep -v '^--$'|grep '^>\|^{' > nrrev10_sel1_prof.cons
cat nrrev10_sel1_prof.cma|head -2 > head
tail -1 nrrev10_sel1_prof.cma > tail
cat head nrrev10_sel1_prof.cons tail > nrrev10_sel1_prof.tpl
cnt nrrev10_sel1_prof.tpl
nano nrrev10_sel1_prof.tpl # Replace num of sequences and rename Set1

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

### OTHER WAY for the nrtx0, 1, 2 files:
for i in {1..59}; do tweakcma part/nrtx_prevHits0.seq_${i} -rmcsq;tweakcma part/nrtx_prevHits1.seq_${i} -rmcsq;tweakcma part/nrtx_prevHits2.seq_${i} -rmcsq; cat part/nrtx_prevHits[0-2].seq_${i}.rmcsq.cma >> sets/nrtx_prevHits_${i}.cma; tweakcma sets/nrtx_prevHits_${i} -m;mv sets/nrtx_prevHits_${i}.merged.cma sets/nrtx_prevHits_${i}.cma; done
cat part/nrtx_prevHits2.seq.hits |grep '^='|cut -f3,4 -d' '|sed 's/: /\t/' > map_fam_info

for i in `ls sets/nrtx_prevHits_[1-9].cma`; do cat $i|sed '1,7d'|head -n -1|head -2000 >> nr_rev11_gt2_sel ; done
for i in `ls sets/nrtx_prevHits_1[0-9].cma`; do cat $i|sed '1,7d'|head -n -1|head -2000 >> nr_rev11_gt2_sel ; done
for i in `ls sets/nrtx_prevHits_2[0-4].cma`; do cat $i|sed '1,7d'|head -n -1|head -2000 >> nr_rev11_gt2_sel ; done

for i in `ls sets/nrtx_prevHits_2[5-9].cma`; do cat $i|grep -v '^\[\|^(\|^_' >> nr_rev11_nongt2; done
for i in `ls sets/nrtx_prevHits_[3-5][0-9].cma`; do cat $i|grep -v '^\[\|^(\|^_' >> nr_rev11_nongt2; done
##############################################################
# Get phyla distribution of all sets from nr
for i in `ls *.cma`; do n=$(echo $i|sed 's/\.cma//');j=$(tweakcma $n -phyla|grep 'number'|rev|cut -f1 -d ' '|rev);echo $n $j; done > ../phyla_distribution
less ../../../gta_revise8/rungaps_rev8/nr/phyla_distribution |perl -e 'open(IN,"../../../gta_revise8/rungaps_rev8/nr/fam_num_list");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}while(<>){chomp;($num)=($_=~/_([0-9]+)\s/);print "$_\t$hash{$num}\n";}'|less

for i in `ls ugdh_sel1_new_Set*.cma`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');echo $j;k=$(echo $i|sed 's/.cma$//');echo $k; tweakcma $k -phyla|grep '^='|sed 's/=//g;s/^ \+//'; done > phyla_raw

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

for i in `ls *pml`; do less $i|grep -v '^#'|grep 'load(\|cmd.color("bb_color1"\|create("Class_'|perl -e 'while(<>){chomp;if ($_=~/^cmd.load/){($id)=($_=~/\(\"\.\/([0-9a-zA-Z]+)/);print "\n$id";}elsif ($_=~/^cmd.color/){($num)=($_=~/resi ([0-9-]+) /);print "\t$num";}elsif ($_=~/^cmd.create/){($cl,$res)=($_=~/\(\"(Class_[A-Z])\",\"(.*)\"\)/);$res=~s/ or / /g;print "\t$cl,$res";}}'; done|sort -u -k1,1 --merge> pdb_list.mapped.details

# Count for pdbs with pml files
ls *pml|sed 's/_[A-Z].pml//g'|sort -u|wc


#############################################################
# Written as: 
# Run script after running map_pdb_afteromcBPPS.sh
# Generates a table with the following:
# pdb id(filename), gt domain start-end, class residues,...
# 
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
search_cdd.pl < gt2-gt25Met-1 > gt2-gt25Met-1.cdd
##########################################################

## change cma to fa
cma2fa cazy_pdb.p90.l100 >cazy_pdb.p90.l100.fa
cat cazy_pdb.p90.l100.fa|perl -lne 'if ($_!~/^>/){$_=~s/-//g;pri nt $_;}else{print $_;}'> a
tail -n+4 a > b
cat b new_seq.fa > c


gismo++ new_aln.fa -fast

##########################################################
## Keep only aligned positions froma  cma file in fasta format

less seq_set1.fa_aln.cma|perl -lne 'if ($_=~/^>/){print $_;}elsif ($_=~/^\{/){$_=~s/[a-z{}()*]//g;$_=uc($_);print $_;}'|less
##########################################################

# Find out which omcBPPS sets contain a pdb file

for i in `ls cazy_set1.p90.l100_new_Set*.cma`;do echo $i;cat $i|grep '^>'|grep -v '^>GT'; done|less

###################
## Add CAZy family and species annotation to rungaps output:
for i in `ls toxo_all.faa_[0-9][0-9].cma`; do j=$(cat $i|grep '^>'|head -1|cut -f2 -d'|');export j;cat $i|sed '1,7d'|head -n -2|perl -lne 'if($_=~/^>/){@a=split(/ /,$_);$a[0]=~s/>//;print ">$ENV{j}|$a[0]|T.gondii_Apicomplexa";}else{print $_;}'; done|less

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
less nr_set1_pdb.VSI|grep '^File\|Set'|grep -v 'Set1:'|cut -f2 -d'/'|cut -f1 -d'_'|uniq|tr '\n' ' '|tr ':' '\n'|awk -F "#" '{print $2,$1}'|sort -n > ../map_pdb_table
less nrrev13_sel1_pdb.VSI|grep '^File\|Set\|Group'|grep -v 'Set1:'|cut -f2 -d'/'|perl -e '$p=0;$n=0;while(<>){chomp;$_=~s/ //g;$_=~s/#//g;if ($_=~/Set/){if ($n==1){print "\t";$n=0;}$p=1;$_=~s/# //;$_=~s/://;print "$_,";}else{$_=~s/.pdb\:/-/;if ($p==1){print "\n";$p=0;$n=1;print "$_,";}else{print "$_,";$n=1;}}}'|sed 's/,\t/\t/;s/,$//' > ../map_pdb_table


#####################################################
## Get mapping files for families mapped to omcBPPS and pdb files
## Added to omcBPPS_analysis.sh
less sets/hits_details|cut -f2 -d'|'|cut -f1 -d' '|sed 's/^Set/~/g'|tr '\n' ' '|tr '~' '\n' > map_fam_info
less sets/map_fam_info |perl -e 'while(<>){@a=split(/ /,$_);$hash{$a[0]}=$a[1];}open(IN,"map_pdb_table");while(<IN>){chomp;($num)=($_=~/Set([0-9]+)/);print "$hash{$num}\t$_\n";}' > map_pdb_table_details

#####################################################
## Find pdb files that have UDP substrates in them.
for i in `ls pdb_map/*.pml|sed 's/_[A-Z].pml$//'|sort -u`; do j=$(cat $i|grep HETATM|grep -v HOH|grep UDP);echo $i $j; done|grep UDP|cut -f1 -d' ' > yes_substrates

#####################################################
# Get set assignments after omcbpps
less all_gta_new.mma|perl -e 'while(<>){chomp;if ($_=~/^\[/){($set)=($_=~/=(Set[0-9]+)/);}elsif ($_=~/^>/){$_=~s/^>//;$_=~s/ /\t/;print "$set\t$_\n";}}' > sets
#####################################################

cat human_gt16.fa|tail -1|sed 's/\(.\)/\1\n/g' > temp1
cat temp1|perl -e '$line=1;$ct=120;while(<>){print "$line\t$ct\t$_";if ($_!~/-/){$ct++;}$line++;}' > human_gt16.pos_map


#####################################################
## Get IDs froma  newick tree
cat gt8_prune1500.nwk |tr ',' '\n'|cut -f1 -d':'|sed 's/(//g'|grep '\.1\|\.2\|.3' > gt8_prune1500.nwk.ids

#####################################################
## Get weblogo from cma files
## Written as bash script in weblogo.sh
weblogo -f LRRIII_IRAK_TKL.short.fa -D fasta -o lrriii_3 -A protein -s large -X NO --scale-width NO --errorbars NO -C black AVLIPWMF 'nonpolar' -C blue HRK 'basic' -C purple NQ 'amides' -C green GYSTC 'polar' -C red DE 'acidic' -y ' ' -P' ' -l 27 -u 30

#####################################################
## Run cross_rungaps for nr hits
mkdir sets/cross_rungaps
for i in `ls part/nrtx.part-*[0-9].seq`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|cut -f1 -d'.');cat $i >> sets/cross_rungaps/nr_gtrev9_$j.seq; done
cd sets/cross_rungaps
for i in `ls`; do run_gaps ~/GT/gta_revise9/profile/gt_rev9 $i -O &>>$i.hits; done

## Parse cross_rungaps output to find which sets hit which original profiles
for i in `ls *.hits`; do cat $i|grep '^run_gaps \|^=='|perl -lne 'if ($_=~/^run_gaps/){($id)=($_=~/_([0-9]+).seq/);print $id;}else{print $_;}' >> hits_details; done
cat hits_details |perl -e 'open(IN,"../fam_num_list");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}while(<>){chomp;if ($_=~/^[0-9]/){print "$_\t$hash{$_}\n"}else{print "$_\n";}}' > hits_details_all

#####################################################
## Create one pml file for all structures, patterns, inserts
get-inserts.pl ~/GT/gta_revise9/rungaps_rev9/pdb/pdb_seqres.faa_aln.cma ~/GT/gta_revise9/mcBPPS/allgta_tree/try5/pdb_map/pdb_list.mapped.details > pdb_inserts.txt
get_pml.py.py -i pdb_collect -l ~/GT/gta_revise9/mcBPPS/allgta_tree/try5/pdb_map/pdb_list.mapped.details -n pdb_inserts.txt -p ~/GT/pdb/str_GT/PDB/orig -c sel_pdb.cma -d pdb_domains.txt -o a.pml

#####################################################
## From a collection of cma files, perform hmm-hmm comparison and build cluster tree using pHMM-Tree
## Replace file.cma with a cma file with multiple cma files - like output _new.mma from omcBPPS
# Written as script run_pHMM-Tree.sh

cp /..../file.cma .
tweakcma file -write 
mkdir cma 
mkdir fasta
mv *cma cma
cd cma
mv file.cma ../

## If cma file comes from omcBPPS; 
sed -i 's/;BPPS=.*:$/:/' *cma
for i in `ls *cma`; do j=$(echo $i|sed 's/.cma//');cma2fa $j > $j.fasta; done
for i in `ls *fasta`; do j=$(echo $i|rev|cut -f1 -d'_'|rev|sed 's/.fasta//');k=$(echo $i|sed 's/.fasta//');cat $i|sed "s|consensus seq|$j|" >${k}_1.fasta ; done
mv *_1.fasta ../fasta 
rm *fasta 

## Else if cma file already has consensus sequence then run this
for i in `ls *cma`; do j=$(echo $i|sed 's/.cma//');cma2fa $j|sed '1,3d' > $j.fasta; done
mv *fasta ../fasta/

cd ../
pHMM-Tree -prc -als fasta/
cd prc_als_mode_fasta/tree_files
ls *tree > tree_list
cmp_trees.py -l tree_list -o tree_dist.txt
## Check tree_dist.txt to see which tree has the lowest avg. RF (Robinson-Foulds) distance
## Get labels from fasta filenames
cd ../../fasta
ls *fasta|perl -lne '@a=split(/_/,$_);$grp=pop(@a);$str=join('_',@a);if ($grp=~/grpA/){$col="#FF0000";}elsif ($grp=~/grpB/){$col="#00FF00";}elsif ($grp=~/grpC/){$col="#0000FF";}else{$col="#00FFFF";}print "$str\tlabel\t$col";' > ../tree.col.txt

cd ../
cat tree.col.txt|sed 's/label/branch/g'|perl -lne 'print "$_\tnormal";' > tree.bra.txt
# Add to the top
TREE_COLORS
SEPARATOR TAB
DATA
#NODE_ID,TYPE,COLOR

# Add to top of protein_domains text file for iTOL
DATASET_DOMAINS
SEPARATOR COMMA
DATASET_LABEL,boundaries1
COLOR,#ff0000
DATASET_SCALE,50,100,150,200
DATA

## Load tree and labels in itol

######################################################
# Parse pHMM matrix to get apirwise distance to a specific profile
less shorted_names.txt |sed 's/==/\t/' > shorted_names.txt.e1
less file_dist_matrix_out_phylip.txt|sed 's/ \+/\t/g' > file_dist_matrix_out_phylip.txt.e1
match.pl shorted_names.txt.e1 2 file_dist_matrix_out_phylip.txt.e1 1 '\t' both|awk -F'\t' '{print $95"\t"$0;}'|cut -f1,3-94 > file_dist_matrix_out_phylip.txt.e2
######################################################
# Map each IDS to rungaps hit profile
for i in `ls rungaps/pdb/pdb_seqres.txt_{1..100}.cma`; do cat $i|grep '^>'|cut -f1 -d' '|cut -f2 -d'>'; done|perl -lne 'if ($_=~/^GT/){$fam=$_;}else{print "$fam\t$_";}' > rungaps/pdb/pdb_seqres.txt.hits.map
#####################################################
# MD simulation

# To generate more refined pdb strucures with sec. st
r.
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

## Get pseudoGTs
unmatchcma CAZy_allGT_genbank.faa.IDedit_aln.cma DEQN86,DENQH88

############################################################
## mcBPPS workflow starting from a tree and cma file

## Old method To run tree2hpt #######################################
## Export tree from itol to get bootstraps into square brackets		#
# less altree.txt |sed 's/\[[0-9]\+\]//g;s/[-.]//g' > altree.e1.txt #
# add_prefixnum.py altree.e1.txt altree.e2.txt 						#
# tree2hpt altree.e2.txt > nrrev9_sel1.hpt 							#
# remove the space between the number and sequence id in hpt file using vi (Ctrl+V, select column and del)
#####################################################################

### New replace above steps After exporting tree from itol
# Remove bootstraps
less tree1.txt |sed 's/\[[0-9.]\+\]//g' > tree1.e1.txt
# remove special characters from ids and add internal nodes
add_prefixnum.py tree1.e1.txt tree1.e2.txt

# View tree to find root, get name for root internal node (if needed)
prune_tree.py tree1.e2.txt|less
# If I9 is the internal node name, run following to do rooting
prune_tree.py tree1.e2.txt I9|less

# get node labels within each node after root is determined
get_nodes.py tree1.e2.txt I9 > tree1.e2.txt.nodes

# Visualize the tree and copy paste internal node names you want to make tips into file tree1.e2.txt.collapse_list
nano tree1.e2.txt.collapse_list
# Copy paste solitary leaves that do not belong inside selected internal nodes you want to remove
nano tree1.e2.txt.remove_leaves
# Remove leaves that are singly isolated
prune_tree.py tree1.e2.txt I9 tree1.e2.txt.remove_leaves|less
# Run following command iteratively to apply pruning to selected nodes
prune_tree.py tree1.e2.txt I9 tree1.e2.txt.remove_leaves tree1.e2.txt.collapse_list|less
# Once all nodes are selected and appropriate rooting achieved, get pruned tree
prune_tree.py tree1.e2.txt I9 tree1.e2.txt.remove_leaves tree1.e2.txt.collapse_list tree1.e2.txt.col tree1.e2.txt.col.nodes|less
# Add prefix numbers to all nodes (required for tree2hpt)
add_prefixnum.py tree1.e2.txt.col tree1.e2.txt.col2 addnum
# Add family names to tips manually (edit2tab separate)
cp tree1.e2.txt.collapse_list tree1.e2.txt.collapse_list.details
nano tree1.e2.txt.collapse_list.details
prune_tree.py tree1.e2.txt I9 # To help identify nodes
# Edit tip names in tree
edit_nwk_ID.pl tree1.e2.txt.collapse_list.details tree1.e2.txt.col2 > tree1.e2.txt.col3
# Run tree2hpt
tree2hpt tree1.e2.txt.col3 > tree1.e2.txt.col3.hpt

# Make sure I0 or ROOT are named the same in hpt file and .nodes and .col.nodes file

## Method1: Generating the cma files from a cma file with all sequences
# Get .selID files for each level and node in tree tree1.e2.txt.col
# 2 ways to get the .selID files

## 1) Automated- get leaf sequences from the original tree file
# Creates folder sub_cma and writes files for each node inside it
# This step may be included inside build_sma.sh
# Following script replaces get-cma-seq.pl
list_leafIDs.fix.pl tree1.e2.txt.collapse_list.details tree1.e2.txt.nodes tree1.e2.txt.col.nodes

## 2) Get leaf IDs manually and internal sequences from tree and hpt
mkdir sub_cma
##Copy manually created *_tip.selID files to this folder
less tree1.e2.txt.col3.hpt|cut -f3 -d' '|sed '1,2d;$ d'|grep '^I'|sed 's/?//g' > tree1.e2.txt.col3.int_nodes

cd sub_cma
# Options to run are inside the script
# The options will change depending on filenames and run
build_sma.sh ../gt31_tc_sel2.id2.cma nrtx.part-01

## Method2: Manually generate cma files for the tips and generate cma for leaves.
## Put all cma files with <tip_name>.cma inside folder sub_cma_manual
mkdir sub_cma
cat tree1.e2.txt.col.nodes|perl -lne 'if ($_=~/^I/){@a=split(/\t/,$_);open(OUT,">sub_cma/$a[0]_int.selID");@b=split(/ /,$a[1]);foreach $n(@b){print OUT $n;}close OUT;}'
for i in `ls sub_cma_manual/*cma`; do head -6 $i|tail -3; done > sub_cma/allcons
less sub_cma_manual/*cma|head -2 > sub_cma/head
less sub_cma_manual/*cma|tail -1 > sub_cma/tail
cd sub_cma
cat head allcons tail >allcons.cma
#check the file header to be replaced ([0_(1)=......()])
cat head 
build_sma_lite.sh ......
## Use one of the following or variant based on how cma files need to be changed
for i in `ls ../sub_cma_manual/*cma`; do j=$(echo $i|rev|cut -f1 -d'/'|rev|sed 's/.cma//');cat $i $j.cons.edit.cma; done
for i in `ls ../sub_cma_manual/*cma`;do j=$(echo $i|rev|cut -f1 -d'/'|rev|sed 's/.cma//');cat $i|perl -lne 'if ($_=~/^\[/){$_=~s/-.*\(/(/g;print $_;}else{print $_;}' > $j.cons.edit.cma; done
# Get sma file in the order of hpt file
for i in `cat ../tree1.e2.txt.col3.hpt|cut -f3 -d' '|sed '1,2d;$ d;s/.$//'`; do cat $i.cons.edit.cma ; done >allcons.sma
cp allcons.sma ../../gt31_tc.sma 

# Replaced by command above...concatenate .cons.edit.cma files in the order of hpt file
#for i in `cat ../tree1.e2.txt.col3.hpt|cut -f3 -d' '|sed '1,2d;$ d;s/.$//'`; do cat ${i}_*.cons.edit.cma >> allcons.sma; done
#Get map for matching family level IDs with the ids on hpt file
#for i in `cat ../tree1.e2.txt.col3.hpt|cut -f3 -d' '|sed '1,2d;$ d;s/.$//'`; do j=$(echo ${i}_*.cons.edit.cma|sed 's/.cons.edit.cma//');echo $i $j; done > ../tree1.e2.txt.col3.hpt.name_map

# Go to the aln folder outside sub_cma
cd ..
# Get edited hpt file
cat tree1.e2.txt.col3.hpt|rev|sed 's/ //'|rev > ../gt31_tc.hpt

### Extra commands
#cat tree1.e2.txt.col3.hpt|perl -e 'open(IN,"tree1.e2.txt.col3.hpt.name_map");while(<IN>){chomp;@a=split(/ /,$_);$hash{$a[0]}=$a[1];}while(<>){chomp;@b=split(/ /,$_);($sym)=($b[2]=~/(.)$/);$b[2]=~s/.$//;if (exists $hash{$b[2]}){print "$b[0] $b[1]","$hash{$b[2]}","$sym\n";}else{print "$b[0] $b[1]","$b[2]","$sym\n";}}' > ../gt31_tc.hpt


## Edit cma file to match the ids in tree
cat sel3.id2.cma |perl -lne 'if ($_=~/^>/){$_=~s/[.-]//g;print $_;}else{print $_;}' > sel3.id2.e1.cma


edit_nwk_ID.pl tree1.edit2.txt.label tree1.edit2.txt > tree1.edit3.txt
## Get sma file using hpt and edited cma file
build_sma.sh 

############################################################
## Parse PISA information
## Copy pasate xml files from PISA output to a file interface.*.xml
cat interface.a_d.xml |perl -e 'while(<>){@m=($_=~/>(.*?)</g);foreach $var(@m){if ($var=~/^\s+[A-D]/){print "\n";}if ($var!~/^$/){$var=~s/\s//g;print "$var\t";}}}'|sed '1d' > interface.a_d.tab

############################################################
## Compare 2 cma files with same seq ids to see which one has better hits
parse_cma.pl file_1.cma list|cut -f2 -d'|' > old
parse_cma.pl file_2.cma list|cut -f2 -d'|' > new

cat new|perl -e 'open(IN,"old");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}while(<>){chomp;@b=split(/\t/,$_);print "$b[0]\t$hash{$b[0]}\t$b[1]\n";}' > list_diff
## Change $2 and $3 in awk based on which one you want to select for
cat list_diff|awk '{if ($2>$3){print $0,"\t",$2-$3}}'|sort -k4,4nr|less

############################################################
## Parse PSI-BLAST output
# Run PSI-BLAST and copy paste following results:
# file.txt = selected sequences for making PSSM

# Once no new sequences are found or false hits are found,
# file.txt
# file.fa (Multiple sequence alginment > Download > fasta with gaps)
# file.tax (Taxonomy Reports > Select tax tree Copy paste)
# file.hits (Taxonomy Reports > Selct list of hits Copy paste)

less cosmc_PSI2.hits|grep -v 'Next Previous'|grep -v '\]$'|grep -v RecName|cut -f4 > cosmc_hits.ids

############################################################
## Get taxonomic lineage from a list of sequence IDs genbank

# Create a list of sequence ids => ids
~/tools/2018-ncbi-lineages/make-acc-taxid-mapping.py ids /auto/share/db/ncbi_taxdump/prot.accession2taxid.gz
~/tools/2018-ncbi-lineages/make-lineage-csv.py /auto/share/db/ncbi_taxdump/nodes.dmp /auto/share/db/ncbi_taxdump/names.dmp ids.taxid -o <id>-lineage.csv

############################################################
## Add taxonomy to uniprot sequences
less uniprot_rev13.merged.cma|perl -e 'open(IN,"/auto/share/db/Uniprot_Ref_Proteomes_180925/proteomes_taxonomy.tab");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[2]}=$a[4];}while(<>){chomp;if ($_=~/^>/){($tid)=($_=~/OX=([0-9]+) /); print "$tid\t$hash{$tid}\n";}}'

############################################################
## Caluclate conservation scores for aligned postions and parse output

# Get conservation scores from alignment
score_conservation.py -a Human_COSMC -o cosmc_mc_psi.p99.fa_js_win3 -m ~/tools/conservation_code/matrix/blosum62.bla cosmc_mc_psi.p99.fa
# Get aligned position counts in the alignment
perl ~/git/scripts/get-pos-num.pl cosmc_mc_psi.p99.fa > cosmc_mc_psi.p99.fa.pos_map
# Get interface residues ( or other regions of the protein if required)

############################################################
## Run starc
# mkdir starc/<fam_name>
# cp <cma file with aligned seq for the family>
# Add or move the sequence with pdb structure to the first seq in the cma file
# cp <pdb file> .

# run_starc.sh <cma_file>gt6.cma <pdb_file>1lzj.pdb <chain>A <start_pos>116

############################################################
##Change names for the newly identified GT-A families
sed -i 's/GT16-u|/GT16-A|/g;s/GT31-u|/GT31-A|/g;s/GT60-u|/GT60-A|/g;s/GT32-u|/GT32-A|/g' CAZy_allGT_genbank.faa.IDedit

############################################################
## ITOL dataset types

TREE_COLORS
SEPARATOR TAB
DATA
#NODE_ID,TYPE,COLOR

DATASET_COLORSTRIP
SEPARATOR TAB
DATASET_LABEL	label1
COLOR	#ff0000
COLOR_BRANCHES	0
DATA

############################################################
# EMBOSS
skipredundant # To remove redundant sequences to % identitiy fasta
############################################################
## Compare trees using Sankey diagram
# https://sankey.csaladen.es/

# Manually make form_main with list of => nodes\tvalues
# Separate layers using "---"
cat form_main|perl -e '$j=-1;$i=1;while(<>){chomp;if ($_=~/^-/){$i++;}else{$j++;@a=split(/\t/,$_);print "$j \{\"name\":\"$a[0]\",\"value\":$a[1],\"layer\":$i\}\n";}}' > form_main.list
cat form_main.list |cut -f2 -d' '|tr '\n' ','|perl -lne 'print "{\"nodes\":[$_]}";' > form_main.list.submit
# Manually make form_connect with links between nodes using node number labels in form_main.list => source node no. \t target node no. \t value
less form_connect |perl -lne '@a=split(/\t/,$_);print "\{\"source\":$a[0],\"target\":$a[1],\"value\":$a[2]\}";' > form_connect.list
less form_connect.list |tr '\n' ','|perl -lne 'print ",\"links\":[$_]}";' > form_connect.list.submit

# Manually combine main and connect.
cat form_main.list.submit form_connect.list.submit > form_final.submit
nano form_final.submit

# Remove last comma and curly bracket at end on form_main.list.submit
# Remove last comma on form_connect.list.submit
# Save as form_final.submit

############################################################
## Get counts of nr rungaps output for each of the profile sets after filtering steps:
# 25..72 for non-gt2s; 1..24 for gt2s
for i in {25..72}; do echo $i; cnt nr_gtrev12_$i.cma; cnt nr_gtrev12_$i.l140.cma; cnt nr_gtrev12_$i.l140_is90.cma; cnt nr_gtrev12_$i.l140_is90_is92.cma; cnt nr_gtrev12_$i.l140_is90_is92.purge90.cma; done > a
less a|sed 's/^/~/g;s/^~\s\+/~~/g;s/~~//'|cut -f1 -d' '|tr '\n' '\t'|tr '~' '\n'|sed '1d' > non_gt2_cts.txt
match.pl non_gt2_cts.txt 1 ../map_fam_info 1 both|cut -f1,2,4- > a
mv a non_gt2_cts.txt
# Repeat above for gt2s
# Columns..
#	1 - profile set num
#	2 - profile name
#	3 - count total hits
#	4 - count after l140 filter
#	5 - count after is90 DXD filter
#	6 - count after is92 DXD filter
#	7 - count after 90% purge filter
#	8 - ** Additional manually added column if final selection needs to be manipulated

############################################################
# Edit cma file names and concatenate all rungaps hits into a single cma file
for i in `ls ../../../rungaps/nr/sets/run2_l140Aligned/sets_raw/nr_gtrev12_*.l140_is90_is92.cma`; do j=$(echo $i|rev|cut -f1 -d'/'|rev);k=$(echo $j|cut -f1 -d'.'|cut -f3 -d'_');echo $j $k;export k; cat $i|perl -e 'open(IN,"../../../rungaps/nr/map_fam_info");while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[0]}=$a[1];}while(<>){if ($_=~/^\[/){$_=~s/nrtx.part-01/$hash{$ENV{k}}/;print "$_";}else{print "$_";}}';  done > gtarev12_rungaps_nr_filtered.cma

############################################################
# Edit uniprot and nr tables to generate tables and files for the GTA db

match.pl ~/GT/gta_revise13/mapping_files/omcSets_name.txt 1 uniprot/uniprot_table10.fixedCeSputa2 4 '\t' both|awk -F'\t' '{print $1"\t"$2"\t"$3"\t"$4"\t"$17"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"$15}' > uniprot/uniprot_table11.OmcNames
cat uniprot/uniprot_table11.OmcNames|cut -f2,3,5,6,8- > uniprot/uniprot_table12.final

############################################################


#### 
# Pymol
hide everything; set seq_view, 1, GT27_2d7i*; show cartoon, GT27_2d7i;

show cartoon, GT6_*Mt; show cartoon, GT6_*Nt; show cartoon, GT6_*Ct; set seq_view, 1, GT6_*;

############################################################
# Color for pknB pseudokinases
cat pknB_allpseudo_p40active.merged.fa|grep '^>'|cut -f1 -d' '|cut -f2 -d'>'|perl -lne 'if ($_=~/^active/){print "$_\t#838383";}elsif ($_=~/Act1/){print "$_\t#800000";}elsif ($_=~/Act2/){print "$_\t#bfef45";}elsif ($_=~/Act3/){print "$_\t#f58231";}elsif ($_=~/ActLanC/){print "$_\t#fffac8";}elsif ($_=~/ActMvin/){print "$_\t#e6194B";}elsif ($_=~/B3A/){print "$_\t#fabebe";}elsif ($_=~/Cyan-PsK/){print "$_\t#aaffc3";}elsif ($_=~/DYD/){print "$_\t#ffd8b1";}elsif ($_=~/HGA/){print "$_\t#ffe119";}elsif ($_=~/NERD-PsK/){print "$_\t#911eb4";}elsif ($_=~/PASTA-PsK/){print "$_\t#808000";}elsif ($_=~/ProTCS-PsK/){print "$_\t#4363d8";}elsif ($_=~/\|TCS-PsK/){print "$_\t#f032e6";}'|less

############################################################
# Collect subset of query sequences 
# Colect a pool of sequences to pick from (eg: Match_GT12.merged.cma)
# $1 = list of families
for i in `cat ../$1`; do cat Match_$i.merged.cma; done > $1.cma
tweakcma $1 -m
parse_cma.pl $1.merged.cma sel selIds.e1 > ${1}Sel.cma
tweakcma ${1}Sel -U90
tweakcma ${1}Sel.purge90 -csq
# Copy the consensus sequence 
nano ${1}Sel.purge90.cma
# Paste the consensus sequence, change name, seq num, profile name

############################################################
# Collect co-conserved patterns from pttrns file with annotations in first 4 columns
# Eg input: /home/rtaujale/GT/gta_revise12/analysis/omcPatternOccurence/nr_rev12sel3.pttrns.padded.fam.mechanism

less $1|awk -v pattern="[A-Z]$2" '{if ($5 ~ pattern){print $0;}}'|cut -f5|tr ',' '\n'|sed 's/[A-Z]//g'|sort|uniq -c|sort -nr|less

### Other scripts to look for co-conserved residue networks
# Get all partitions with a pair of pattern position
less nr_rev12sel3.pttrns.padded.fam.mechanism|awk '{if ($5~/[A-Z]116/){print $0;}}'|awk '{if ($5~/[A-Z]93/){print $0;}}'|less
# Get all partitions with a pattern position 
less nr_rev12sel3.pttrns.padded.fam.mechanism.e1|awk '{if ($6~/[A-Z]153/){print $0;}}'|less
# Get a list of pairwise interactions either using a query position(181) or get a list ("list")
omc_co-conserved_pattern.pl nr_rev12sel3.pttrns.padded.fam.mechanism 181 1|less
# Get closest nodes/ Build networks for query
build_network.py -f pairwise_patterns.min50mc30.e1-1.tsv -q Pos71|less

############################################################
# Build network of all pattern positions from omcBPPS
# Build list of patterns for each omcBPPS set
# Map omcBPPS sets to families (from rungaps)
# Get frequecies of pattern occurences for larger families (Retaining Vs Inverting)
# Get counts for co-occuring pairs

############################################################
# Map pdb positions to alignment positions
# Run in GT/pdb/ver--/pos_map folder

# Get a list of start position numbering for all pdb files
for i in `ls ../PDB/orig/*pdb`; do get_pos_pdb.py $i; done > pdb_start.txt
# The above list matches pdbs but does not match the sequence starts.
# So, use starts from teh omcbpps pdb mapping instead


# Get a cma file of rungaps hits from pdb_seqres database and convert all IDs to uppercase
less ~/GT/gta_revise12/rungaps/pdb/try3_sense0.68/pdb_seqres.txt_aln.cma |perl -lne 'if ($_=~/^>/){$_=uc($_);print $_;}else{print $_;}' > pdb_seqres.txt_aln.cma
# Convert to a fasta alignment
############################################################
# GT-A insert analysis
# Get average insert size for each sequence
for i in `ls *.cma`; do j=$(echo $i|cut -f1 -d'.');export j;cat $i|perl -lne 'if ($_=~/^>/){$id=$_;}elsif($_=~/^{/){$result = 0;$result++ while ($_ =~ m/\p{Lowercase}/g);@a=($_ =~ /([a-z]+)/g);$tot=0;$ct=0;foreach $b(@a){if (length($b)>3){$tot+=length($b);$ct++;}}$avg=$tot/$ct;$del=0;$del++ while($_ =~ m/-/g);$sum=$result+$del;print "$tot\t$ct\t$avg\t$result\t$del\t$sum\t$id";}'; done > ../AllFamIndels/AllFam_indel_avgLength.tsv


############################################################
# Get first position of a pdb file
#!/usr/bin/env python2.7

import sys
from Bio.PDB import PDBParser
from Bio.PDB.Polypeptide import PPBuilder 

parser = PDBParser(PERMISSIVE=1)
Strname=sys.argv[1]
structure = parser.get_structure('Str1', Strname)
model = structure[0]
pdb_id=Strname.split('/')[-1].replace(".pdb","").upper()
# pdb_id=pdb_id.replace()
# print pdb_id
for chain in model:
	for res1 in chain:
		print pdb_id+"_"+chain.get_id()+"\t"+res1.get_resname()+"\t"+str(res1.get_id()[1])
		# print "%s_%s\t%s\t%s",pdb_id,chain.get_id(),res1.get_resname(),res1.get_id()[1]
		break


############################################################
# Modify .pml files to get selecetions and objects for all pdbs
get_pml.py -i pdb_collect -l ../pdb_map/pdb_list.mapped.details -n pdb_inserts.txt -p ~/GT/pdb/ver_0918_gta/PDB/orig -c sel_pdb.cma -d pdb_domains.out3.txt -o out4.pml
less out4.pml |grep 'Both\|Inv\|Ret' > out4.pml.pttrnMap
#Copy paste into pymol to create selections
grep -f sel_pdb2 out4.pml.pttrnMap|grep -v 'Pt2'|less
# Copy paste to create objects of above selections
grep -f sel_pdb2 out3.pml.pttrnsMap|grep -v 'Pt2'|cut -f2 -d'"'|perl -lne 'print "create $_","Obj, $_";'|less
#Copy paste to pymol to create selections within the new objects
grep -f sel_pdb2 out3.pml.pttrnsMap|grep Pt2|perl -lne '($mech)=($_=~/(_[RIB][a-z]+Pt)[12]"/);$rep=$mech."1";$_=~s/ and/$rep/ee;$_=~s/resi/and resi/;print "$_";'|less
#"

# Copy paste in pymol to get base view for each pdb
grep -f sel_pdb2 out3.pml.pttrnsMap|cut -f2 -d'"'|cut -f1,2 -d'_'|sort -u|perl -lne 'print "hide everything;set seq_view, 0, *;set seq_view, 1, ",$_,"*;show cartoon, $_;show sticks, ",$_,"_DXD;show sticks, ",$_,"_XED;show sticks, ",$_,"_XH;show ribbon, ",$_,"_Gloop;";'|less

############################################################
# Workflow to map aligned cma positions to pdb residue numbering
# Download cif format pdb files
for i in `cat ../pdbList`; do wget https://files.rcsb.org/download/$i.cif; done
# Get start and end of all pdb sequence chains:
for i in `ls *cif`; do get_pdb_bounds.pl $i; done > allGT_pdbBounds.txt
# Map positions using the cma of pdbs and the pdb Bounds file
list-aligned-pos-pdb.pl full ~/GT/pdb/ver_0918_gta/allGT_pdbBounds.txt ~/GT/gta_revise12/rungaps/pdb/try3_sense0.68/pdb_seqres.txt_aln.cma > GTpdbPos-AlnPos.txt

############################################################
# Draw weblogo for all 231 positions for all GT-A families
for i in `ls *short.fa`; do weblogo -D fasta -A protein -s large -X NO --scale-width NO --errorbars NO -C black AVLIPWMF 'nonpolar' -C blue HRK 'basic' -C purple NQ 'amides' -C green GYSTC 'polar' -C red DE 'acidic' -y ' ' -P' ' -f $i --logo-font Arial-BoldMT -o $i.eps -l 1 -u 231 -n 240; done
############################################################
## Match ortholog list forma database to KinOrtho workflow
# Get Ortholog count for a databse
cat OF2_BLAST_MSA_HumanPKD.list_all|cut -f1|sort|uniq -c|sed 's/^ \+//g;s/ /\t/' > OF2_BLAST_MSA_HumanPKD.list_all.count
# compare oveall ortholog counts for each kinase
match.pl OF2_BLAST_MSA_HumanPKD.list_all.count 2 ../HumanPKD_Ortholog.counts.e2.all_fullLength_kinDom 1 '\t' both all|sed 's/==NO MATCH/-\t-/g'|cut -f1-5 > OF2_CompareCounts
# Compare ortholog matches with all KinOrtho orthologs (kinase domain + full length)

#################
## In script: /home/rtaujale/kannan_projects/kinview_Orthologs/databases/EggNOG_5.0_Fine-grained-.239.rels.raw EG

# Get all Human PKDs from the database
match.pl ../HumanPKD.ids 1 $1 1 '\t' > ${2}_HumanPKD.list1   
match.pl ../HumanPKD.ids 1 $1 2 '\t'|awk -F'\t' '{print $2"\t"$1}' > ${2}_HumanPKD.list2

# Make list of all pairs
cat OF2_BLAST_MSA_HumanPKD.list_all ../HumanPKD_RBH_QfO_2011.txt.e1.all.noself_nodups|sort -u > OF2_KinOrtho.allPairs

# Match all pairs list with KinOrtho orthologs
match.pl ../HumanPKD_RBH_QfO_2011.txt.e1.all.noself_nodups 1,2 OF2_KinOrtho.allPairs 1,2 '\t' b all|perl -lne 'if ($_=~/NO MATCH/){$_=~s/==NO MATCH/No/g;print $_;}else{print "$_\tYes";}' > OF2_KinOrtho.allPairs.e1.KinOrthoAll
# Match all pairs list with KinOrtho full length orthologs
match.pl ../HumanPKD_RBH_QfO_2011.txt.e2.fullLength.noself_nodups 1,2 OF2_KinOrtho.allPairs.e1.KinOrthoAll 1,2 '\t' b all|perl -lne 'if ($_=~/NO MATCH/){$_=~s/==NO MATCH/No/g;print $_;}else{print "$_\tYes";}' > OF2_KinOrtho.allPairs.e2.KinOrthoFullLength
# Match all pairs list with KinOrtho kinase domain orthologs
match.pl ../HumanPKD_RBH_QfO_2011.txt.e2.kinDom.noself_nodups 1,2 OF2_KinOrtho.allPairs.e2.KinOrthoFullLength 1,2 '\t' b all|perl -lne 'if ($_=~/NO MATCH/){$_=~s/==NO MATCH/No/g;print $_;}else{print "$_\tYes";}' > OF2_KinOrtho.allPairs.e3.KinOrthoKinDom
# Match all pairs list with OrthoFinder orthologs
match.pl OF2_BLAST_MSA_HumanPKD.list_all 1,2 OF2_KinOrtho.allPairs.e3.KinOrthoKinDom 1,2 '\t' b all|perl -lne 'if ($_=~/NO MATCH/){$_=~s/==NO MATCH/No/g;print $_;}else{print "$_\tYes";}' > OF2_KinOrtho.allPairs.e4.OF2_BLAST_MSA

# Add species name
cat OF2_KinOrtho.allPairs.e4|perl -e 'open(IN,"../../databases/QfO_2011/id_species.map.e1"); while(<IN>){chomp;@a=split(/\t/,$_);$hash{$a[2]}=$a[1];}while(<>){chomp;@b=split(/\t/,$_);if (exists $hash{$b[1]}){print "$_\t$hash{$b[1]}\n";}}'|sort -k1,1 -k7,7 > OF2_KinOrtho.allPairs.e5.speciesName
# Flatten the file for every speciesi match
../flatten_species.pl OF2_KinOrtho.allPairs.e5.speciesName > OF2_KinOrtho.allPairs.e6.speciesFlattened

#Get counts ofr diffferent matches
less OF2_KinOrtho.allPairs.e4.OF2_BLAST_MSA|cut -f1,3-|sort|uniq -c|less
less OF2_KinOrtho.allPairs.e4.OF2_BLAST_MSA|cut -f1,3,6|sort|uniq -c|less

##########
# Buld a hmm from a single protein query sequence
hhblits -i t3 -o t3.hhr -oa3m t3.a3m -n 1 -d ~/tools/hh-suite/databases/pfam
hmmbuild t3.hmm t3.a3m
hmmsearch -domtblout t3.domout t3.hmm epk.fasta > t3.hmmsaerch
cat individual_runs/*domout|grep -v '^#'|sed 's/ \+/~/g23;s/ \+/\t/g;s/~/ /g' > allHmmHits

##########
match.pl monkey 1 '\t' human 1 '\t' both all|sed 's/==NO MATCH/--/' > a; match.pl mouse 1 '\t' a 1 '\t' both all|sed 's/==NO MATCH/--/' > b; match.pl rat 1 '\t' b 1 '\t' both all|sed 's/==NO MATCH/--/'  > c; match.pl bovine 1 '\t' c 1 '\t' both all|sed 's/==NO MATCH/--/'  > d; match.pl pig 1 '\t' d 1 '\t' both all|sed 's/==NO MATCH/--/'  > e

#########
## Get 3-state secondary structure assignment from dssp
dssp 2d0j.pdb > 2d0i.dssp
# cat -n the file to remove all lines till the header of table
less ChainA_Chain_A_Glycans.dssp|sed '1,28d'|sed 's/^ \+//;s/ \+/,/;s/ \+/,/;s/ \+/,/;'|cut -f1-3 -d' '|sed 's/ \+/,/;s/,$/,-/' > ChainA_Chain_A_Glycans.dssp.e1
less ChainA_Chain_A_Glycans.dssp.e1|cut -f4,5 -d','|perl -e 'while(<>){chomp;@a=split(/,/,$_);$seq.=$a[0];if ($a[1]=~/[GHI]/){$ss.="H";}elsif ($a[1]=~/[BE]/){$ss.="S";}else{$ss.="L";}}print "$seq\n$ss\n";'|less
############################################################
## Working in update_cazy_wrapper.sh
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
