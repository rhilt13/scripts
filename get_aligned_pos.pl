#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
# sort { $a <=> $b } keys(%hash)

#
# get_aligned_pos.pl <alignment_file> a cons aln 	# To get insert counts with aligned position using consensus at top
# get_aligned_pos.pl <alignment_file> a cons 	# To get aligned position using consensus at top
# get_aligned_pos.pl <alignment_file> a 	 	# To get aligned position by generating consensus based on gap_tol
# get_aligned_pos.pl <alignment_file> 		 	# To display consensus sequence

#

# ARGV[0]= multiple sequence alignment file
# ARGV[1]=a # if want to print only aligned positions else leave blank

# Larger this number more number of residues in consensus sequence
# How many more gaps than residues
# No of seq/3, round down - stringent 
$gap_tol=0.7; 

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");	## multiple sequence alignment
$z=0;
while($seq=$new->next_seq){
	$z++;
	$id=$seq->id;
	$s=$seq->seq;
	if ($z==1){
		$first=$s;
	}
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

if ($ARGV[1]=~/a/){
	if ($ARGV[2]=~/cons/){
		@cons_arr=split(//,$first);
	}else{
		@cons_arr=split(//,$cons);
	}
	$pos_ct=1;
	foreach $align_pos(@cons_arr){
		if ($align_pos ne '-'){
			$print_hash{$pos_ct}=1;
		}
		$pos_ct++;
	}
	$new1=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");        ## multiple sequence alignment
	while($seq=$new1->next_seq){
	    $id=$seq->id;
		$desc=$seq->desc;
	    $s=$seq->seq;
	    $i=1;
	    # print "$s\n";
	    $len=length($s);
	    print ">$id\n";
	    @a=split(//,$s);
		foreach $pos(@a){
			# #if ($ARGV[3]=~/aln/){
	  #      		if (exists ($print_hash{$i})){
	  #      			if ($ct_ins > 5){
	  #      				if ($ct_ins > 9){
	  #      					print "*($ct_ins)*";
	  #      				}else{
	  #      					print "*($ct_ins)**";
	  #      				}
	  #      				$ct_ins=0;
	  #      			}
			# 		print "$pos";
			# 	}elsif($pos!~/-/){
			# 		$ct_ins+=1;
			# 	}
			# #}else{
				if (exists ($print_hash{$i})){
					print "$pos";
				}	
			#}
			$i++;
		}
		print "\n";
	}
}else{
	print length($cons),"\n",$cons,"\n";
	$cons=~s/-//g;
	print length($cons),"\n",$cons,"\n";
}

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
	#print "$len\n";
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
