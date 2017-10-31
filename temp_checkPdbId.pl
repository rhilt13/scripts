#! /usr/bin/perl -w 

use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$a[2]=~s/^\s+|\s+$//g;
	@b=split(/:/,$a[2]);
	foreach $p(@b){
		$id=substr $p,0,4;
		$hash{$id}=1;
	}
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	if (defined $hash{$_}){
		# print "$_\n";
	}else{
		print "$_\n";
	}
}