use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");

while($seq=$new->next_seq){
	@a=split(/_/,$seq->id);
	open (OUT,">$a[0]");
	print OUT ">",$seq->id,"\n",$seq->seq,"\n";
}