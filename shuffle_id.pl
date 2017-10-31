
#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	if ($seq->id =~/]$/){
		($name)=($seq->id=~/\[(.*?)\]/);
	}elsif ($seq->id =~/^XP\-/){
		$name="Dictyostelium-discoideum";
	}elsif ($seq->id =~/^TGME49\-/){
		$name="Toxoplasma-gondii";
	}else{
		if ($seq->id =~/\|/){
			@z=split(/\|/,$seq->id);
			$z[3]=~s/^\-//g;
			$z[3]=~s/\-$//g;
			$name=$z[3];
		}
	}
	# print "$z[0]";
	# print ">",$hash2{$z[0]},"_",$z[0],"_",$hash{$z[0]},"\n",$seq->seq,"\n";
	print ">$name"."_".$seq->id."\n".$seq->seq."\n";
}
