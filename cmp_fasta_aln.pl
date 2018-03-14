#! /usr/bin/env perl

use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
  $i=$seq->id;
  $d=$seq->desc;
  $s=$seq->seq;
  # $i=~s/\.[0-9]+$//g;
  # print $i;
  # $i=~s/[A-Z]$//;
  #@b=split(/\|/,$i);
  $seq_hash1{$i}=$s;
  $desc_hash1{$i}=" ".$d;
}

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
while($seq=$new->next_seq){
  $i=$seq->id;
  $d=$seq->desc;
  $s=$seq->seq;  
  # $i=~s/\.[0-9]+$//g;
  # print $i;
  # $i=~s/[A-Z]$//;
  #@b=split(/\|/,$i);
  $seq_hash2{$i}=$s;
  $desc_hash2{$i}=" ".$d;
}

foreach $id(sort keys %seq_hash1){
	if ($seq_hash1{$id} ne $seq_hash2{$id}){
		print ">$id$desc_hash1{$id}\n$seq_hash1{$id}\n$seq_hash2{$id}\n";
	}
}