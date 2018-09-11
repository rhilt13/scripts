#! /usr/bin/perl -w 

# Change section as IDs are required
# ARGV[0] = hpt file
# ARGV[1] = 'print' - if want to print ids to files
#			'list' - to get a list of sequence ids per group
# ARGV[2] (if ARGV[1]=print) = tree_dist_e1 # trimmed tree distribution file
# ARGV[3] (if ARGV[1]=print) = output file prefix

# No need to run separately, run within build_sma.sh script to get final sma file.
use Data::Dumper;
if ($#ARGV<1){
	print "Missing arguments. Need 2- 1)hpt file and 2)string: print/list";
	exit;
}
open(IN,$ARGV[0]);
<IN>;
<IN>;
$i=0;
#%seq
while(<IN>){
	chomp;
	next if ($_=~/[^\!\?]$/);
	$i++;
	@a=split(/ /,$_);
	$a[-1]=~s/.$//;
	$a[-1]=~s/^[0-9]+\.//;

	# print "$_\n";
	# print "$a[-1]\n";	
	
	# if ($a[-1]=~/^GT[0-9]/){
	# 	# ($seqid)=($a[-1]=~/(.*)/); # Change way IDs are written to files here
	# 	($seqid)=($a[-1]=~/GT[0-9GTCBM]+_(.*)_Hsapiens/); # Change way IDs are written to files here
	# }else{
		$seqid=$a[-1];
	# }
	# print "$seqid\n";
	my ($one,$two)=find_cols($a[0],$i);
	@pos=@$one;
	%point=(%point, %$two);
	$id{$i}=$seqid;
	$fullid{$i}=$a[-1];
	$connect{$i}= [@pos];
	if ($_=~/\?$/){
		$type{$i}='internal';
	}elsif ($_=~/\!$/){
		$type{$i}='tip';

		# pop @pos;
		foreach $level(@pos){
			push @{$seq{$level}}, $seqid;
		}
	}
	# print @pos;
}

# print Dumper(\%point);
	# print "$k\t$type{$k}\t@{$connect{$k}}----\n";
	# next if ($k<63);
	# last if ($k>75);

	# print "$name\t@{$seq{$lev}}\n";
if ($ARGV[1] eq 'print'){
	open (IN2,$ARGV[2]);
	while(<IN2>){
		chomp;
		@a=split(/\t/,$_);
		$select{$a[0]}=1;
		$a[-1]=~s/\|//g;
		$a[-1]=~s/GT/-/g;
		$a[-1]=~s/\([0-9]+\)//g;
		$levName{$a[0]}=$a[0].$a[1]."GT".$a[-1];
	}
	$j=0;
	foreach $k(sort {$a<=>$b} keys %id){
		if (exists $select{$k}){
			$lev=${$connect{$k}}[-1];
			$hier=$#{$connect{$k}}+1;
			### Writing new hpt file ####
			$outLine1.="!";
			$j++;
			foreach $l(sort {$a<=>$b} keys %select){
				$out1{$j}.= $point{$k}{$l};
			}
			$outName1{$j}=$levName{$k};
			### Writing selected sequences list ###
			$name=$levName{$k}.".selSeq";
			open (OUT2,">$name");
		## foreach $lev(@{$connect{$k}}){
			#	# print "$k\t$lev\tHier$hier\t$type{$k}\t@{$seq{$lev}}\n";
			foreach $s(@{$seq{$lev}}){
		#		# print "$k\t$lev\t$type{$k}\t$s\n";
				print OUT2 "$s\n";
			}
			close OUT2;
		}
	}
	$n=0;
	$end=1;
	$last=scalar keys %out1;
	print $last;
	foreach $e(sort {$a<=>$b} keys %out1){
		if ($e==1){
			$node{$e}='?';
			next;
		}
		$var=$out1{$e};
		$char=substr $var, $end-1, 1;
		if ($char eq '+'){
			$node{$prev}='?';
		}else{
			$node{$prev}='!';
		}
		# print "$var\n$end\t$char\n";
		$var=~m/(\+.*\+)/g;
		$end=pos($var);
		$prev=$e;
		if ($e==$last){
			$node{$e}='!';
		}
	}
	open(OUT1,">$ARGV[3]");
	print OUT1 "HyperParTition:\n";
	print OUT1 "$outLine1\n";
	foreach $e(sort {$a<=>$b} keys %out1){
		print OUT1 "$out1{$e} $e.$outName1{$e}$node{$e}\n";
	}
	print OUT1 "-";
	for ($p=1;$p<$j;$p++){
		print OUT1 "o";
	}
	print OUT1 " ",$j+1,".Random=20000.\n";

}elsif ($ARGV[1] eq 'list'){
	foreach $k(sort {$a<=>$b} keys %id){
		if ($type{$k} eq 'internal'){
			$lev=${$connect{$k}}[-1];
			$hier=$#{$connect{$k}}+1;
			print "$k\t",$k-1,"_","$id{$k}\tHier$hier\t",$#{$seq{$lev}}+1,"\t";
			my %ct=();
			foreach $s(@{$seq{$lev}}){
				($fam)=($s=~/^(GT[0-9]+).*?_/);
				if (!$fam){
					($fam)=($s=~/_(G[Tt][0-9]+).*$/);
				}
				if (exists $ct{$fam}){
					$ct{$fam}++;
				}else{
					$ct{$fam}=1;
				}
			}
			foreach $f(sort keys %ct){
				print "$f($ct{$f})|";
			}
			print "\n";
		}
	}
}else {
	print "Unknown second argument! Need print/list";
	exit;
}

sub find_cols{
	my ($line,$num)=@_;
	@col=split(//,$line);
	# print $line;
	my $j=0;
	my @arr;
	my %point;
	foreach $elem(@col){
		$j++;
		$point{$num}{$j}=$elem;
		if ($elem eq '+'){
			push(@arr,$j);
		}
	}
	return (\@arr,\%point);
}
