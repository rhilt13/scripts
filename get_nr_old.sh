#! /bin/bash

## Need to have following scripts added to path:
## limit_descriptions.py
## fatax
## fasta-splitter.pl

mkdir nrtx
cd nrtx
wget ftp://ftp.ncbi.nih.gov/blast/db/FASTA/nr.gz
echo '--- Spawning nr ... ---'
gunzip -fv nr.gz
echo '--- Limiting descriptions --- '
limit_descriptions.py nr -o nr_desc
echo '--- nr: Running fatax ---'
TAXDUMPDIR="/auto/db/taxonomy"
cat nr_desc | fatax -u >> nrtx
echo '--- splitting nr ---'
fasta-splitter.pl --n-parts 10 nrtx
#y @files = glob ("./*part*")
echo '--- nr: Running segmasker on nrtx ---'
        #for $item in files do;
        #       segmasker -in $item -infmt 'fasta' -parse_seqids -outfmt 'maskinfo_asn1_bin' -out $item+.asnb
for f in ./*part*;do
	segmasker -in "$f" -infmt 'fasta' -parse_seqids -outfmt 'maskinfo_asn1_bin' -out "$f".asnb
done
echo '--- nr: Running makeblastdb on nrtx ---'
        #my @files = glob ("./*.asnb")
        #echo $files
#for f in ./*.asnb;do
#	echo "$f"
#done
        #-mask_data as csv string
makeblastdb -in nrtx -dbtype 'prot' -parse_seqids -mask_data nrtx.asnb -out nrtx
echo '--- nr: Finished. ---'
