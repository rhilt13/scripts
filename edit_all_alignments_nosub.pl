#! /usr/bin/perl -w 

use Data::Dumper;
use Bio::SeqIO;

# open(IN,$ARGV[0]);		# GT_sub_fam.txt
# while(<IN>){
# 	chomp;
# 	$hash{$_}=1;
# }
# $control=0;

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");	# .nogaps

while($seq=$new->next_seq){
	# $control++;
	# if ($control<3){next;}
	# if ($control==4){exit;}
	$i=$seq->id;
	$s=$seq->seq;
	# print "$i\t$control\n";
	@a=split(/\|/,$i);
	# print scalar(@a);
	# print "\n";
# =ccc
	# print "$a[1]\n";
	if (scalar(@a)==2){
		next;
	}elsif (scalar(@a)==3){
		# next;
		$filename=$ARGV[0]."/".$a[1].".FASTA.press";
		# print "$filename\n";
		$new1=Bio::SeqIO->new(-file=>"$filename", -format=>"fasta");
# print "aa\n";
		open(OUT,">$filename.edit");
		while($seq1=$new1->next_seq){
			# print $seq1->id,"\n";
			$i1=$seq1->id;
			$s1=$seq1->seq;
			if ($i1 eq $i){
				($start, $len, $new_seq)=Parse_sub($s1,$s);
# print "$s1\n$s\n";
#print ">$i1\n$new_seq\n";
				print OUT ">$i1\n$new_seq\n";
			}else{
				$new_seq=substr $s1, $start, $len;
				print OUT ">$i1\n$new_seq\n";
			}
		}
		close OUT;
		# }
	}elsif (scalar(@a)==4){
		next;
	}
}

sub Parse_sub {
	@loc=();
	($s1,$s)=@_;
	@gaps=();
	$s1_nogap=$s1;
	$s1_nogap=~s/-//g;
	# print "NOGAP: $s1_nogap\nGAP  : $s1\n";
	$g="-";
	@gap_pos= all_match_positions($g,$s1);
	# print "NEED : $s\n";
#print "\@gap_pos\n";
	@loc= all_match_positions($s,$s1_nogap);
	if (!@loc){
		print "ERROR==> Cound not match $i1\n";
		print "ALIGNED :$s\nORIGINAL:$s1_nogap\n";
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
#print "@ret\n";
    return @ret;
}
