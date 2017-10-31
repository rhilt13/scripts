#! usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

# open(IN,$ARGV[0]);	## multiple sequence alignment
# while(<IN>){
# 	chomp
# }

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	## multiple sequence alignment

while($seq=$new->next_seq){
  $i=$seq->id;
  $s=$seq->seq;
  # print "$s\n";
  $len=length($s);
  print "$len\n";
}