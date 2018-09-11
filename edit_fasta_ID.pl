#!/usr/bin/perl

use Bio::SeqIO;
use Data::Dumper;

open(IN,$ARGV[0]);  # File with info to edit IDs
while(<IN>){
  chomp $_;
  # @a=split(/\t/,$_);
  # @b=split(/;/,$a[1]);
  # $b[1]=~s/^\s+//g;
  # $b[1]=~s/\s+$//g;
  # $b[2]=~s/^\s+//g;
  # $b[2]=~s/\s+$//g;
  # $b[0]=~s/\s+$//g;
  # $b[0]=~s/^\s+//g;
  # $b[0]=~s/ /_/g;
  # $id_hash{$a[0]}=$b[1].".".$b[2].".".$b[0];

  @a=split(/\t/,$_);
  $id_hash{$a[0]}=$a[1];
}
# print Dumper(\%id_hash);

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

while($seq=$new->next_seq){
  $i=$seq->id;
  # $i=~s/\.[0-9]+$//g;
  # print $i;
  # $i=~s/[A-Z]$//;
  #@b=split(/\|/,$i);
  $s=$seq->seq;
  # $seq_hash{$a[1]}=$s;
  # @b=split(/\|/,$i);
#  $a=($i=~/^>(.*?)\|/);
#  print "$i\n";
#  print "$b[3]\n";
  if(defined $id_hash{$i}){
  # if(defined $id_hash{$b[2]}){
  # if(defined $id_hash{$a[1]} && (!(defined($print_hash{$a[1]})))){
  # if($i=~/GT78/){
  # if ($i=~/^consensus/){
    print ">$id_hash{$i}\n$s\n";
    # print ">$id_hash{$b[2]}\n$s\n";
  	# $print_hash{$a[1]}=1;

  # print ">human_".$b[3]."|$id_hash{$b[3]}\n$s\n";
  	# print ">GT-A|consensus\n$s\n";
  }else{
    print ">$i\n$s\n";
  }
}
