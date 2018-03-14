#! /usr/bin/env perl

open(IN,$ARGV[0]);	# pos_map file
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/ /,$a[1]);
	$hash{$a[0]}{$b[0]}{$a[-1]}=$a[-2];	# change value based on which position you want to map

}

open(IN2,$ARGV[1]);	# COSMIC data file
while(<IN2>){
	chomp;
	@c=split(/\t/,$_);
	if ($c[24]=~/sense/){
		$mut_pos=$c[23];
		$mut_pos=~s/.\..//;
		$mut_pos=~s/.$//;
		print "$c[1]\t$c[6]\t$c[23]\t$c[24]\t$hash{$c[1]}{$c[6]}{$mut_pos}\n";
	}
}