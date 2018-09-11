#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
# sort { $a <=> $b } keys(%hash)

####
# $ARGV[0] - fasta alignment file
# $ARGV[1] - sequence number to print

# get-pos-num.pl <alignment_file>

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	## multiple sequence alignment
$z=0;
while($seq=$new->next_seq){
	$z++;
	$id=$seq->id;
	$s=$seq->seq;
	if ($z==1){
		$first=$s;
	}
	$i=-1;	#Starting count for alignment position (including gaps)
	$j=0;	# Starting count for each sequence (excluding gaps)
	# print "$s\n";
	$len=length($s);
	# print "$len\n";
	@a=split(//,$s);
	print ">$id\n";
	foreach $pos(@a){
		$i++;
		$ct{$i}{$pos}++;
		if ($pos eq '-'){
			$ct_gap{$i}++;
		}else{
			$ct_res{$i}++;
			$j++;
		}
		if (!exists $res{$pos}){
			$res{$pos}=1;
		}
		if (exists $ARGV[1]){
			if ($ARGV[1]==$z){
				print "$pos\t$i\t$j\n";
			}
		}else{
			print "$pos\t$i\t$j\n";
		}
		# push (@len,$i);
	}
}

