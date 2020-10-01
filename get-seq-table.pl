#!/usr/bin/perl

# Input:
# - table file
# column with IDs
# delimiter

use Bio::SeqIO;
use Data::Dumper;

$new=Bio::SeqIO->new(-file=>$ARGV[3], -format=>"fasta");

while($seq=$new->next_seq){
  # print $seq->id,"\n";
  $i=$seq->id;
  $d=$seq->desc;
  $s=$seq->seq;
  #$i=~s/^\s+|\s+$//g;
  #$i=~s/^\s+|\s+$//g;
  # $id=$i;
  @a=split(/\|/,$i);
  $id=$a[1];
  # $srch=$i;
  #$srch=$a[1];
  #$a[1]=~s/\.[0-9]+$|//g;
  # print $a[1];
  # ($id)=($seq->id=~/(\S+):/);
  # ($id)=($seq->id=~/(.*)_/);
  # print $id;
  # print $id,"\n";
  # if($i=~/HUMAN/ && !defined $rep{$i}){
  #if(defined $id_hash{$seq->id}){
  $id_hash{$id}=$i;
  $seq_hash{$id}=$s;
}

open(IN,$ARGV[0]);

while(<IN>){
  chomp;
  @a=split(/$ARGV[2]/,$_);
  $a[$ARGV[1]]=~s/^\s+|\s+$//g;
  # $id_hash{$_}=1;
  # @a=split(/\t/,$_);
  # $id_hash{$a[1]}=1;
  # $fam{$a[1]}=$a[0];
  # if (scalar(@a)==9){
  #   $a[4]=~s/locus://;
  #   $locus{$a[1]}=$a[4];
  # }
  $qry=$a[$ARGV[1]];
  if (exists $seq_hash{$qry}){
    print "$_\t$id_hash{$qry}\t$seq_hash{$qry}\n";
  }
}

# # print Dumper(\%id_hash);


