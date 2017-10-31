use Bio::SeqIO; 
use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@z=split(/ /,$_);
	if ($z[0]>20){
		$hash{$z[1]}=$z[0];
	}
}

# print Dumper(\%hash);

$new=Bio::SeqIO->new(-file=>"Fbox_Skp1_protist.faa", -format=>"fasta");
while($seq=$new->next_seq){
	@a=split(/_/,$seq->id);
	if (exists $hash{$a[0]}){
		# print "$a[0]\t$hash{$a[0]}\n";
		if ($a[1]<=10){
			print ">",$seq->id,"\n",$seq->seq,"\n";
		}elsif ($hash{$a[0]}-$a[1]<10){
			print ">",$seq->id,"\n",$seq->seq,"\n";
		}
	}else{
		print ">",$seq->id,"\n",$seq->seq,"\n";
	}
}