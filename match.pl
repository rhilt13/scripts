#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	# @a=split(/\t/,$_);
	# $a[1]=$a[1]*3-3;
	# $hash{$a[0]}{$a[1]}=1;
	$hash{$_}=1;
}
 # print Dumper(\%hash);

# ## Compare single (first) column in 2nd file
# open(IN2,$ARGV[1]);
# while(<IN2>){
# 	chomp;
# 	@a=split(/\t/,$_);
# 	$a[0]=~s/^\s+|\s+$//g;
# 	# @a=split(/\|/,$_);
# 	# if (defined $hash{$a[0]}{$a[1]}){
# 	if (!defined $hash{$a[0]}){
# 		print "$_\n";
# 	}
# }

## Compare multiple columns in 2nd file and keep single match
open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@a=split(/\t/,$_);
	# @a=split(/\|/,$_);
	#shift @a;		## Specific for CAZY_GT-A.id_map file, since 1st column is family name not id
	foreach $str(@a){
		$str=~s/^\s+|\s+$//g;
		# $str=~s/\.[0-9]+$|//g;
		# print $str;
		if (defined $hash{$str}){
			# print "$str\n";
			# print "$_\n";
			# last;
		}else{
			print "$_\n";
		}
	}
}