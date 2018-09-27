#! /usr/bin/perl

use Data::Dumper;

# works only if you wish to print a single cma file
# cannot generate multicma files
# If input is multicma files, careful of cma separator lines: grep '^\['

# Change the length of the profile print out

# Options Input:
# $ARGV[0] = input cma file
# $ARGV[1]
#	=	fa 		:print fasta sequence
#	=	len 	:filter sequences by length of aligned positions
#				$ARGV[2]=minimum length; $ARGV[3]=maximum length
#				$search for line with /change length/ and change min and max length
#	=	sel 	:print selected sequences
#				$ARGV[2] = input list of seq id (no >) (matches full ID)
#				$ARGV[3] (optional) = 'genbank' ; if match only Genbank id aprt of seq id in 
#								2nd col separated by | (eg: GT31|AAQ31451|H.sapiens)
#									= 'pdb'; if match pdb IDs, remove chain ID
#									= 'nrtx'; if match regex to description
#	=	sel-man	:print selected sequences with manual selections
#				$ARGV[2] = input pattern to match
#				$ search for line with /match unmatch/ and change regex
#	=	unsel	:remove selected sequences
#				$ARGV[2] = input list of seq id (no >)
#	=	order 	:order cma sequences based on input list
#				$ARGV[2] = input list of ordered seq id (no >)
#	=	sep 	:Separate single cma file from multicma concatenated file
#				$ search for line with /Specify grp_num/ and change group_num integer
#	= 	[0-9]+	:
#				$ no ARGV[2]
#				$ARGV[2] = [0-9]+ search 2 positions
#				$ esearch for lines with /change residue/ and change residue type to search for
#	=	num 	:print list of residue position numbering
#	=	rem-gap	:remove gaps at the end of sequences
#	=	compare	:Compare 2nd cma file to the first and select the best alignment(longest)
#				 $ARGV[2] = cma filenames
#					$ARGV[3] = 'print' -list whether sequences are same in 2 cma files
#				 $ARGV[2] =list
#					$ARGV[3] = filename with list of cma files to compare
#	=	list	:list aligned position length of each seqence in cma file
#				 $ARGV[2]=cma file - list lengths of sequences matching previous cma file alongside
#	=	editID	:Edit the IDs of sequences;
#				 $ARGV[2]=tsv of ID mapping (1st col= original ID, 2nd col=new ID)
#	=	rem-dup	: remove sequences with dupliucate IDs
#	=	rem-first	: Remove first sequence of cma file
# Example run:
# perl ~/rhil_project/scripts/parse_cma.pl d102.d104_not.cma unsel tempb

# sub warn {   
# 	no warnings 'once';
#     *other = \&do_some;
# }
# warn();

