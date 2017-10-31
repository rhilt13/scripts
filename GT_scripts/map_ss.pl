#!/usr/bin/perl -w

use Bio::SeqIO;
use Data::Dumper;
#perl ~/rhil_project/GT/scripts/map_ss.pl ../../../gta_revise6/profile/gt_rev6.fas.fa gta_cons.fa.sspmap ../../../gta_revise6/profile/order > gt_rev6_sspred.fa

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	# the aligned fa file
while($seq=$new->next_seq){
	$i=$seq->id;
  	$s=$seq->seq;
#  	@a=split(/\|/,$i);
	$aln_seq{$i}=$s;
	$s=~s/-//g;
	$aln_nogaps{$i}=$s;
}
#print Dumper(\%aln_seq);
# print Dumper(\%aln_nogaps);

open(IN2,$ARGV[1]);	# ssp file with nogaps full length sequences and ssp predictions for all the sequences.
while(<IN2>){
	chomp;
	if ($_=~/^>/){
		$ns1="";
		$ns1_ssp="";
		@a=split(/\t/,$_);
		($id)=($a[0]=~/^>(.*)$/);
		$seq=$a[1];
		# print "$id\n$aln_seq{$id}\n";
		($start,$len,$new_seq)=Parse_sub($seq,$aln_nogaps{$id});
		$start+=1;
		$st{$id}=$start;
		$len{$id}=$len;
		$l1=length($seq);
		$l2=length($aln_seq{$id});
		$l3=length($aln_nogaps{$id});
		$l4=length($new_seq);
		### To check where things are going wrong
		 # print ">ID:$id\nSEQ($l1):$seq\nALIGN_SEQ($l2):$aln_seq{$id}\nALIGN_SEQ_NOGAPS($l3):$aln_nogaps{$id}\nSTART:$start\tLEN:$len\nNEWSEQ($l4):$new_seq\n";
	}else{
		@b=split(/\t/,$_);
 		$pred{$id}{$b[0]}=$b[3];
 		$score{$id}{$b[0]}=$b[2];
	}
}
# print Dumper(\%pred);
open(IN3,$ARGV[2]);	# order file to print alignments in order
while(<IN3>){
	chomp;
	$sid="GT-A|".$_."|consensus";
	@c=split(//,$aln_seq{$sid});
	$ct=$st{$sid};
	foreach $aa(@c){
		# if ($ct<$len{$sid}+$st{$sid}){
			if ($aa=~/^-$/){
				$ss{$sid}.=$aa;
			}else{
				$ss{$sid}.=$pred{$sid}{$ct};
				$ct++;
			}
		# }
	}
	print ">${sid}_ss\n$ss{$sid}\n>$sid\n$aln_seq{$sid}\n";
}
sub Parse_sub {
	@loc=();
	my ($s1,$s)=@_;
	@gaps=();
	$s1_nogap=$s1;
	$s1_nogap=~s/-//g;
	# print "NOGAP: $s1_nogap\nGAP  : $s1\n";
	$g="-";
	@gap_pos= all_match_positions($g,$s1);
	# print "NEED : $s\n";
	@loc= all_match_positions($s,$s1_nogap);
	if (!@loc){
		print "ERROR==> Cound not match $id\n";
		print "ALIGNED:$s\nORIGINAL:$s1_nogap\n";
		exit;
	}
	foreach $m(@loc){
		$start=@$m[0];
		$end=@$m[1];
		# print "@$m[0]---@$m[1]\n";
	}
	# print "$start\t---$end\n";
	foreach $p(@gap_pos){
		push @gaps,@$p[0];
		# print "@$p[0]---@$p[1]\n";
	}
	foreach $g(@gaps){
		if ($start >=$g){
			$start++;
		}
		if ($end >=$g){
			$end++;
		}
	}
	# print "$start\t$end\n";
	# print "\n";
	$len=$end-$start+1;
	$new_seq=substr $s1, $start, $len;
	return ($start, $len, $new_seq);
}

sub all_match_positions {
    my ($regex, $string) = @_;
    my @ret;
    while ($string =~ /($regex)/g) {
        push @ret,[(pos($string)-length $1),pos($string)-1];
    }
    return @ret
}
