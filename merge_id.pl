
#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	# $_=~s/\s/_/g;
	@a=split(/\t/,$_);
	# print "$a[2]\n";
	($name)=($a[2]=~/\[(.*?)\]/);
	$name=~s/\s/-/g;
	# print "$name\n";
	$hash{$a[0]}=$a[1]."-".$a[2];
	$hash2{$a[0]}=$name;
}

# print Dumper(\%name_hash);

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");
while($seq=$new->next_seq){
	@z=split(/_/,$seq->id);
	# print "$z[0]";
	print ">",$hash2{$z[0]},"_",$z[0],"_",$hash{$z[0]},"\n",$seq->seq,"\n";
}
