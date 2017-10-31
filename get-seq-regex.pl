#! /usr/bin/perl -w

use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$i=$seq->id;
	$d=$seq->desc;
	$s=$seq->seq;
	if ($i=~m/^GT74-/){
		print ">$i $d\n$s\n";
	}
}