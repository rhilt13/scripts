#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$hash{$a[0]}=$a[1];
	# $_=~s/^\s+|\s+$//g;
	# $hash{$_}=1;
}
# print Dumper(\%hash);

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	# @a=split(/\t/,$_);
	# if (defined $hash{$a[0]}){
	if ($_=~/^>/){
#		@b=split(/ /,$_);
#		foreach $p(@b){
			foreach $id(keys %hash){
				if ($_=~/$id/){
					$_=~s/^>//;
					print "$hash{$id}\t$_\n";
					next;
				}

			}
#		}
	}
}

