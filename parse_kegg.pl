#! /usr/bin/perl -w 

use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/%A/,$_);
	foreach $aa(@a){
		@b=split(/%B/,$aa);
		$z=shift @b;
		($a_id)=($z=~/>(.*)</);
		foreach $bb(@b){
			@c=split(/%C/,$bb);
			$y=shift @c;
			($b_id)=($y=~/>(.*)</);
			foreach $cc(@c){
				@d=split(/%D/,$cc);
				$c_id=shift @d;
				foreach $dd(@d){
					if ($dd=~/\[EC:2\.4\./){
						$dd=~s/^\s+//;
						$dd=~s/\s+$//;
						print "$a_id\t$b_id\t$c_id\t$dd\n";
					}
				}
			}
		}
	}
}