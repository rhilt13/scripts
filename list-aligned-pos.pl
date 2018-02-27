#! /usr/bin/perl -w

use Bio::SeqIO;
use Data::Dumper;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");        # FASTA msa file with only 2 sequences
$z=0;
$j=0;	# Start position of alignment seq 1;
$k=0;	# Start position of alignment seq 2;
while($seq=$new->next_seq){
        $z++;
        $id=$seq->id;
        $s=$seq->seq;
        $i=0;
        push(@seqname, $id);
        # print "$s\n";
        $len=length($s);
        # print "$len\n";
        @a=split(//,$s);
        foreach $pos(@a){
            $i++;
            $hash{$i}=1;
            $res{$id}{$i}=$pos;
            if ($pos eq '-'){
                $ct_gap{$i}++;
            }else{
            	$j++;
                $ct_res{$i}++;
            }
            $num{$id}{$i}=$j;
        }
        $j=$k;
}
# print Dumper(\%res);

foreach $n(sort {$a<=>$b} keys %hash){
	foreach $id(@seqname){
		print "$num{$id}{$n}\t$res{$id}{$n}\t";
	}
	print "\n";
}
