#! /usr/bin/perl -w 

use Data::Dumper;
## perl ~/rhil_project/GT/scripts/compare_omcbpps_sets.pl ~/rhil_project/GT/GT-A/omcbpps_cazy_pdb/gt2/ 1

#################################################################
# Datasets:
# omcbpps_cazy_pdb
#	gt2
#	non-gt2
#	non-gt2-purge90
# omcbpps_genbank_gtamuslonger
#	all
#	minsize200
#	minsize400
#################################################################
# Files:
# _new.mma : get prefix of the filenames
# _bst.out : match number with set number and get npws score for sets
# .lpr : get patterns and related scores


#################################################################
# Input:
# folder name
# Set number
# Add these 2 in order as many as wanted
#################################################################

while(my ($dir,$set) = splice(@ARGV,0,2)) {
	opendir(DIRHANDLE, $dir) || die "ERROR:Could not locate directory: $dir.\n\tPlease enter absolute or relative path to: $dir.\n**Aborted**\n\n";
	while(readdir DIRHANDLE){
		if ($_=~/_new.mma$/){push (@mma_files,$_);}
		if ($_=~/_bst.out$/){push (@bst_files,$_);}
		if ($_=~/.lpr$/){push (@lpr_files,$_);}
	}
	close DIRHANDLE;

	$prefix=grab_file(\@mma_files,"*_new.mma",$dir);
	$prefix=~s/_new\.mma//g;
	# $lpr=grab_file(\@lpr_files,"*.lpr",$dir);
	$bst=$prefix."_bst.out";
	$lpr=$prefix.".lpr";
	if (!-e "$dir/$bst"){
		print STDERR "**$bst file not found.\n\tSearching for other bst files..";
		$bst=grab_file(\@bst_files,"*_bst.out",$dir);
	}
	print STDERR "\n=> Using best file: $bst  ###\n";
	if (!-e "$dir/$lpr"){
		print STDERR "**$lpr file not found.\n\tSearching for other lpr files..";
		$lpr=grab_file(\@lpr_files,"*.lpr",$dir);
	}
	print STDERR "\n=> Using lpr file: $lpr  ###\n";

	open(IN,"$dir/$bst");
	while(<IN>){
		chomp;
		# print $_;
		if ($_=~/\.Set/){
			($serialNum,$setNum)=($_=~/(\d+?)\.Set(\d+?) /);
			$num_map{$serialNum}=$setNum;
			push(@ser_num, $serialNum);
			# print "$_\n$serialNum\t$setNum\n";
		}elsif ($_=~/^\s?\d+: \(/){
			($sNum,$npws)=($_=~/^\s?(\d+?):.*?([\d.]+) npws/);
			# print "$_\n$sNum\t$num_map{$sNum}\t$npws\n";
			$npws_map{$sNum}=$npws;
		}
	}

	open(IN2,"$dir/$lpr");
	$line=0;
	$serNum=9999999;
	@pttrn=[];
	while(<IN2>){
		chomp;
		$line++;
		if ($_=~/^::.*?::$/){
			# foreach $z(@pttrn){
			# 	print "$z\n";
			# }
			($serNum)=($_=~/\s(\d+): /);
			$line=1;
		}elsif ($line==2 || $line==3){
			next;
		}elsif ($line <= 30 and $_=~/^\s*[A-Z]+[0-9]+\([0-9]+\):/){
			# print "$serNum\t$line\t$_\n";
			($res,$score)=($_=~/([A-Z]+\d+)\(.*?(\d+\.\d+?)\(/);
			$val=$res."(".$score.")";
			# print "$val\n";
			push(@pttrn,$val);
			# print "$serNusm==$line\t@pttrn\n";
		}elsif ($line==31){
			shift(@pttrn);
			$pttrn_map{$serNum}=[ @pttrn ];
			@pttrn=[];
		}
	}
	@sort_num=sort{$a<=>$b} @ser_num;
	foreach $s(@sort_num){
		print "$s\t$num_map{$s}($npws_map{$s})\t";
		# print $s,"\t",scalar(@{$pttrn_map{$s}}),"\n";
		foreach $elem(@{$pttrn_map{$s}}){
			print "$elem\t";
		}
		print "\n";
	}
	# print Dumper(\%pttrn_map);
}

########### Subroutines ##########################################################

sub grab_file{
	my ($one,$two,$three)=@_;
	my @f=@{$one};
	my $key=$two;
	my $dir=$three;
	if ( scalar(@f) > 1 ) {
		print STDERR "Multiple files found.\n";
		$i=1;
		foreach $n(@f){
			print STDERR "$i) $n\n";
			$i++;
		}
		print STDERR "Please type in the file number from above list:\n";
		$num=<STDIN>;
		chomp $num;
		while ($num !~ m/^\d+$/ || $num > scalar(@f)) {
			print STDERR "Invalid!! Please type in the file number from above list:\n";
			$num=<STDIN>;
			chomp $num;
		}
		$name=$f[$num-1];
	}elsif (scalar(@f) == 1){
		$name=$f[0];
	}else{
		die("ERROR:Could not find filetype $key in directory $dir.\n**Aborted**\n");
	}
	return $name;
}