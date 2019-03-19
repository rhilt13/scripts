#!/usr/bin/env perl

use Algorithm::Combinatorics qw(combinations);

open(IN,$ARGV[0]);	# PDB position map file {GTpdbPos-AlnPos.txt}
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[1]=~/[A-Z]/){
		$hash{$a[0]}{$a[2]}=$a[3];
	}
}

open(IN2,$ARGV[2]);	# List of positions	# PDBfile_chain, MDparam, MDFilename, AlignedPositions(comma-separated)
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	print "param $b[1]";
	print "trajin $b[2]";
	@pos=split(/,/,$b[3]);
	$i=1;

	my $iter = combinations(@pos, 2);
	foreach $num(@pos){
		print "ditance dist",$i," :$hash{$b[0]}{$num} :$hash{$b[0]}{$num}"
	}

}