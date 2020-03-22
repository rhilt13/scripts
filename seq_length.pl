#!/usr/bin/perl -w
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$len=length($seq->seq);
	$s=$seq->seq;
	$d=$seq->desc;
	$s=~s/-//g;
	$len_ng=length($s);
#	$hash{$seq->id}=$len;

	if (defined($ARGV[1])){
		if ($len <= $ARGV[2] && $len >= $ARGV[1]){
	# $hash2{$seq->id}=$seq->seq;
		# (?# if ($seq->id=~/\db\|/ || $seq->id=~/\dc\|/ || $seq->id=~/\dd\|/){)
			# next;
		# }else{
			print ">",$seq->id;
			if ($d=~/[a-zA-Z0-9]/){
				print " $d";
			}
			print "\n",$seq->seq,"\n";
		}
	}else{
		print $seq->id,"\t$len\t$len_ng\n";
	}
}
#$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
#while($seq=$new->next_seq){
#	print $seq->id,"\t",$hash{$seq->id},"\n";
#}
