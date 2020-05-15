#! /usr/bin/env perl

# Ver: 0.1
# Author: Rahil Taujale
# Date: April 30, 2020

# Simple script to write separate files based on a defined column.
# Used to generate family and subfamily level tables in gtXplorer.

use Data::Dumper;
# Input:
#	$ARGV[0]= table file with the data
#	$ARGV[1]= delimiter
#	$ARGV[2]=Column to separate by.
#	$ARGV[3]=common additions (suffix) to filenames written

$sep=$ARGV[1];
$key=$ARGV[2]-1;
$header="#source	GTA_family	GTA_subfamily	SequenceID	Species	TaxID	Phylum	Kingdom	SequenceFullLength	DomainStart	DomainEnd	DomainSequence	FullSequence";
open(IN,$ARGV[0]);
while(<IN>){
	@a=split(/$sep/,$_);
	$h1{$a[$key]}.=$_;
}
# print Dumper(\%h1);

foreach $k(sort keys %h1){
	$file=$k.$ARGV[3];
	open (OUT,">$file");
	print OUT "$header\n";
	print OUT "$h1{$k}";
}
