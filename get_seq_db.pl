#! /usr/bin/perl -w 

use Bio::DB::Fasta;
use Bio::SeqIO;
my $gb = new Bio::DB::Fasta;
my $seqout = new Bio::SeqIO(-fh => \*STDOUT, -format => 'fasta');
while(<>){
	chomp;
	$seq = $gb->get_Seq_by_acc($_);
	print ">$_"."|len:".$seq->length."|".$seq->id." ".$seq->desc."\n".$seq->seq."\n";
}