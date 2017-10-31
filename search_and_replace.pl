#!/usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);	# Index file with ID and map
while(<IN>){
	chomp;
	@a=split(/\|/,$_);
	$hash{$a[1]}=$_;
}

open(IN2,$ARGV[1]);		# Tab separated files
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	if ($b[0]=~/\|/){
		@c=split(/\|/,$b[0]);
		$map=$c[1];
	}else{
		$map=$b[0];
	}
	if (defined $hash{$map}){
		print "$hash{$map}\t$b[1]\t$b[2]\n";
	}else{
		print "! $_\n";
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