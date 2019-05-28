#! /usr/bin/env perl

# Inside analysis/network/25pos/mainfam folder,
# cat nrrev13_sel1.pttrns.padded.fam.25pos.inv.mainsets nrrev13_sel1.pttrns.padded.fam.25pos.ret.mainsets > a

# Input:
# $ARGV[0]: file with 7 columns: 
#			4th column has main family names; 
#			6th column has Mechanism;
#			7th column has csv of omc patterns
# $ARGV[1]: List of all families (Column 4 has to be a subset of this)
# $ARGV[2]: List of all desired pattern positions (a subset of positions in the 7th column)

use Data::Dumper;

open(IN,$ARGV[0]);	# See above Input
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/,/,$a[6]);
	foreach $pat(@b){
		($res,$pos)=($pat=~/^([A-Z]+)([0-9]+)$/);
		if (!exists $hash{$a[3]}{$pos}){
			$hash{$a[3]}{$pos}=$res;
		}else{
			@c=split(//,$res);
			$newaa=$hash{$a[3]}{$pos};
			foreach $aa(@c){
				if (index($hash{$a[3]}{$pos}, $aa)== -1){
					$newaa.=$aa;
				}
			}
			$hash{$a[3]}{$pos}=$newaa;
			# print "Exists $a[3] $pos Old:$hash{$a[3]}{$pos} New:$res Newaa:$newaa\n";
		}
	}
}
# print Dumper(\%hash);

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	push(@fam,$_);
}

open(IN3,$ARGV[2]);
while(<IN3>){
	chomp;
	push(@pos,$_);
}

foreach $f(@fam){
	print "$f\t";
	foreach $p(@pos){
		if (exists $hash{$f}{$p}){
			print "$hash{$f}{$p}\t";
		}else{
			print "-\t";
		}
	}
	print "\n";
}