#! /usr/bin/perl -w 

# open(IN,$ARGV[0]);
# while(<IN>){
# 	chomp;
# 	$hash{$_}=1;
# }

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@a=split(/\t/,$_);
	$hash{$a[0]}=1;
	# if (defined $hash{$a[0]}){
	# 	print "$_\n";
	# }
}


open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if (defined $hash{$_}){
		print "$_\n";
	}
	# $hash{$_}=1;
}