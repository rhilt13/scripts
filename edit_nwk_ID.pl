#! /usr/bin/perl -w

use Data::Dumper;

open(IN,$ARGV[0]);  # ID mapping file
while(<IN>){
  chomp;
  @a=split(/\t/,$_);
  $id=$a[0].":";
  $hash{$id}=$a[1];
}

open(IN2,$ARGV[1]); # tree file
while(<IN2>){
  chomp;
  foreach $k(keys %hash){
    # print "$k\n";
  	$j=$k;
  	$j=~s/\\//g;
    # $_=~s/$k/$j|$hash{$k}/g;
    $_=~s/$k/$hash{$k}:/g;
  }
  print "$_\n";
}
