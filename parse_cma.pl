#! /usr/bin/perl -w 

use Data::Dumper;

# works only if you wish to print a single cma file
# cannot generate multicma files
# If input is multicma files, careful of cma separator lines: grep '^\['

# Change the length of the profile print out

# Options Input:
# $ARGV[0] = input cma file
# $ARGV[1]
#	=	fa 		:print fasta sequence
#	=	len 	:filter sequences by length
#				$search for line with /change length/ and change min and max length
#	=	sel 	:print selected sequences
#				$ARGV[2] = input list of seq id (no >)
#	=	sel-man	:print selected sequences with manual selections
#				$ search for line with /match unmatch/ and change regex
#				$ARGV[2] = input pattern to match
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


# Example run:
# perl ~/rhil_project/scripts/parse_cma.pl d102.d104_not.cma unsel tempb

open(IN,$ARGV[0]);
$id=0;
$grp=0;
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
		$seq_id{$id}=$_;
		# print "##$id\t$seq_id{$id}\n";
		$seq_id_back{$_}=$id;
		$grp_num{$id}=$grp;
	}elsif ($_=~/^\{/ || $_=~/^[A-Za-z]/){
		$seq{$id}=$_;
		$direct_seq{$seq_id{$id}}=$_;
		$_=~s/[{}()\-\*]//g;
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
$ct=0;
# print $sep1_1,"\n";
# print $sep1_2,"\n";
# print "Sep2=",$sep2,"\n";
# print Dumper(\%seq_id);

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
		if ($fin_id=~/^GT/){	# Specific for CAZy idedit sequences
			@a=split(/\|/,$fin_id);
			$test_id=$a[1];
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
		if (defined $id_hash{$test_id} && (!(defined($print_hash{$fin_id})))){
		# if (defined $id_hash{$b[0]}){
			# print "$fin_id\n";
			#$print_hash{$fin_id}=1;
			$ct++;
			$out .= "\$$ct=$len{$id}($prof{$id}):\n";
			#$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
			# $out .= ">$id_hash{$fin_id}\n$seq{$id}\n\n";
			$out .= ">$fin_id\n$seq{$id}\n\n";
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
			$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
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
			$out .= ">$seq_id{$id}\n$direct_seq{$seq_id{$id}}\n\n";
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
		if ($a[2]=~/pdb/){
			$ct++;
			$out .= "\$$ct=$len{$id}($prof_len):\n";
			$out .= ">$seq_id{$id}\n$seq{$id}\n\n";
		}else{
			if ($len{$id} >= 140 and $len{$id} < 800){		# change length
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

