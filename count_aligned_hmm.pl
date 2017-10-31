#! /usr/bin/perl -w 

## Count aligned positions from hmmalign output stockholm to fasta file (stockholm2fasta.pl)
## perl ~/rhil_project/scripts/temp2.pl gt32_refsel.1e10.hmmalign.fa len|sort -t$'\t' -k2,2nr|cat -n|less

use Bio::SeqIO;
use Data::Dumper;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");

while($seq=$new->next_seq){
  $i=$seq->id;
  $d=$seq->desc;
  $s=$seq->seq;
  my $result = 0;
  my $align = 0;
  $result++ while($s =~ m/\p{Uppercase}/g);
  if ($ARGV[1]=~/len/){
  	print "$i $d\t$result\n";
  }else{
  	@a=split(//,$s);
  	foreach $res(@a){
  		if ($res=~/[A-Z]/){
  			$align++;
  			$store_res{$align}{$i}=$res;
  		}
  	}
  	push (@idlist,$i);
  	push (@desclist,$d);
  }
}
=ccc
for ($j=0;$j<scalar(@idlist);$j++){
	print ">$idlist[$j] $desclist[$j]\n";
	foreach $res(sort {$a<=>$b} keys %store_res){
		print "$store_res{$res}{$idlist[$j]}";
	}
	print "\n";
}
=ccc
for ($j=0;$j<scalar(@idlist);$j++){
	# foreach $res(sort {$a<=>$b} keys %store_res){
	if ($store_res{$ARGV[1]}{$idlist[$j]}=~/E/){
		print "$idlist[$j] $desclist[$j]\t$res\n";
	}
}
# print Dumper(\%store_res);