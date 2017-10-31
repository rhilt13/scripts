#!/usr/bin/perl -w
use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
while($seq=$new->next_seq){
	$len=length($seq->seq);
	$s=$seq->seq;
	if ($ARGV[1]!~/-/){
		$s=~s/-//g;
	}
	$len_ng=length($s);
	print $seq->id,"\t$len\t$len_ng\n";
	$hash{$seq->id}=$len;
=ccc
	if ($len <= 900 && $len >= 200){
	# $hash2{$seq->id}=$seq->seq;
		if ($seq->id=~/\db\|/ || $seq->id=~/\dc\|/ || $seq->id=~/\dd\|/){
			next;
		}else{
			print ">",$seq->id,"\n",$seq->seq,"\n";
		}
	}
=cut
}
#$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
#while($seq=$new->next_seq){
#	print $seq->id,"\t",$hash{$seq->id},"\n";
#}
