#! /usr/bin/perl -w 

open(IN,$ARGV[0]);
while(<IN>){
	chomp;

	$a=lc $_;
	$orig{$a}=$_;
	$hash{$a}=1;
}
open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@a=split(/,/,$_);
	foreach $i(@a){
		$j=lc($i);
		if (defined $hash{$j}){
			print "$i\t$a[2]\n";
			# delete $hash{$i};
		}
	}
}

# foreach $k(keys %hash){
# 	print "$k\n";
# }