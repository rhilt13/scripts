#! /usr/bin/perl -w 

use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/^aln/){
		last;
	}elsif ($_=~/^\s+/ && $_=~/GT/){
		$_=~s/^\s+//g;
		$_=~s/\s+/\t/g;
		@a=split(/\t/,$_);
		if (!exists($hash{$set}{$a[1]})){
			# print "$a[1]\n";
			if (!exists($check_hash{$a[1]})){
				push @fam_arr, $a[1];
				$check_hash{$a[1]}=1;
			}
			$hash{$set}{$a[1]}=$a[0];
		}else{
			$hash{$set}{$a[1]}+=$a[0];
		}
		# print $_;
	}elsif ($_=~/^[0-9]/){
		($set)=($_=~/(Set[0-9]+)/);
		# print $set;
	}
}
print "*";
foreach $fam(sort @fam_arr){
	print "\t$fam";
}
print "\n";
foreach $key1(sort keys %hash){
	print "$key1";
	foreach $key2(sort @fam_arr) {
		if (exists($hash{$key1}{$key2})){
			print "\t$hash{$key1}{$key2}";
		}else{
			print "\t0";
		}
	}
	print "\n";
}
# print Dumper(\%hash);