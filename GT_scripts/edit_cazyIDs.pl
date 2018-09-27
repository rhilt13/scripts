#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);	# cazy_*_Table
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	# if ($a[1]=~/main/){
		@b=split(/\./,$a[4]);
		@c=split(/-/,$a[0]);
		$cazy_fold{$b[0]}=$c[1];
		$cazy_fam{$b[0]}=$a[1];
		($genus,$sp)=($a[3]=~/^([A-Za-z]).*? (.*)/);
		$sp=~s/[^[:alnum:]_-]//g;
		$tax=$genus.".".$sp;
		$tax_hash{$b[0]}=$tax;
	# }
}
# print Dumper(\%tax_hash);
# =ccc
open(IN2,$ARGV[1]);	# cazy_*_genbank.tax
while(<IN2>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[2]=~/virus/){
		$a[2]="Virus";
	}else{
		$a[2]=~s/[^[:alnum:]_-]//g;
	}
  	@b=split(/\./,$a[0]);
	$dom{$b[0]}=$a[2];
}

$new=Bio::SeqIO->new(-file=>$ARGV[2], -format=>"fasta");	# CAZy_*_genbank.faa

while($seq=$new->next_seq){
    $i=$seq->id;
    $s=$seq->seq;
  	@c=split(/\./,$i);
  	# print "$f[0]\n";
  	if (defined $tax_hash{$c[0]}){
  		if (defined $dom{$c[0]}){
	    	print ">$cazy_fam{$c[0]}-$cazy_fold{$c[0]}|$c[0]|$tax_hash{$c[0]}_$dom{$c[0]}\n$s\n";
	    }else{
	    	print ">$cazy_fam{$c[0]}-$cazy_fold{$c[0]}|$c[0]|$tax_hash{$c[0]}_\n$s\n";
	    }
  	}
}