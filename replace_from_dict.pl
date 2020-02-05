#! /usr/bin/env perl

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if (!exists $hash{$a[2]}){
		$hash{$a[2]}=$a[0];
	# }else{
	# 	print "$a[2]\t$hash{$a[2]}\t$a[0]\n";
	}
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	if (exists $hash{$b[0]}){
		print $hash{$b[0]};
	}else{
		print $b[0];
	}
	print "\t";
		if (exists $hash{$b[1]}){
		print $hash{$b[1]};
	}else{
		print $b[1];
	}
	print "\n";
}
