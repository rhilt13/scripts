#!/usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;
# use String::Substitution qw( sub_modify );

# v1.0
# Date: Jul 19, 2019

# Example Run
# search_and_replace.pl mapFile fileToReplace t

open(IN,$ARGV[0]);	# Index file with ID and map
while(<IN>){
	chomp;
	# @a=split(/\|/,$_);
	# $hash{$a[1]}=$_;
	@a=split(/\t/,$_);
	$hash{$a[0]}=$a[1];
}

# print Dumper(\%hash);
open(IN2,$ARGV[1]);		# Tab separated files
while(<IN2>){
	chomp;
	if ($ARGV[2]=~/tab/){
		@b=split(/\t/,$_);
		if ($b[0]=~/\|/){
			@c=split(/\|/,$b[0]);
			$map=$c[1];
		}else{
			$map=$b[0];
			# print $map;
		}
		if (defined $hash{$map}){
			# print "$hash{$map}\t$b[1]\t$b[2]\n";
			print "$hash{$map}\t$b[1]\n";
		}else{
			print "$_\n";
		}
	}else{
		foreach $key(sort keys %hash){
			# print "$key\t$hash{$key}\n";
			# sub_modify($_, $key, $hash{$key});
			$_=~ s/$key/$hash{$key}/;
		}
		print "$_\n";
	}
}

# $new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

# while($seq=$new->next_seq){
#   $i=$seq->id;
#   $d=$seq->desc;
#   $s=$seq->seq;

#   if ($i=~/\|/){
# 		@c=split(/\|/,$i);
# 		$map=$c[2];
# 	}else{
# 		$map=$i;
# 	}
# 	if (defined $hash{$map}){
# 		print ">$hash{$map}\n$s\n";
# 	}else{
# 		print ">$i !\n$s\n";
# 	}
# }
