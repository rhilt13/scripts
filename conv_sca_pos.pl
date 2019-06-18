#! /usr/bin/env perl

# less GTpdbPos-AlnPos.txt|grep 5nrb_A > a

# $ARGV[0]: Temporary file "a" generated as above
# $ARGV[1]: File with IC description.

$num=-1;
open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$val="-";
	if ($a[1]=~/[A-Z]/){
		$num++;
		$val=$num;
	}
	$hash{$val}=$a[2];
	# print "$_\t$val\n";
}

open(IN2,$ARGV[1]);
while(<IN2>){
	if ($_=~/\+/){
		chomp;
		@b=split(/\+/,$_);
		$out="";
		foreach $n(@b){
			$out.=$hash{$n}."+";
		}
		print "$_\n$out\n";
	}else{
		print "$_";
	}
}


