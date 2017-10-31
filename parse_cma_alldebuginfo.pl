#! /usr/bin/perl -w 

use Data::Dumper;

# works only if you wish to print a single cma file
# cannot generate multicma files
# If input is multicma files, careful of cma separator lines: grep '^\['

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
		# print 
		# ($sep1_1)=($sep=~/(.*?\()/);
		($sep1_1,$num,$sep1_2)=($sep1=~/(.*\()(\d+?)(\).*)/);
				# print "aa$sep1_1\nbb$num\ncc$sep1_2\n";
	}elsif ($_=~/^\$/){
		$id++;
		($l)=($_=~/=(\d+)\(/);
					# print "$id\t$l\n";
		$len{$id}=$l;
		# $set{$id}=$s;
		# if ($len >=180 and $len < 600){
		# 	$check='ok';
		# 	print "\$$i=$len(156):\n";
		# 	$i++;
		# }else{
		# 	$check='fail';
		# }
	}elsif ($_=~/^>/){
		# if ($check eq 'ok'){
		# 	print "$_\n";
		# }
		$_=~s/^\s+//g;
		$_=~s/\s+$//g;
		$_=~s/>//;
		$seq_id{$id}=$_;
		# print "$seq_id{$id}**\n";
		$seq_id_back{$_}=$id;
		$grp_num{$id}=$grp;
	}elsif ($_=~/^\{/){
	# 	if ($check eq 'ok'){
	# 		print "$_\n";
	# 	}
		# push (@order,$_);
		$seq{$id}=$_;
		$direct_seq{$seq_id{$id}}=$_;
		$_=~s/[{}()\-\*]//g;
		$_=uc($_);
		$faseq{$id}=$_;
	# }elsif ($check eq 'fail'){
	# 	next;
	# 	# print "$_\n";
	}elsif ($_=~/^\(/){
		$sep2=$_;
		# print "$_\n";
	}elsif ($_=~/^_\d/){
		$sep3=$_;
	}
}
# print Dumper(\%seq_id);

## print in fasta format #########################################
if ($ARGV[1] eq 'fa'){
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		print ">$seq_id{$id}\n$faseq{$id}\n";
	}
}
## End print fasta ###############################################

## Print selected sequences ######################################
if ($ARGV[1] eq 'sel'){
	open(IN2,$ARGV[2]);
	while(<IN2>){
  		chomp $_;
  		# @a=split(/\t/,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# print "$a[0]\n";
  		$id_hash{$_}=1;
  		# $id_hash{$a[0]}=1;
	}
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# @a=split(/\|/,$seq_id{$id});
		# print "$seq_id{$id}\n";
		# print "$a[1]\n";
		$fin_id=$seq_id{$id};
		# if (defined $id_hash{$seq_id{$id}}){
		if (defined $id_hash{$fin_id} && (!(defined($print_hash{$fin_id})))){
		# if (defined $id_hash{$a[1]} && (!(defined($print_hash{$seq_id{$id}})))){
			# print "$fin_id\n";
			$print_hash{$fin_id}=1;
			$ct++;
			$out .= "\$$ct=$len{$id}(302):\n";
			$out .= ">$fin_id\n$seq{$id}\n\n";
		}#else{
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

## Manually specify selections ####

if ($ARGV[1] eq 'sel-man'){
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# @a=split(/\|/,$seq_id{$id});
		# print "$seq_id{$id}\n";
		if ($seq_id{$id} =~/GT2-A/){		### Specify match unmatch here
			$ct++;
			$out .= "\$$ct=$len{$id}(302):\n";
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
  		# @a=split(/\t/,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# print "$a[0]\n";
  		$id_hash{$_}=1;
  		# $id_hash{$a[0]}=1;
	}
	$ct=0;
	foreach $id(sort { $a <=> $b } keys(%len)){
		# @a=split(/\|/,$seq_id{$id});
		# print $seq_id{$id};
		# print "$a[1]\n";
		if (!(defined $id_hash{$seq_id{$id}})){
		# if (!(defined $id_hash{$seq_id{$id}}) && (!(defined($print_hash{$seq_id{$id}})))){
			$ct++;
			$print_hash{$seq_id{$id}}=1;
			$out .= "\$$ct=$len{$id}(302):\n";
			# print "$\n";
			$out .= ">$seq_id{$id}\n$direct_seq{$seq_id{$id}}\n\n";
		}#else{
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
  		$out .= "\$$ct=$len{$seq_id_back{$_}}(230):\n";
		$out .= ">$seq_id{$seq_id_back{$_}}\n$seq{$seq_id_back{$_}}\n\n";
  		# @a=split(/\t/,$_);
  		# $id_hash{$a[2]}=$a[1];
  		# @a=split(/\./,$_);
  		# print "$a[0]\n";
  		$id_hash{$_}=1;
  		# $id_hash{$a[0]}=1;
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
=ccc
print "$sep1\n$sep2\n";
$ct=1;
foreach $id(sort { $a <=> $b } keys(%len)){
	@a=split(/\|/,$seq_id{$id});
	if ($a[2]=~/pdb/){
		print "\$$ct=$len{$id}(156)\n";
		print "$seq_id{$id}\n$seq{$id}\n\n";
		$ct++;
	}else{
		if ($len{$id} >=210 and $len{$id} < 600){
			print "\$$ct=$len{$id}(156)\n";
			print "$seq_id{$id}\n$seq{$id}\n\n";
			$ct++;
		}
	}
}
print "$sep3\n";
=cut
## End filter by length##############################################

## Print specific separate cma files from a file with multiple cma files in fasta
if ($ARGV[1] eq 'sep'){
	# print "blash";
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		if ($grp_num{$id} == 2){			# Specify grp_num from multicma file here
			print ">$seq_id{$id}\n$faseq{$id}\n";
		}
	}
}
## End Separate specific group #####################################

# print Dumper(\%seq_id);
## Check specific residue positions ################################
if ($ARGV[1]=~/[0-9]+/ and !exists($ARGV[2])){
	$query_pos = $ARGV[1];
	print "$sep1\n$sep2\n";
	$ct=1;
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		$pos=0;
		@b=split(//,$seq{$id});
		foreach $res(@b){
			if ($res=~/[A-Z]/){
				$pos++;
			}
			# print "$pos\t$res\n";
			if ($pos==$query_pos and $res eq 'H'){
				print "\$$ct=$len{$id}(156)\n";
				print ">$seq_id{$id}\n$seq{$id}\n\n";
				$ct++;
			}
		}
	}	
print "$sep3\n";
}

if ($ARGV[1] eq 'num'){
	# $query_pos = $ARGV[1];
	#print "$sep1\n$sep2\n";
	$ct=1;
	foreach $id(sort { $a <=> $b } keys(%seq_id)){
		$pos=0;
		@b=split(//,$seq{$id});
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
			if ($pos==$query_pos and $res eq 'H'){
				$check1=1;
			}
			if ($check1==1 and $pos==$query_pos2 and $res eq 'H'){
				print "\$$ct=$len{$id}(156)\n";
				print ">$seq_id{$id}\n$seq{$id}\n\n";
				$ct++;
			}
		}
	}	
print "$sep3\n";
}

##### End Check specific residue positions ##############################
