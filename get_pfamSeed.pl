#!/usr/bin/perl

open(IN,$ARGV[0]);
$output=$ARGV[1];
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/\./,$a[1]);
	$fam=$a[0]."_".$a[1]."_Seed.fasta";

	system("wget 'https://pfam.xfam.org/family/$b[0]/alignment/seed/format?format=fasta&alnType=seed&order=t&case=l&gaps=dashes&download=1' -O $output/$fam")
}
