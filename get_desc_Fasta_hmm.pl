#! /usr/bin/perl -w 

use Bio::SeqIO;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$hash{$a[0]}=$a[18];
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	if ($_=~/^>/){
		$_=~s/^>//;
		$_=~s/ .*//;
		if (defined $hash{$_}){
			print ">$_ $hash{$_}\n";
		}else{
			print ">$_\n";
		}
	}else{
		print "$_\n";
	}
}
