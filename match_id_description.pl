#!/usr/bin/perl

# Command line:
# perl ~/rhil_project/scripts/match_id_description.pl fn3k-rp.fa.txs.faa LMWPTP_human.fa.txs.faa
# Output:
#Stats lines start with #
#Duplicates in file 1: Lines start with #%%
#Duplicates in file 2: Lines start with #&&
#Seq unique to file 1: Lines start with #^^
#Seq unique to file 2: Lines start with #!!
#Fused sequences in FASTA format

use Bio::SeqIO;
use Data::Dumper;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");

while($seq=$new->next_seq){
  $i=$seq->id;
  $s=$seq->seq;
  $desc=$seq->desc;
  ($sp)=($desc=~/\[(.*?)\]$/);
  $sp=~s/ /_/g;
  ($tax)=($desc=~/\{(<.*?>)\}/);
  # print "$desc\t$sp\n";
  if (!exists $ct_dup1{$sp}){
    $id_hash{$sp}=$i;
    $seq_hash{$sp}=$s;
    $ct_dup1{$sp}=1;
    $tax_hash{$sp}=$tax;
  }else{
    $ct_dup1{$sp}++;
    delete $id_hash{$sp};
  }
}

$new2=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
while($seq2=$new2->next_seq){
  $i2=$seq2->id;
  $s2=$seq2->seq;
  $desc2=$seq2->desc;
  ($sp2)=($desc2=~/\[(.*?)\]$/);
  $sp2=~s/ /_/g;
  ($tax2)=($desc2=~/\{(<.*?>)\}/);
  if (!exists $ct_dup2{$sp2}){
    $id_hash2{$sp2}=$i2;
    $seq_hash2{$sp2}=$s2;
    $ct_dup2{$sp2}=1;
    $tax_hash2{$sp2}=$tax2;
  }else{
    $ct_dup2{$sp2}++;
    delete $id_hash2{$sp2};
  }
}

$ct1=0;
$ct2=0;
$ct3=0;
$ct4=0;
# $ct_dup2{$sp2}=1;
#     if (exists $id_hash{$sp2}){
#       $match{$sp2}=1;
#       $out.=">$id_hash{$sp2}-$i2-$sp2\n$seq_hash{$sp2}-$s2\n";
#     }else{
#      $id_only2{$sp2}=$i2;
#     }
#   }else{
#     $ct_dup2{$sp2}++;
#   }
# }

foreach $sp(keys %id_hash){
  if (exists $id_hash2{$sp}){
    $out_fused.=">$id_hash{$sp}-$id_hash2{$sp}-$sp\n$seq_hash{$sp}-$seq_hash2{$sp}\n";
  }else{
    $ct3++;
    $out_only1.="#^^$id_hash{$sp}\t$sp\t$tax_hash{$sp}\n";
  }
}

foreach $sp(keys %id_hash2){
  if (!exists $id_hash{$sp}){
    $ct4++;
    $out_only2.="#!!$id_hash2{$sp}\t$sp\t$tax_hash2{$sp}\n";
  }
}

# print Dumper(\%ct_dup1);
# print Dumper(\%id_hash);
# print Dumper(\%ct_dup2);
# print Dumper(\%id_hash2);

foreach $sp(keys %ct_dup1){
  if ($ct_dup1{$sp} >1){
    $ct1++;
    $out_dup1.="#%%$sp\t$ct_dup1{$sp}\t$tax_hash{$sp}\n";
  }
}

foreach $sp(keys %ct_dup2){
  if ($ct_dup2{$sp} >1){
    $ct2++;
    $out_dup2.="#&&$sp\t$ct_dup2{$sp}\t$tax_hash2{$sp}\n";
  }
}

print "Multiple seq hits for $ARGV[0] in $ct1 species.\n";
print "Multiple seq hits for $ARGV[1] in $ct2 species.\n";
print "Unique seqs in $ARGV[0] = $ct3\n";
print "Unique seqs in $ARGV[1] = $ct4\n";

print "################################# duplicates in $ARGV[0] :\n";
print $out_dup1;

print "################################# duplicates in $ARGV[1] :\n";
print $out_dup2;

print "################################# These ids present only in $ARGV[0]:\n";
print $out_only1;

print "################################# These ids present only in $ARGV[1]:\n";
print $out_only2;

print "#################################------------------\n";
print $out_fused;
