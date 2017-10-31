#! /usr/bin/perl -w

use Bio::SeqIO;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	# the aligned fa file
while($seq=$new->next_seq){
	$i=$seq->id;
  	$s=$seq->seq;
#  	@a=split(/\|/,$i);
	$aln_seq{$i}=$s;
	$s=~s/-//g;
	$aln_nogaps{$i}=$s;
}

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");	# the full length aligned or unaligned fa file
while($seq=$new->next_seq){
	$id=$seq->id;
  	$seq=$seq->seq;
  	if (defined $aln_nogaps{$id}){
  		# print "$id----------------------\n";
		($start,$len,$new_seq)=Parse_sub($seq,$aln_nogaps{$id});
		$end=$start+$len;
		print "$id\t$start\t$end\t$len\n";
	}else{
		print "$id\tNO\n";
	}
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