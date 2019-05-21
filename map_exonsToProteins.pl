#! /usr/bin/env perl

use POSIX;

#grep list of CDS interested in from the gff3 file
#grep -f human_gta.GRCh38.96.ids Homo_sapiens.GRCh38.96.gff3 > human_gta.GRCh38.96.cds.gff3

open(IN,$ARGV[0]);	# ../hum_gta_ensembl_map file # Lsit of protein IDs, must match IDs in gff3 file
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/\|/,$a[0]);
	@c=split(/\./,$b[4]);
	$PosHash{$c[0]}{$a[6]}=$a[5];
	$PosAA{$c[0]}{$a[6]}=$a[1];
	# print $c[0];

}

$sum=0;
$currID="A";
open(IN2,$ARGV[1]);	# .cds.gff3 file # Filtered gff3 file with cds for only interested proteins
while(<IN2>){
	chomp;
	@a=split(/\t/,$_);
	($pid)=($a[8]=~/protein_id=(ENSP[0-9]+)/);
	if ($currID!~$pid){
		if ($sum!=0){
			print "\t#Exon:$exonCt;TotalLen:",$sum/3-1,"\n";
		}
		$exonCt=0;
		$sum=0;
		$aaSumPrev=0;
		$aaSum1=0;
		# print "BLA $currID $pid";
		$currID=$pid;
		print "$currID\t";
	}
	$diff=($a[4]-$a[3])+1;
	$aaD1=$diff/3;
	$aaD2=ceil($diff/3);
	$sum+=$diff;
	$aaSumPrev=ceil($aaSum1);
	$aaSum1+=$aaD1;
	$aaSum2=ceil($aaSum1);
	$exonCt++;

	# Output type 1 & 2: Print all positions or - in positions outside gt domain
	# if (exists $PosHash{$pid}{$aaSumPrev} && $PosHash{$pid}{$aaSumPrev}!~/[!-]/){
	# 	print "$PosHash{$pid}{$aaSumPrev}($aaSumPrev):";
	# }else{
	# 	# print "*($aaSumPrev):";
	# 	print "-:";
	# }
	if (exists $PosHash{$pid}{$aaSum2} && $PosHash{$pid}{$aaSum2}!~/^[!-]$/){
		print "$PosHash{$pid}{$aaSum2},";
	# }elsif ($PosHash{$pid}{$aaSum2}!~/-/){
	# 	print "I";
	}
	# Output type 3: Print only boundary positions within GT domain
	# if (exists $PosHash{$pid}{$aaSum2} && $PosHash{$pid}{$aaSum2}!~/[!-]/){
	# 	print "$PosHash{$pid}{$aaSum2}($aaSum2),";
	# }

}
print "\t#Exon:$exonCt;TotalLen:",$sum/3-1,"\n";

