#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
# sort { $a <=> $b } keys(%hash)

# Larger this number more number of residues in consensus sequence
# How many more gaps than residues
# No of seq/3, round down - stringent 
$gap_tol=0.4; #0.4

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	## multiple sequence alignment

while($seq=$new->next_seq){
	$id=$seq->id;
	$s=$seq->seq;
	$i=0;
	# print "$s\n";
	$len=length($s);
	# print "$len\n";
	@a=split(//,$s);
	foreach $pos(@a){
		$i++;
		$ct{$i}{$pos}++;
		if ($pos eq '-'){
			$ct_gap{$i}++;
		}else{
			$ct_res{$i}++;
		}
		if (!exists $res{$pos}){
			$res{$pos}=1;
		}
		# push (@len,$i);
	}
}
# foreach $pos(sort keys %res){
# 	print "$pos\n";
# }

# print Dumper(\%ct);
# print Dumper(\%res);

# # print Dumper(\%ct);
# foreach $i(@len){
# 	foreach $pos(@a){
# 		# print "$i\t$pos\n";
# 		if (exists $ct{$i}{$pos}){
# 			# print "$i = $pos = $ct{$i}{$pos}\n";
# 		}
# 	}
# }

($cons,@best_res,@best_score)=Consensus($len,\%res,\%ct,\%ct_gap,\%ct_res);
print $cons,"\n",length($cons),"\n";
$cons=~s/-//g;
print $cons,"\n",length($cons),"\n";


# foreach $r(@best_score){
# 	print "$r";
# }
# print "\n";
# print Dumper(\%ct);

# my (@sub_res,@sub_score)=Consensus(\@len,\@a,\%ct);
# print Dumper(\%ct);

# foreach $i(@len){
# 	print "$i|$res{$i}|$score{$i}|--\t";
# 	for ($j=1;$j<22;$j++){
# 		foreach $pos(@a){
# 			if (exists $sub_ct{$i}{$pos}){
# 				print "$pos|$sub_ct{$i}{$pos}{$j}\t";
# 			}
# 		}
# 	}
# 	print "\n";
# }
# for ($i=1;$i<=$#final_res;$i++){
# 	print "$i\t$final_res[$i]\t$res_scores[$i]\n";
# }
# print "$cons\n";
# print "\n";
# print "$sec_cons\n";
# print "\n";

sub Consensus {
	my ($one,$two,$three,$four,$five)=@_;
	my $len=$one;
	print "$len\n";
	my %res=%{$two};
	my %ct=%{$three};
	my %ct_gap=%{$four};
	my %ct_res=%{$five};
# print Dumper(\%ct);

	# foreach $i(@len){
	for (my $i=1;$i<=$len;$i++){
		$score=0;
		# $sub_score=0;
		# $j=0;
		# $res='';
		if ($ct_gap{$i} > 0){
			if ($ct_res{$i}/$ct_gap{$i} >= $gap_tol){
				$ct{$i}{'-'}=0;
			}
		}
		foreach $pos(sort keys %res){
			# print "$i\t$pos\n";
			if (!exists $ct{$i}{$pos}){
				$ct{$i}{$pos}=0;
			}
			if ($ct{$i}{$pos} >= $score){
				# print "$i\t$pos\t$ct{$i}{$pos}\t$score\n";
				$score = $ct{$i}{$pos};
				# $score{$i} = $ct{$i}{$pos};
				# $score=$score{$i};
				$cons_res=$pos;
				# $cons_res{$i}=$pos;
				# next;
			# }elsif ($score > 0 && ($ct{$i}{$pos} = $score) && ($cons_res eq '-')){
			# 	$con_res=$pos;
			# }elsif ($ct{$i}{$pos} <= $score and $ct{$i}{$pos} > $score-10 and $score > 20){
			# 	#$j++;
			# 	# $new_ct{$i}{$pos}{$j}=$ct{$i}{$pos};
			# 	# $new_ct{$i}{$pos}=$ct{$i}{$pos};
			# 	# push(@otehrs, $score);
			# 	if ($ct{$i}{$pos} > $sub_score){
			# 		$sub_ct{$i}{$pos}=$ct{$i}{$pos};
			# 		$sub_score= $sub_ct{$i}{$pos};
			# 		$sub_res=$pos;
			# 	}
			# }else{
			# 	next;
			}

# print Dumper(\%ct);

		}
		# print "$cons_res\t\n";
		$ct{$i}{$cons_res}=0;
		$cons.=$cons_res;
		push(@final_res,$cons_res);
		push(@res_scores,$score);
		# print "$cons\n";
		#$sub_cons.=$sub_res;
		# foreach $r(@res_score){
		# 	print "$r";
		# }
		# print "\n";
	}
# print Dumper(\%ct);

	return ($cons, @final_res, @res_scores);
}
