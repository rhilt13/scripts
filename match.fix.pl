#!/usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;
print "BLSABLA\n";
open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	$hash{$_}=1;
}
print Dumper(\%hash);
## Compare multiple columns in 2nd file and keep single match
open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@a=split(/\t/,$_);
	shift @a;		## Specific for CAZY_GT-A.id_map file, since 1st column is family name not id
	foreach $str(@a){
		$str=~s/^\s+|\s+$//g;
		$str=~s/\.[0-9]+$|//g;
		# print $str;
		if (defined $hash{$str}){
			print "$str\n";
			last;
		}
	}
}
