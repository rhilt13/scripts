#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

#Ver 0.2

# $ARGV[0] - 1st file with columns to be matched
# $ARGV[1] - which column from 1st file
# $ARGV[2] - 2nd file with columns to be matched
# $ARGV[3] - Column no. from file 2 to match

# match.pl file1 1 file2 1

# Log:
#02/22/2018
# Ver0.2 - Added options to specify columns to be matched

open(IN,$ARGV[0]);
$col1=$ARGV[1]-1;
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	@a=split(/\t/,$_);
	# $a[1]=$a[1]*3-3;
	# $hash{$a[0]}{$a[1]}=1;
	# $hash{$_}=1;
	$hash{$a[$col1]}=$_;
}
#  print Dumper(\%hash);

 ## Compare single (first) column in 2nd file
open(IN2,$ARGV[2]);
$col2=$ARGV[3]-1;
while(<IN2>){
 	chomp;
 	@a=split(/\t/,$_);
 	$a[$col2]=~s/^\s+|\s+$//g;
 	# @a=split(/\|/,$_);
 	# if (defined $hash{$a[0]}{$a[1]}){
 	if (defined $hash{$a[$col2]}){
 		if ($ARGV[4] eq 'both'){
	 		print "$_\t$hash{$a[$col2]}\n";
 		}else{
 			print "$_\n";
 		}
 	}
}

## Compare multiple columns in 2nd file and keep single match
#open(IN2,$ARGV[1]);
#while(<IN2>){
#	chomp;
#	@a=split(/\t/,$_);
#	# @a=split(/\|/,$_);
#	#shift @a;		## Specific for CAZY_GT-A.id_map file, since 1st column is family name not id
#	foreach $str(@a){
#		$str=~s/^\s+|\s+$//g;
#		# $str=~s/\.[0-9]+$|//g;
#		# print $str;
#		if (defined $hash{$str}){
#			# print "$str\n";
#			# print "$_\n";
#			# last;
#		}else{
#			print "$_\n";
#		}
#	}
#}
