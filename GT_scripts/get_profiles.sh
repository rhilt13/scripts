## Start with alignments for each family with consensus at top of each alignment

##Get consensus from each file
## Run In tpl folder
for i in `ls ../new_sub/*.press`; do name=$(ls $i|cut -f3 -d'/'|cut -f1 -d'.');seq=$(head -2 $i|tail -1|sed 's/-//g');printf ">GT-A|$name|consensus\n$seq\n" >> GT-A.cons; done


#######################################################################

## Multiple align consensus file
muscle -in GT-A.cons > GT-A.cons.mus 

## Edit the alignment to remove misaligned flanking regions
## get GT-A.cons.mus.press.edit

## Press
perl ~/rhil_project/scripts/remove_newline_fasta.pl GT-A.cons.mus.press.edit > GT-A.cons.mus.press.edit.press

## Get cma
fa2cma GT-A.cons.mus.press.edit.press > GT-A.cons.mus.press.edit.press.cma

## Check best sequence in cma file to put in the top

## Get faa with consensus sequence 
cma2fa GT-A.cons.mus.press.edit.press > GT-A.cons.mus.press.edit.press.cma.faa

## Order them based on a ordered file in main folder
perl ~/rhil_project/scripts/get-seq-bioperl.pl ../order GT-A.cons.mus.press.edit.press.cma.faa > GT-A.cons.mus.press.edit.press.cma.faa.ordered

## Get cma
fa2cma GT-A.cons.mus.press.edit.press.cma.faa.ordered > GT-A.cons.mus.press.edit.press.cma.faa.ordered.cma
## Manually edit fa2cma to GT-A in first line of the file 

## Copy to main folder as tpl file
#######################################################################


#######################################################################
## Get edited alignments

## Generate a nogaps file of edited alignment
##Run in tpl folder
cat gta_all.cons.mafft.edit|perl -lne 'if($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}' > gta_all.cons.mafft.edit.nogaps


## Run in edited_profiles folder
perl ~/rhil_project/scripts/edit_all_alignments.pl ../../GT_sub_fam.txt gta_mus_long_cons.faa.nogaps

## Get cma files from edited alignments
for i in `ls *.FASTA.press.edit`; do k=$(ls $i|cut -f1 -d'.');g="GT-A|${k}"; fa2cma $i |sed "s/fa2cma/$g/;s/\[0_/[1_/;s/_0\]/_1]/" > $k.cma; done

## Concatenate cma files in order of tpl file to get _.cma file
rm gta_m.cma; for i in `less order`; do cat new_sub/$i.cma >> gta_m.cma; done



## Move gta_m.cma file to main folder as gta_mus_long.cma

## Run run_map
run_map gta_mus_long