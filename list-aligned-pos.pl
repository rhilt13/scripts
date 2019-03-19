#! /usr/bin/perl -w

use Bio::SeqIO;
use Data::Dumper;

# ARGV[0] 	= fasta file with only 2 sequences
#			OR 
#			= fasta file with aligned multiples sequences 
# 			ARGV[1] = fasta file with same sequences unaligned, full-length,...

{
$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");        # FASTA msa file with only 2 sequences or multiple seqs (needs ARGV[1])
$z=0;
$j=0;	# Start position of alignment seq 1;
$k=0;	# Start position of alignment seq 2;
while($seq=$new->next_seq){
        $z++;
        $id=$seq->id;
	# @a=split(/\|/,$id);
	# $id=$a[3];
        $s=$seq->seq;
        $i=0;
        push(@seqname, $id);
        $full_seq{$id}=$s;
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
}
# print Dumper(\%res);
# print @seqname;

{
if (exists $ARGV[1]){
	print "#Seq\tDesc\tRes\tAln_ct\tAln_Res_ct\tAln_Caps_Ct\tCaps_Gaps_cma\tFull_ct\n";
	$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");        # unaligned full length FASTA file (can have multiple seq for same ids associated with isoforms)
	while($seq=$new->next_seq){
        $id=$seq->id;
        $desc=$seq->desc;
        $s=$seq->seq;
        $i=0;
        if (exists $full_seq{$id}){
        	# print "$s\n";
        	($start, $end)=Parse_sub($full_seq{$id},$s);
        	# print "$start, $len, $new_seq\n";
        	@full=split(//,$s);

        	@aln=split(//,$full_seq{$id});
        	for ($c=0;$c<$start;$c++){
        		$d=$c+1;
        		print "$id\t$desc\t$full[$c]\t!\t!\t!\t!\t$d\n";
        	}
        	$pos=$start;
        	$i1=0;
        	$i2=0;
        	$i3=0;
        	$i4=0;
        	foreach $res(@aln){
        		# print "$res***\n";
        		if ($res eq '-'){
        			$i1++;
        			$i4++;
        			print "$id\t$desc\t$res\t$i1\t!\t!\t$i4\t!\n";
        		}elsif ($res=~/^[a-z]$/){
        			$i1++;
        			$i2++;
        			$pos++;
        			print "$id\t$desc\t$res\t$i1\t$i2\t!\t-\t$pos\n";
        		}elsif ($res=~/^[A-Z]$/){
        			$i1++;
        			$i2++;
        			$i3++;
        			$i4++;
        			$pos++;
        			print "$id\t$desc\t$res\t$i1\t$i2\t$i3\t$i4\t$pos\n";
        		}else{
        			print "Unknown residue $res\n";
        		}
        	}
        	$tail=$start+$end;
        	# print "$start,$end,$tail\n";
        	for ($c=$end+1;$c<$#full+1;$c++){
        		$d=$c+1;
        		print "$id\t$desc\t$full[$c]\t!\t!\t!\t!\t$d\n";
        	}
        }
    }
}else{
	foreach $n(sort {$a<=>$b} keys %hash){
		foreach $id(@seqname){
			print "$num{$id}{$n}\t$res{$id}{$n}\t";
		}
		print "\n";
	}
}
}

sub Parse_seq_pos {
	my ($id,$sequence,$i,$j,$k)=@_;
        @a=split(//,$sequence);
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
	return(\%hash,\%res,\%num);

}

sub Parse_sub {
	($sq1,$sq)=@_;
	@gaps=();
	$sq1_nogap=$sq1;
	$sq1_nogap=~s/-//g;
	$sq1_nogap2=uc($sq1_nogap);
	# print "NOGAP: $sq1_nogap\nGAP  : $sq1\nEDIT: $sq1_nogap2\nFULL: $sq\n";
	# $g="-";
	# @gap_pos= all_match_positions($g,$s1);
	# print "NEED : $s\n";
	@loc= all_match_positions($sq1_nogap2,$sq);
	# print "@loc\n";
	foreach $m(@loc){
		$st=@$m[0];
		$en=@$m[1];
		# print "@$m[0]---@$m[1]\n";
	}
	# print "$start\t---$end\n";
	# foreach $p(@gap_pos){
	# 	push @gaps,@$p[0];
	# 	# print "@$p[0]---@$p[1]\n";
	# }
	# $gapped_start=$start;
	# $gapped_end=$end;
	# foreach $g(@gaps){
	# 	print "$g\t$gapped_start\n";
	# 	if ($gapped_start >=$g){
	# 		$gapped_start++;

	# 	}
	# 	if ($gapped_end >=$g){
	# 		$gapped_end++;
	# 	}
	# }
	# $gapped_len=$gapped_end-$gapped_start+1;
	# $gapped_seq=substr $sq1, $gapped_start, $gapped_len;
	
	# return ($gapped_start, $gapped_len, $gapped_seq);
	return ($st, $en);
}

sub all_match_positions {
    my ($regex, $string) = @_;
    my @ret;
    while ($string =~ /($regex)/g) {
        push @ret,[(pos($string)-length $1),pos($string)-1];
    }
    return @ret;
}
