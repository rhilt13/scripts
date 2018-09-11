#! /usr/bin/perl -w 

open(IN,$ARGV[0]);	# ID map file for omcbpps sets
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$set_hash{$a[0]}=$a[1];
}

open(IN2,$ARGV[1]);	# ID map file for original profile numbers
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	$gt_hash{$b[0]}=$b[1];
}

open(IN3,$ARGV[2]);	# list of cma files with hits for any given omcbpps set with original profile
					# *.cma files except *_aln.cma files inside cross_rungaps folder
while(<IN3>){
	chomp;
	($setNum,$gtNum)=($_=~/_([0-9]+).seq_([0-9]+).cma$/);
	# print $setNum,$gtNum;
	open(IN4,"$_");
	while(<IN4>){
		chomp;
		if ($_=~/^\$/){
			($len)=($_=~/=([0-9]+)\(/);
			print "$len\t";
		}elsif ($_=~/^>/){
			print "$_\t$set_hash{$setNum}\t$gt_hash{$gtNum}\n";		}
	# 	print $_;
	}
}