#! /usr/bin/perl -w 

use Bio::SeqIO;

open(IN,$ARGV[0]);

# <IN>;			### Getting rid of first line (Only for ID_order GT file, Change for other files)
while(<IN>){
  chomp $_;
  ## Parse the file as needed
  ##
  #######
  push(@a,$_);
}
# print @a;

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

while($seq=$new->next_seq){
	$id = $seq->id;
	$seq=$seq->seq;
	## Parse sequence and ID
	##For | split seq ids
	# @b=split(/\|/,$id);
	# # print "$b[1]\n";
	# $id_hash{$b[1]}=$id;
	# $hash{$b[1]}=$seq;
	# For complete IDs
	$id_hash{$id}=$id;
	$hash{$id}=$seq;
}

foreach $id(@a){
	if (exists $hash{$id} && !defined $h2{$hash{$id}}){
		print ">$id_hash{$id}\n$hash{$id}\n";
		$h2{$hash{$id}}=1;
	}
}
