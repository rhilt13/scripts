#!/usr/bin/perl

use Bio::SeqIO;
use Data::Dumper;

open(IN,$ARGV[0]);

while(<IN>){
  chomp $_;
  #@a=split(/\|/,$_);
  # $id_hash{$a[2]}=$a[1];
  # @a=split(/\./,$_);
  # $id_hash{$a[0]}=1;
  #$id_hash{$a[1]}=$_;
  $id_hash{$_}=1;
}
# print Dumper(\%id_hash);

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

while($seq=$new->next_seq){
  $i=$seq->id;
  $d=$seq->desc;
  # print $i;
  # $i=~s/[A-Z]$//;
  # @a=split(/\|/,$i);
  $s=$seq->seq;
  # $seq_hash{$a[1]}=$s;
  @b=split(/\|/,$i);
#  $a=($i=~/^>(.*?)\|/);
#  print "$i\n";
#  print "$b[3]\n";
#  $ip=$i;
  $i=~s/\..*$//;
  # print "$i\n";
  if(defined $id_hash{$i}){
  # if(defined $id_hash{$ip}){
  # if(defined $id_hash{$b[1]}){
  # if(defined $id_hash{$a[1]} && (!(defined($print_hash{$a[1]})))){
  # if($i=~/GT78/){
  # if ($i=~/^consensus/){
	print ">$i $d\n$s\n";
	# print ">$id_hash{$b[1]}\n$s\n";

  # print ">human_".$b[3]."|$id_hash{$b[3]}\n$s\n";
  	# print ">GT-A|consensus\n$s\n";
  }
}

# open(IN,$ARGV[0]);

# while(<IN>){
#   chomp $_;
#   # @a=split(/\t/,$_);
#   print ">GT-A|$_|consensus\n$seq_hash{$_}\n";
#   # $id_hash{$a[2]}=$a[1];
# }
