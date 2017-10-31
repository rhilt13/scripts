use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$hash{$seq->id}= $seq->seq;
#	if ($seq->seq=~/^..W/){
		# print ">",$seq->id,"\n",$seq->seq,"\n";
#	}
}

open(IN,$ARGV[1]);
while(<IN>){
	chomp;
	print ">$_\n$hash{$_}\n";
}