open(IN,$ARGV[0]);
$id=0;
$grp=0;
$i=0;
while(<IN>){
	chomp;
	if ($_=~/^\[/){
		$grp++;
		$sep1=$_;
		($sep1_1,$num,$sep1_2)=($sep1=~/(.*\()(\d+?)(\).*)/);
	}elsif ($_=~/^\$/){
		$id++;
		($l,$pl)=($_=~/=(\d+)\((\d+)\):/);
		$len{$id}=$l;
		$prof{$id}=$pl;
	}elsif ($_=~/^>/){
		$_=~s/^\s+//g;
		$_=~s/\s+$//g;
		$_=~s/>//;
		@a=split(/ /,$_);
		$main_id=shift @a;
		$desc_id=join ' ',@a;
		if (exists $seq_id_back{$_}){
			$dup_seq_id{$id}=$_;
			$dup_seq_id_back{$_}=$id;
		}else{
			# $seq_id_back{$_}=$id; 
			$seq_id_back{$main_id}=$id; # Changed for order option;Takes id with description separate only id for key
		}
		# $seq_id{$id}=$_;
		$seq_id{$id}=$main_id;
		$desc_hash{$id}=$desc_id;
		# print "##$id\t$seq_id{$id}\n";
		$grp_num{$id}=$grp;
	}elsif ($_=~/^\{/ || $_=~/^[A-Za-z]/){
		if (exists ($dup_seq_id{$id})){
			$prev_ct=$aligned_ct{$seq_id_back{$dup_seq_id{$id}}};
			$new_ct = () = $_ =~ m/\p{Uppercase}/g;
			if ($new_ct<=$prev_ct){
				$rem_id[$i]=$id;
			}else{
				$rem_id[$i]=$seq_id_back{$dup_seq_id{$id}};
				$seq_id_back{$dup_seq_id{$id}}=$dup_seq_id_back{$dup_seq_id{$id}};
				$direct_seq{$seq_id{$id}}=$_;
			}
			$i++;
		}else{
			$direct_seq{$seq_id{$id}}=$_;
		}
		$seq{$id}=$_;
		$_=~s/[{}()\-\*]//g;
		$aln = () = $_ =~ m/\p{Uppercase}/g;
		$aligned_ct{$id}=$aln;
		$_=uc($_);
		$faseq{$id}=$_;
	}elsif ($_=~/^\(/){
		$sep2=$_;
		($prof_len)=($_=~/^\(([0-9]+?)\)/);
		# $prof{$id}=$prof_len;
	}elsif ($_=~/^_\d/){
		$sep3=$_;
	}elsif ($_=~/^$/){
		next;
	}else{
		print "ERROR: Don't know what to do with this line\n";
		print "$_\n";
	}
}
close IN;
$ct=0;
# print Dumper(\%aligned_ct);
# print Dumper(\%dup_seq_id);
# print $sep1_1,"\n";
# print $sep1_2,"\n";
# print "Sep2=",$sep2,"\n";
# print Dumper(\%seq_id);
# print Dumper(\%seq_id);

## Remove duplicate IDs ##########################################
delete @len{@rem_id};
delete @prof{@rem_id};
delete @seq_id{@rem_id};
delete @grp_num{@rem_id};
delete @seq{@rem_id};
delete @aligned_ct{@rem_id};
delete @faseq{@rem_id};

# print Dumper(\%seq_id);

# foreach $id(@rem_id){
	# print "$id $len{$id} $prof{$id} $seq_id{$id} $grp_num{$id} $seq{$id} $aligned_ct{$id} $faseq{$id}\n";
# }
## print in fasta format #########################################
if ($ARGV[1] eq 'fa'){
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		print ">$seq_id{$id}\n$faseq{$id}\n";
	}
}
## End print fasta ###############################################

## Print selected sequences from ID file #########################
if ($ARGV[1] eq 'sel'){
	open(IN2,$ARGV[2]);
	while(<IN2>){
  		chomp $_;
  		# print "%%%$_***\n";
  		# @a=split(/\|/,$_);
  		# @a=split(/ /,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# print "$a[0]\n";
		$id_hash{$_}=1;
		$id_hash{$_}=$_;
  		# $id_hash{$a[0]}=$_;
	}
	# print Dumper(\%id_hash);
	foreach $id(sort { $a <=> $b } keys(%len)){
		### If id needs to be split
		# @a=split(/\|/,$seq_id{$id});
		# print "$seq_id{$id}\n";
		# print "$a[1]\n";
		# if (defined $id_hash{$a[1]} && (!(defined($print_hash{$seq_id{$id}})))){
		$fin_id=$seq_id{$id};
		# print "***$fin_id\n";
		if (exists ($ARGV[3])){
			if ($ARGV[3] eq 'genbank'){	# Specific for CAZy idedit sequences
				@a=split(/\|/,$fin_id);
				$test_id=$a[1];
			}elsif ($ARGV[3] eq 'pdb'){	# Specific for CAZy idedit sequences
				@a=split(/_/,$fin_id);
				$test_id=$a[0];
			}elsif ($ARGV[3] eq 'nrtx'){
				$seq_id{$id}=$main_id;
				$$desc_hash{$id}=$desc_id;
				($test_id)=($desc_hash{$id}=~/<([A-Za-z ]+?)\([ABEFMV]\)>/);
				if ($test_id=~/viruses/){
					$test_id="Virus";
				}
				# print "$test_id\n";
			}
		}else {
			@b=split(/ /,$fin_id);
			# print "$b[0]\n";
			$test_id=$b[0];
			# $id_hash{$fin_id}=1;
			# print "===$fin_id\t$test_id\n";
		}
		# print "$fin_id\n";
		# if (defined $id_hash{$seq_id{$id}}){	# IF NOT CARE ABOUT REDUNDANT
		# if (defined $id_hash{$fin_id} && (!(defined($print_hash{$fin_id})))){
		if (defined $id_hash{$test_id} && ($ARGV[3] eq 'nrtx' || !(defined($print_hash{$test_id})))){
		# if (defined $id_hash{$b[0]}){
			# print "$fin_id\n";
			$print_hash{$test_id}=1;
			$ct++;
			$out .= "\$$ct=$len{$id}($prof{$id}):\n";
			#$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
			# $out .= ">$id_hash{$fin_id}\n$seq{$id}\n\n";
			$out .= ">$fin_id $desc_hash{$id}\n$seq{$id}\n\n";
		}#else{
			### If need to control for length
		# 	if ($len{$id} >=210 and $len{$id} < 600){
		# 		$out .= "\$$ct=$len{$id}(156)\n";
		# 		$out .= "$seq_id{$id}\n$seq{$id}\n\n";
		# 		$ct++;
		# 	}
		# }
	}
	foreach $id(sort keys(%id_hash)){
		if (!(defined($print_hash{$id}))){
			print "ERROR: NOT FOUND seq $id\n";
		}
	}
	
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

## Manually specify selections ###################################

if ($ARGV[1] eq 'sel-man'){
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# if ($seq_id{$id} =~/GT2-A/ || $seq_id{$id} =~/GT27-A/ || $seq_id{$id} !~/GT2-A/){		### Specify match unmatch here
		 if ($seq_id{$id} =~/\Q$ARGV[2]/){		### Specify match unmatch here
		# if ($seq_id{$id} !~/consensus/){		### Specify match unmatch here
		# if ($seq_id{$id} =~/GT16-u/){		### Specify match unmatch here
			$ct++;
			$out .= "\$$ct=$len{$id}($prof{$id}):\n";
			$out .= ">$seq_id{$id} $desc_hash{$id}\n$seq{$id}\n\n";
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

## Remove sequences ending in gaps ###################################

if ($ARGV[1] eq 'rem-gap'){
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# if ($seq_id{$id} =~/GT60-u/ || $seq_id{$id} =~/GT27-A/ || $seq_id{$id} !~/GT2-A/){
		# print "$seq{$id}\n";
		if ($seq{$id} !~/-\(\)\}\*$/){
			# print "$seq{$id}\n";
			$ct++;
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

## Remove selected sequences from file ##########
if ($ARGV[1] eq 'unsel'){
	open(IN2,$ARGV[2]);
	while(<IN2>){
  		chomp $_;
  		$_=~s/^\s+//;
  		$_=~s/\s+$//;
  		## If need to split id
  		# @a=split(/\t/,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# $id_hash{$a[0]}=1;
  		$id_hash{$_}=1;
	}
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# @a=split(/\|/,$seq_id{$id});
		# if (!(defined $id_hash{$seq_id{$id}}) && (!(defined($print_hash{$seq_id{$id}})))){
		if (!(defined $id_hash{$seq_id{$id}})){
			$ct++;
			$print_hash{$seq_id{$id}}=1;
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id} $desc_hash{$id}\n$direct_seq{$seq_id{$id}}\n\n";
		}#else{
			## If need to control for length of sequences
		# 	if ($len{$id} >=210 and $len{$id} < 600){
		# 		$out .= "\$$ct=$len{$id}(156)\n";
		# 		$out .= "$seq_id{$id}\n$seq{$id}\n\n";
		# 		$ct++;
		# 	}
		# }
	}
	
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

##################################################################

## Order cma sequences based on a template order file
if ($ARGV[1] eq 'order'){
	$ct=0;
	open(IN2,$ARGV[2]);
	while(<IN2>){
  		chomp $_;
		$ct++;
  		$out .= "\$$ct=$len{$seq_id_back{$_}}($prof_len):\n";
		$out .= ">$seq_id{$seq_id_back{$_}}\n$seq{$seq_id_back{$_}}\n\n";
  		# @a=split(/\t/,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# $id_hash{$a[0]}=1;
  		$id_hash{$_}=1;
	}
# 	foreach $id(sort { $a <=> $b } keys(%len)){
# 		# @a=split(/\|/,$seq_id{$id});
# 		print "$seq_id{$id}\n";
# 		if ($seq_id{$id} =~//){
# 			$out .= "\$$ct=$len{$id}(302):\n";
# 			$out .= "$seq_id{$id}\n$seq{$id}\n\n";
# 			$ct++;
# 		}
	# }
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

##################################################################

## Filter by length ##############################################
# =ccc
if ($ARGV[1] eq 'len'){
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		@a=split(/\|/,$seq_id{$id});
		# if ($a[2]=~/pdb/){
		# 	$ct++;
		# 	$out .= "\$$ct=$len{$id}($prof_len):\n";
		# 	$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
		# }else{
			if ($aligned_ct{$id} >= $ARGV[2] and $aligned_ct{$id} < $ARGV[3]){		# change length
				$ct++;
				$out .= "\$$ct=$len{$id}($prof_len):\n";
				$out .= ">$seq_id{$id} $desc_hash{$id}\n$seq{$id}\n\n";
			# }
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}
# =cut
## End filter by length##############################################

## Print specific separate cma files from a file with multiple cma files in fasta
if ($ARGV[1] eq 'sep'){
	# print "blash";
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		if ($grp_num{$id} == 47 || $grp_num{$id} == 48){			# Specify grp_num from multicma file here
			# print ">$seq_id{$id}\n$faseq{$id}\n";
			# $print_hash{$fin_id}=1;
			$ct++;
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
		}#else{
			### If need to control for length
		# 	if ($len{$id} >=210 and $len{$id} < 600){
		# 		$out .= "\$$ct=$len{$id}(156)\n";
		# 		$out .= "$seq_id{$id}\n$seq{$id}\n\n";
		# 		$ct++;
		# 	}
		# }
	}
	
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}
## End Separate specific group #####################################

# print Dumper(\%seq_id);

#### edit sequence IDs #############################################

if ($ARGV[1] eq 'editID'){
	$ct=0;
	open(IN2,$ARGV[2]);
	while(<IN2>){
  		chomp $_;
  		@a=split(/\t/,$_);
  		$new_ID{$a[0]}=$a[1];
  		# print "$a[0]\n";
	}
	foreach $id(sort { $a <=> $b } keys(%len)){
		$ct++;
		$out .= "\$$ct=$len{$id}($prof{$id}):\n";
		# print "$seq_id{$id}\n";
		if (exists $new_ID{$seq_id{$id}}){		### Specify match unmatch here
			$out .= ">$new_ID{$seq_id{$id}} $desc_hash{$id}\n$seq{$id}\n\n";
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

## End editID #####################################################

########## List length of aligned positions ##############
if ($ARGV[1] eq 'list'){
	foreach $id(sort { $a <=> $b } keys(%len)){
		print "$seq_id{$id}\t$aligned_ct{$id}\n";
	}
}
########## End List length ###############################
if ($ARGV[1] eq 'rem-first'){
	foreach $id(sort { $a <=> $b } keys(%len)){
		# print "$seq_id{$id}\n";
		if ($id != 1){		### Specify match unmatch here
			$ct++;
			$out .= "\$$ct=$len{$id}($prof{$id}):\n";
			$out .= ">$seq_id{$id} $desc_hash{$id}\n$seq{$id}\n\n";
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}
########## Remove first sequence ###################

########## End Remove first sequence ###################

##### Compare cma files to get the best (longest) alignment #############
$qi=0;
if ($ARGV[1] eq 'compare'){
	$qid=0;
	if ($ARGV[2] eq 'list'){
		open(IN3,$ARGV[3]);		# file with a list of cma filenames with proper path
		while(<IN3>){
			chomp;
			# print $_;
			push @infiles, $_;
		}
		close IN3;
	}else{
		$infiles[0]=$ARGV[2];
	}
	# print "$ARGV[2]",@infiles;
	foreach $file(@infiles){
		open(IN2,$file);
		while(<IN2>){
			chomp;
			if ($_=~/^\$/){
				$qid++;
				($ql,$qpl)=($_=~/=(\d+)\((\d+)\):/);
				$qlen{$qid}=$ql;
				$qprof{$qid}=$qpl;
			}elsif ($_=~/^>/){
				$_=~s/^\s+//g;
				$_=~s/\s+$//g;
				$_=~s/>//;
				if (exists $qseq_id_back{$_}){
					$qdup_seq_id{$qid}=$_;
					$qdup_seq_id_back{$_}=$qid;
				}else{
					$qseq_id_back{$_}=$qid;
				}
				$qseq_id{$qid}=$_;
			}elsif ($_=~/^\{/ || $_=~/^[A-Za-z]/){
				if (exists ($qdup_seq_id{$qid})){
					$prev_ct=$qaligned_ct{$qseq_id_back{$qdup_seq_id{$qid}}};
					$new_ct = () = $_ =~ m/\p{Uppercase}/g;
					if ($new_ct<=$prev_ct){
						$qrem_id[$qi]=$qid;
					}else{
						$qrem_id[$qi]=$qseq_id_back{$qdup_seq_id{$qid}};
						$qseq_id_back{$qdup_seq_id{$qid}}=$qdup_seq_id_back{$qdup_seq_id{$qid}};
					}
					$qi++;
				}
				$qseq{$qid}=$_;
				$_=~s/[{}()\-\*]//g;
				$aln = () = $_ =~ m/\p{Uppercase}/g;
				$qaligned_ct{$qid}=$aln;
				$_=uc($_);
			}
		}
		close IN2;
	}
	delete @qlen{@qrem_id};
	delete @qprof{@qrem_id};
	delete @qseq_id{@qrem_id};
	delete @qseq{@qrem_id};
	delete @qaligned_ct{@qrem_id};
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		$ct++;
		if (exists $qseq_id_back{$seq_id{$id}}) {
			$checked{$qseq_id_back{$seq_id{$id}}}=1;
			$main_aln=$aligned_ct{$id};
			$sub_aln=$qaligned_ct{$qseq_id_back{$seq_id{$id}}};
			# print "$main_aln\t$id\t$seq_id{$id}\n";
			if (main_aln>=$sub_aln){
				$out .= "\$$ct=$len{$id}($prof_len):\n";
				$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
			}else{
				$sel=$qseq_id_back{$seq_id{$id}};
				$out .= "\$$ct=$qlen{$sel}($prof_len):\n";
				$out .= ">$qseq_id{$sel}\n$qseq{$sel}\n\n";
			}
			if ($seq{$id} eq $qseq{$qseq_id_back{$seq_id{$id}}}){
				$result_list .= "$seq_id{$id}\t$qseq_id{$qseq_id_back{$seq_id{$id}}}\tSame\n";
			}else{
				$result_list .= "$seq_id{$id}\t$qseq_id{$qseq_id_back{$seq_id{$id}}}\tDifferent\n";
			}
			# print "hi,$aligned_ct{$id},$qaligned_ct{$qseq_id_back{$seq_id{$id}}},$seq_id{$id},$qseq_id_back{$seq_id{$id}}\n";
		}else{
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
			$result_list .= "$seq_id{$id}\t-\tNot_present\n";
		}
	}
	foreach $qid(sort { $a <=> $b } keys(%qlen)){
		if (!exists $checked{$qid}){
			$ct++;
			$out .= "\$$ct=$qlen{$qid}($prof_len):\n";
			$out .= ">$qseq_id{$qid}\n$qseq{$qid}\n\n";
		}
	}
	if ($ARGV[3] eq 'print'){
		print $result_list;
	}else{
		print "$sep1_1$ct$sep1_2\n$sep2\n";
		print $out;
		print "$sep3\n";
	}
}

########## End Compare ###################################

## Check specific residue positions ################################
if ($ARGV[1]=~/[0-9]+/ and !exists($ARGV[2])){
	$query_pos = $ARGV[1];
	$ct=1;
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		$pos=0;
		@b=split(//,$seq{$id});
		foreach $res(@b){
			if ($res=~/[A-Z-]/){
				$pos++;
			}
			# print "$pos\t$res\n";
			if ($pos==$query_pos and $res eq 'H'){		# change residue
				$ct++;
				$out .= "\$$ct=$len{$id}($prof_len):\n";
				$out .= ">$seq_id{$id}\n$seq{$id}\n\n";

			}
		}
	}	
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}

if ($ARGV[1] eq 'num'){
	# $query_pos = $ARGV[1];
	#print "$sep1\n$sep2\n";
	$ct=1;
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		$pos=0;
		@b=split(//,$seq{$id});
		print "$seq_id{$id}\n";
		foreach $res(@b){
			if ($res=~/[A-Z-]/){
				$pos++;
			}
			print "$pos\t$res\n";
			# if ($pos==$query_pos and $res eq 'H'){
			# 	# print "\$$ct=$len{$id}(156)\n";
			# 	# print "$seq_id{$id}\n$seq{$id}\n\n";
			# 	$ct++;
			# }
		}
	}	
print "$sep3\n";
}

if ($ARGV[1]=~/[0-9]+/ and $ARGV[2]=~/[0-9]+/){
	$query_pos = $ARGV[1];
	$query_pos2= $ARGV[2];
	print "$sep1\n$sep2\n";
	$ct=1;
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		$pos=0;
		$check1=0;
		@b=split(//,$seq{$id});
		foreach $res(@b){
			if ($res=~/[A-Z-]/){
				$pos++;
			}
			# print "$pos\t$res\n";
			if ($pos==$query_pos and $res eq 'H'){		# change residue
				$check1=1;
			}
			if ($check1==1 and $pos==$query_pos2 and $res eq 'H'){		# change residue
				print "\$$ct=$len{$id}($prof_len):\n";
				print ">$seq_id{$id}\n$seq{$id}\n\n";
				$ct++;
			}
		}
	}	
print "$sep3\n";
}

##### End Check specific residue positions ##############################

########## Remove duplicated sequences ###################
if ($ARGV[1] eq 'rem-dup'){
	foreach $id(sort { $a <=> $b } keys(%len)){
		if (!(defined($print_hash{$seq_id{$id}}))){
			$ct++;
			$print_hash{$seq_id{$id}}=1;
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id} $desc_hash{$id}\n$direct_seq{$seq_id{$id}}\n\n";
		}
	}
	print "$sep1_1$ct$sep1_2\n$sep2\n";
	print $out;
	print "$sep3\n";
}