#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);	# cazy_*_ID_list.txt
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	# if ($a[1]=~/main/){
		@b=split(/\./,$a[3]);
		$cazy_fam{$b[0]}=$a[0];
	# }
}
# print Dumper(\%cazy_fam);
open(IN2,$ARGV[1]);	# CAZy_*_genbank.tax_map.filter
while(<IN2>){
	chomp;
	@c=split(/\t/,$_);
	if ($c[1]=~/\;.*\;/){
		# print "$_\n";
		# print "--$c[1]\n";
	# 	# @d=split
		($sp,$fam)=($c[1]=~/^ (.*?)\s\s.*?; ([A-Z].*?);/);
		# print "--$sp\t$fam\n";
		# print "$c[0]\t$sp\t$fam\n";
		if ($sp=~/^[A-Z]/){
			$genus=substr($sp,0,1);
			# print "$c[0]\t-$sp\t$fam\t$genus\n";
			($species)=($sp=~/^.*? (.*?)(\s|$)/);
			# $species=~s/ /_/g;
			$sp_name= $genus.".".$species;
			if ($fam=~/^[A-Z]/){
				$tax=$sp_name."_".$fam;
				# print "$c[0]\t$sp\t$sp_name\t$tax\n";
				$tax_hash{$c[0]}=$tax;
			}else{
				$tax_hash{$c[0]}=$sp_name;
			}
		}
	}else{
		next;
	}
}
# print Dumper(\%tax_hash);
# =ccc
$new=Bio::SeqIO->new(-file=>$ARGV[2], -format=>"fasta");	# CAZy_*_genbank.faa

while($seq=$new->next_seq){
	# print $seq->id,"\n";
  # ($id)=($seq->id=~/(\S+):/);
  # ($id)=($seq->id=~/(.*)_/);
  # print $id;
  # print $id,"\n";
  # if(defined $id_hash{$id}){
    $i=$seq->id;
    $s=$seq->seq;
  	@e=split(/\|/,$i);
  	@f=split(/\./,$e[3]);
  	# print "$f[0]\n";
  	if(defined $tax_hash{$f[0]}){
	    print ">$cazy_fam{$f[0]}-A|$f[0]|$tax_hash{$f[0]}\n$s\n";
  	}
}