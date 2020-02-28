#! /usr/bin/env perl

# Input:
# $ARGV[0]=fasta file
open(IN,$ARGV[0]);
while(<IN>){
	if ($_=~/^>/){
		chomp;
		$_=~s/^>//;
		$_=~s/,/_/g;
		print "$_,";
	}else{
		chomp;
		@a=split(//,$_);
		$line=join (",",@a);
		print "$line\n";
	}
}