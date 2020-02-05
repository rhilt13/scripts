#! /usr/bin/env perl

use Data::Dumper;
# Input:
#	$ARGV[0]= table file with the data
#	$ARGV[1]= delimiter
#	$ARGV[2]=Column to separate by.
#	$ARGV[3]=common additions (suffix) to filenames written

$sep=$ARGV[1];
$key=$ARGV[2]-1;
open(IN,$ARGV[0]);
while(<IN>){
	@a=split(/$sep/,$_);
	$h1{$a[$key]}.=$_;
}
# print Dumper(\%h1);

foreach $k(sort keys %h1){
	$file=$k.$ARGV[3];
	open (OUT,">$file");
	print OUT "$h1{$k}";
}
