#! /usr/bin/perl -w 

use Bio::SeqIO;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[1]=~/pdb/){
		$hash1{$a[1]}=$a[0];
	}
}

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
while($seq=$new->next_seq){
	$hash2{$seq->id}=$seq->seq;
	# print ">",$seq->id,"\n",$seq->seq,"\n";
}

open(IN,$ARGV[2]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	if ($a[1]=~/pdb/){
		$hash3{$a[0]}=$a[1];
	}
}

$new=Bio::SeqIO->new(-file=>$ARGV[3], -format=>"fasta");
while($seq=$new->next_seq){
	# if ($hash1{$seq->id} eq $hash3{$seq->id}){

	if (exists $hash1{$hash3{$seq->id}}){
		print ">",$hash3{$seq->id},"_",$hash1{$hash3{$seq->id}},"_",$seq->id,"\n",$hash2{$hash1{$hash3{$seq->id}}},"X",$seq->seq,"\n";
	}

}