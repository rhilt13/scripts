#! /usr/bin/perl -w 

## Before running this script, 
## save all genbank formatted sequences in a file and remove all newlines
## tr '\n' ' '

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@c=split(/\/\//,$_);
	foreach $en(@c){
		# print $en;
		$acc = $1 if ($en =~/LOCUS\s+(.*?)\s/);
		# print $acc;
		if ($en =~ /ORGANISM(.*?;.*?)\./){
			$tax = $1;
			# print $tax;
			$tax=~s/ +/ /g;
			$tax=~s/~/ /g;
			print "$acc\t$tax\n";
		}else{
		#	print "$acc\tno match found.\n";
		}
	}
}