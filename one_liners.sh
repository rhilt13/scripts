## Get consensus sequences for multiple set files at once

for i in {1..7}; do tweakcma Fbox_cons_new_Set$i -CSQ > Fbox_cons_new_Set$i.cons.cma; done


## Select sequences with specified domain
## Change regex for desired domain  (here, P[A-Z]E for PXE domain)

less Fbox_cons.mma |tr "\n" "%"|perl -lne '@a=split(/\*/,$_);foreach $b(@a){if ($b=~/P[A-Z]E/){print "$b";}}'|cat -n|sed 's/[[:space:]]+/\t/g'|perl -lne '@a=split(/\t/,$_);@b=split(/=/,$a[1]);$a[0]=~s/^\s+//;print "\$",$a[0],"=",$b[1];'|tr "%" "\n"|perl -lne 'if ($_=~/^{/){print "$_*";}else{print $_;}'|less


## Select specific sets from mma file
## change regex for name of set

cat Fbox_ncbi.faa_aln_new.mma|perl -lne 'if($_=~/^\[0_/){print "~$_"}else{print $_;}'|tr "\n" "%"|perl -lne '@a=split(/~/,$_);foreach $line(@a){if ($line=~/Set2\(/){print $line;}}'|tr "%" "\n"|less


## List all the relevant residues selected for partition
## Input file is *_aln_ptn.lpr
## adjust numbering of residues based on pdb (here, $n+20, for an increase in 20 positions)

cat ----------|perl -e 'while(<>){$_=~s/Set[0-9]+://g;@a=split(/;/,$_);foreach $b(@a){$b=~s/^\s+|\s+$//g; ($res)=($b=~/(.*?)\(/);($n)=($res=~/([0-9]+)/); ($r)=($res=~/([A-Z]+)/); $n=$n+20; print "$r$n,";}}'|less


## count number of sequences from species

cat all_protist.faa |grep '^>'|cut -f2 -d'|'|perl -lne 'if ($_=~/\]$/){($a)=($_=~/\[([^\[]*)\]$/);print $a;}elsif ($_=~/\)$/){next;}else{print $_;}'|sort|uniq -c|less

## count number of unique pdb sequences with pdb ids in fasta file

less pdb_seqres.faa_4.cma|grep '^>'|cut -f1 -d' '|cut -f1 -d'_'|sort|cut -c2-4|uniq -c|wc

## look at variations in a position in msa file

cat Fbox_only/protist/all/all_protist.faa_aln.new.msa |grep '^\s\+-'|cut -c116|sort|uniq -c|sed 's/^\s+//g'|less

## remove whitespace from fasta sequence ID

while read p; do if [[ $p =~ ^\> ]]; then q=$(echo $p|sed 's/ /-/g'|sed 's/_/-/g'); echo $q; else echo $p; fi done <Skp1_protist.faa|less



t_coffee -in ../GT-A.cons -mode expresso -blast LOCAL -pdb_db /home/esbg/rhil_project/blastdb/pdb_seqres.fa -pdb ../pdb/pdb1fgg.ent -pdb ../pdb/pdb1fr8.ent -pdb ../pdb/pdb1frw.ent -pdb ../pdb/pdb1yp4.ent -pdb ../pdb/pdb2cu2.ent -pdb ../pdb/pdb1xhb.ent -pdb ../pdb/pdb1qwj.ent -pdb ../pdb/pdb1fo8.ent -pdb ../pdb/pdb1k4v.ent -pdb ../pdb/pdb1vpa.ent -pdb ../pdb/pdb1vh3.ent -pdb ../pdb/pdb1jyl.ent -pdb ../pdb/pdb2z87.ent -evaluate_mode t_coffee_slow -template_file pdb_template -output score_html clustalw_aln fasta_aln score_ascii phylip -maxnseq 150 -maxlen 2500 -case upper -seqnos off -outorder input -run_name result -multi_core 4 -quiet stdout



less p1|grep 'Concentration'|tail -1|perl -lne '@a=split(/<strong>/,$_);shift @a;foreach $aa(@a){@b=split(/<tr>/,$aa);$line=shift @b;($met)=($line=~/(.*?)\(<a/);$met=~s/ +$//g;}'|less



#################################################
## Running chain
#################################################

# find sequences beginning with deletion
# or use perl script fix_cma.pl to fix
cat -n filename |sed 's/^ *//g'|awk 'BEGIN{FS="\t"}{if ($2~/^\{\(\)-/){print $0}}'|head



# run tweakcma to generate chn file
# seqfile is the query sequences cma file without extension
# dbfile is the database cma file which is to be compared.
tweakcma seqfile -c=dbfile.cma

# run chain PPS 

chn_pps gta_mus.nr.mma.len200.purge90 -B=B -R12345

chn_see <.chn file without extension>