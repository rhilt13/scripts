#! /usr/bin/perl -w 

use Data::Dumper;
#use Bio::SeqIO;

#Ver 0.2

# $ARGV[0] - 1st file with columns to be matched
# $ARGV[1] - which column from 1st file
# $ARGV[2] - 2nd file with columns to be matched
# $ARGV[3] - Column no. from file 2 to match
# $ARGV[4] - Delimeter ([ ,\t])
# $ARGV[5] - both: print columns from both files
#			 print columns from only 2nd file
# $ARGV[6] - all: print all lines with "=NO MATCH" tag at the end of line for no matches
# match.pl file1 1 file2 1

# Notes:
# IF want repeated columns, use file with repeated liens as file2
# IF both files have repetitions then use multiple columns to make unique key

# Log:
#02/22/2018
# Ver0.2 - Added options to specify columns to be matched
#03/06/2018
# Ver0.3 - Can match multiple columns

if ($ARGV[1]=~/^[0-9]+$/){
	$col1=$ARGV[1]-1;
	$use1='single';
}else{
	$use1='multiple';
	@columns1=split(/,/,$ARGV[1]);
}
open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	@a=split(/$ARGV[4]/,$_);
	# $a[1]=$a[1]*3-3;
	# $hash{$a[0]}{$a[1]}=1;
	# $hash{$_}=1;
	if ($use1 eq 'multiple'){
		$key1='';
		foreach $num(@columns1){
			$a[$num-1]=~s/^\s+|\s+$//g;
			$key1.=$a[$num-1];
		}
		$hash{$key1}=$_;
	}else{
		$a[$col1]=~s/^\s+|\s+$//g;
		$hash{$a[$col1]}=$_;
	}
}
#  print Dumper(\%hash);

## Compare column in 2nd file
if ($ARGV[3]=~/^[0-9]+$/){
	$col2=$ARGV[3]-1;
	$use2='single';
}else{
	$use2='multiple';
	@columns2=split(/,/,$ARGV[3]);
}
open(IN2,$ARGV[2]);
while(<IN2>){
 	chomp;
 	@a=split(/$ARGV[4]/,$_);
 	# @a=split(/\|/,$_);
 	# if (defined $hash{$a[0]}{$a[1]}){
 	if ($use2 eq 'multiple'){
		$key2='';
		foreach $num(@columns2){
			$a[$num-1]=~s/^\s+|\s+$//g;
			$key2.=$a[$num-1];
		}
	}else{
		$a[$col2]=~s/^\s+|\s+$//g;
		$key2=$a[$col2];
	}
 	if (defined $hash{$key2}){
 		if (exists $ARGV[5] and $ARGV[5] eq 'both'){
	 		print "$_\t$hash{$key2}\n";
 		}else{
 			print "$_\n";
 		}
 	}else{
 		if (exists $ARGV[6] and $ARGV[6] eq 'all'){
 			print "$_\t==NO MATCH\n";
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
