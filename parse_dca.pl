#!/usr/bin/env perl

# parse_dca.pl ~/GT/gta_revise12/mapping_files/GTpdbPos-AlnPos.txt gt43/nr_rev12sel3_pdbaa.dca_pml |sort -u|sort -k1,1 -k2,2n

open(IN,$ARGV[0]);	# GTpdbPos-AlnPos.txt pdb to cma mapping file
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[1]!~/-/){
		$a[1]=uc($a[1]); 
		$hash{$a[0]}{$a[1]}{$a[3]}=$a[2];
	}
}

open(IN2,$ARGV[1]);	#*.dca_pml file
while(<IN2>){
	chomp;
	if ($_=~/^==.*==$/){
		@a=split(/ /,$_);
		@b=split(/_/,$a[3]);
		$b[0]=lc($b[0]);
		$pdb=$b[0]."_".$b[1];
	}elsif ($_=~/^[0-9]+\t/){
		# print $_;
		@a=split(/\t/,$_);
		$a[1]=~s/ //g;
		$a[2]=~s/ //g;
		($res1,$num1)=($a[1]=~/^([A-Z])([0-9]+)/);
		($res2,$num2)=($a[2]=~/^([A-Z])([0-9]+)/);
		if (exists $hash{$pdb}{$res1}{$num1} && exists $hash{$pdb}{$res2}{$num2}){
			print "$pdb\t$a[0]\t$a[3]\t$hash{$pdb}{$res1}{$num1}\t$a[1]\t$hash{$pdb}{$res2}{$num2}\t$a[2]\n";
		}else{
			print "## Not mapped $pdb/$res1/$num1 OR $pdb/$res2/$num2\n";
		}

	}
}