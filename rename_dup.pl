#!/usr/bin/perl -w
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$i=$seq->id;
	$d=$seq->desc;
	$s=$seq->seq;
	for ($j=1;$j<=1000;$j++){
		if ($j>1){
			$id=$i."_".$j;
		}else{
			$id=$i;
		}
		if (!exists $hash{$i}{$j}){
			$hash{$i}{$j}=1;
			if ($d eq ""){
				print ">$id\n$s\n";
			}else{
				print ">$id $d\n$s\n";
			}
			# print "$id\n";
			last;
		}

	}
}