#!/usr/bin/perl

use Bio::SeqIO;
use Data::Dumper;

open(IN,$ARGV[0]);

while(<IN>){
  chomp $_;
  $_=~s/^\s+|\s+$//g;
  $id_hash{$_}=1;
  # @a=split(/\t/,$_);
  # $id_hash{$a[1]}=1;
  # $fam{$a[1]}=$a[0];
  # if (scalar(@a)==9){
  #   $a[4]=~s/locus://;
  #   $locus{$a[1]}=$a[4];
  # }
#  $id_hash{$_}=1;
}

# # print Dumper(\%id_hash);

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

while($seq=$new->next_seq){
	# print $seq->id,"\n";
  $i=$seq->id;
  $s=$seq->seq;
  $i=~s/^\s+|\s+$//g;
# @a=split(/\|/,$i);
#  $a[1]=~s/\.[0-9]+$|//g;
  # print $a[1];
  # ($id)=($seq->id=~/(\S+):/);
  # ($id)=($seq->id=~/(.*)_/);
  # print $id;
  # print $id,"\n";
  # if($i=~/C.elegans/ && !defined $rep{$i}){
  #if(defined $id_hash{$seq->id}){
  #if(defined $id_hash{$i}){
  if(defined $id_hash{$i} && !defined $rep{$i}){	# remove sequences with duplicate genbank IDs
  # if ($id=~/GT12/){
    $rep{$i}=1;
    print ">$i\n$s\n";
    # print ">$i|$fam{$i}|$locus{$i}\n$s\n";
  }
}
