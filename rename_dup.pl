#!/usr/bin/perl -w
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$i=$seq->id;
	$d=$seq->desc;
	$s=$seq->seq;
	if (!exists $hash{$i}){
		$hash{$i}=1;
		print ">$i $d\n$s\n";
	}else{
		$j=$i."_2";
		if (!exists $hash{$j}){
			$hash{$j}=1;
		print ">$j $d\n$s\n";
		}else{
			$k=$i."_3";
			if (!exists $hash{$k}){
				$hash{$k}=1;
				print ">$k $d\n$s\n";
			}else{
				$m=$i."_4";
				if (!exists $hash{$m}){
				$hash{$m}=1;
				print ">$m $d\n$s\n";
				}else{
					print "ERROR: More than 4 sequences for ",$i,"\n";
					die;
				}
			}
		}
	}

}