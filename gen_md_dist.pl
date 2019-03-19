#!/usr/bin/env perl

# Input:
# 1st: PDB position map file {GTpdbPos-AlnPos.txt}
# 2nd: List of positions {lsit_file.txt}
# 		Format: PDBfile_chain \t MDparam \t MDFilename \t AlignedPositions(comma-separated) \t StartNumPdb
#		Example line: 2rit_A  finmn.parm7      GT6-traj.nc      93,116,180

# Example run:
# gen_md_dist.pl GTpdbPos-AlnPos.txt list_file.txt

use Math::Combinatorics;

open(IN,$ARGV[0]);	# PDB position map file {GTpdbPos-AlnPos.txt}
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[1]=~/[A-Z]/){
		$hash{$a[0]}{$a[2]}=$a[3];
		$res{$a[0]}{$a[2]}=$a[1];
	}
}
open(IN2,$ARGV[1]);	# List of positions	# PDBfile_chain, MDparam, MDFilename, AlignedPositions(comma-separated)
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	print "parm $b[1]\n";
	print "trajin $b[2]\n";
	@pos=split(/,/,$b[3]);
	$i=1;
	my $combinat = Math::Combinatorics->new(count => 2,data => [@pos]);
	while(my @combo = $combinat->next_combination){
		if (exists $hash{$b[0]}{$combo[0]} && exists $hash{$b[0]}{$combo[1]}){
			$num1=$hash{$b[0]}{$combo[0]}-$b[4]+1;
			$num2=$hash{$b[0]}{$combo[1]}-$b[4]+1;
    		print "distance dist",$i," :$num1 :$num2 out $combo[0]",$res{$b[0]}{$combo[0]},"-$combo[1]",$res{$b[0]}{$combo[1]},".agr\n";
    		$i++;
    	}else{
    		print "##ERROR: Position $combo[0] or $combo[1] not mapped to pdb $b[0]\n";
    	}
  	}
  	print "go \n";
  	print "quit \n";
}

