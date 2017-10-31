#! /usr/bin/perl -w
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$i=$seq->id;
	$s=$seq->seq;
	# @a=split(/_/,$seq->id);
	if ($i!~/consensus/){
		print ">$i\n$s\n";
	}
}