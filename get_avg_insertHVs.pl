#!/usr/bin/env perl

use Data::Dumper;
use List::Util qw(max);

open(IN,$ARGV[0]);
while(<IN>){
	@a=split(/\t/,$_);
	if ($a[4] eq 'M'){
		if ($a[3] eq 'Chordata'){
			$tax='Chordata';
		}else{
			$tax='NonChordata';
		}
	}elsif ($a[4] eq 'V'){
		if ($a[3] eq 'Streptophyta'){
			$tax='Streptophyta';
		}elsif ($a[3] eq 'Chlorophyta'){
			$tax='Chlorophyta';
		}
	}elsif ($a[4] eq 'A' || $a[4] eq 'B'){
		$tax='Prokaryotes';
	}elsif ($a[4] eq 'F'){
		$tax='Fungi';
	}elsif ($a[4] eq 'E'){
		$tax='Protozoa';
	}else{
		print "##ERROR: Unknown tax group $a[4]\n";
	}
	$hash{$a[0]}{HV1}{$tax}+=$a[6];
	$hash{$a[0]}{HV2}{$tax}+=$a[7];
	$hash{$a[0]}{HV3}{$tax}+=$a[8];
	$hash{$a[0]}{Nt}{$tax}+=$a[9];
	$hash{$a[0]}{Ct}{$tax}+=$a[10];
	$cnt{$a[0]}{$tax}++;

}
@reg=("HV1","HV2","HV3","Nt","Ct");
@kingdom=("Prokaryotes","Protozoa","Fungi","Chlorophyta","Streptophyta","NonChordata","Chordata");

foreach $region(@reg){
	$val=0;
	foreach $fam(sort keys %hash){
		foreach $t(@kingdom){
			if (exists $hash{$fam}{$region}{$t} && exists $cnt{$fam}{$t}){
				$avg_len=$hash{$fam}{$region}{$t}/$cnt{$fam}{$t};
			}else{
				$avg_len='0';
			}
			if ($val<$avg_len){
				$val=$avg_len;
			}
			# print "$avg_len\t$val\n";
			$avgHash{$fam}{$region}{$t}=$avg_len;
			# print "$region\t$fam\t$t\t$avg_len\t$val\n";
			# push (@{$m{$region}},
		}
	}
	$max{$region}=$val;
	# print "MAX For $region : $val\n";
}


foreach $fam(sort keys %hash){
	print "$fam";
	foreach $region(@reg){
		# print "\t$region--";
		# print "$fam\t$region\n";
		# $out='out.'.$t.".".$region;
		# open(OUT,">>$out");
		foreach $t(@kingdom){
			# $norm_len=$avgHash{$fam}{$region}{$t}/$max{$region};
			# print "$t\t$region\t$fam\t$hash{$t}{$region}{$fam}\t$cnt{$fam}{$t}\t$avg_len\n";
			# print OUT "$fam\t$avg_len\n";
			# print "\t$t";
			# print "\t$norm_len";
			print "\t$avgHash{$fam}{$region}{$t}";
		}
	}
	print "\n";
}


# print Dumper(\%cnt);
# print Dumper(\%hash);