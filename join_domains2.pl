#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;


$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");		#Skp1 file
while($seq=$new->next_seq){
	@a=split(/_/,$seq->id);
	if ($a[0]=~/^$/){
		next;
	}
	# print "$a[0]\n";
	# $p="\"".$a[0]."\"";
	# print "$p\n";
	# $a[0]=~s/^\s+|\s+$//g;
	push (@{$hash{$a[0]}}, $seq->seq);
}
# print Dumper(\%hash);
# foreach ( @{$hash{"Malus-domestica"}} )  {
#         print "$_\n";
#     }

# =cc
$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");		#Fbox file
while($seq=$new->next_seq){
	# $i=1;
	@z=split(/_/,$seq->id);
	if ($z[0]=~/^$/){
		next;
	}
	# print "$z[0]\n";

	foreach $sp (@{$hash{$z[0]}}){
		if (exists $no{$z[0]}){
			$no{$z[0]}++;
		}else{
			$no{$z[0]}=1;
		}
		# print "$z[0]\n";
		print ">",$z[0],"_",$no{$z[0]},"\n",$seq->seq,"X","$sp\n";
		$i++;
	}
}
