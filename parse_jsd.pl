#! /usr/bin/env perl

############
# Generate a matrix of JSD between all families based on previous calculation
############

$total_pos=36;
use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/ //g;
	@a=split(/\t/,$_);
	$jsd_val{$a[0]}{$a[1]}{$a[2]}=$a[3];
	$sum{$a[0]}{$a[1]}+=$a[3];
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	push(@fam,$_);
}
# print @fam;
# print Dumper(\%jsd_val);
print "Family";
foreach $f1(@fam){
	print ",$f1";
}
print "\n";
foreach $f1(@fam){
	print "$f1";
	foreach $f2(@fam){
		if (exists $ARGV[2]){
			if ($ARGV[2]!~/,/){
				print ",$jsd_val{$f1}{$f2}{$ARGV[2]}";
			}else{
				@b=split(/,/,$ARGV[2]);
				$num=scalar(@b);
				$s=0;
				foreach $c(@b){
					$s+=$jsd_val{$f1}{$f2}{$c};
				}
				$avg=$s/$num;
				print ",$avg";
			}
		}else{
			$avg=$sum{$f1}{$f2}/$total_pos;
			print ",$avg";
		}
	}
	print "\n"
}