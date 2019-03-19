#! /usr/bin/env perl

# Input:
# $ARGV[0] = pdb in cif format

use Data::Dumper;

open(IN,$ARGV[0]);	# pdb file in .cif format

$line=0;
$ct=0;
while(<IN>){
	chomp;
	if ($_=~/^data_/){
		$_=~s/ +/\t/g;
		# print $_;
		@p=split(/_/,$_);
		$pdb=lc($p[1]);
		# print @p,$pdb;
	}elsif ($_=~/^_pdbx_poly_seq_scheme.hetero/){
		$line=1;
		$ct++;
	}elsif ($_=~/^#/){
		$line=0;
	}else{
		if ($line==1){
			$_=~s/ +/\t/g;
			@ent=split(/\t/,$_);
			push(@{$atoms{$ent[9]}},$ent[5]);
			push(@{$res{$ent[9]}},$ent[3]);
		}
	}
}
# print $pdb,@a;
# print Dumper(\%atoms);

for $chain(sort keys %atoms){
	print $pdb."_".$chain."\t".$res{$chain}[0]."\t".$atoms{$chain}[0]."\t".$res{$chain}[-1]."\t".$atoms{$chain}[-1],"\n";
}
# $a[0]=~s/ +/\t/g;
# @first=$a[0];
# print $a[0];
# print $pdb."_".$first[9]."\t".$first[]

# $a[-1]=~s/ +/\t/g;
# @last=$a[-1];

# print $a[-1];
