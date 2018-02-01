#! /usr/bin/perl -w 

use Data::Dumper;

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
	# print "$a[-1]\n";
	(@pos)=find_cols($a[0]);
	$id{$i}=$a[-1];
	$connect{$i}= [@pos];
	if ($_=~/\?$/){
		$type{$i}='internal';
	}elsif ($_=~/\!$/){
		$type{$i}='tip';
		pop @pos;
		foreach $level(@pos){
			push @{$seq{$level}}, $a[-1];
		}
	}
	# print @pos;
}

# print Dumper(\%connect);
foreach $k(sort {$a<=>$b} keys %id){
	print "$k\t$type{$k}\t@{$connect{$k}}----\n";
	if ($type{$k} eq 'internal'){
		$lev=${$connect{$k}}[-1];
		$hier=$#{$connect{$k}};
		# foreach $lev(@{$connect{$k}}){
			print "$k\t$lev\tHier$hier\t$type{$k}\t@{$seq{$lev}}\n";
			foreach $s(@{$seq{$lev}}){
				# print "$k\t$lev\t$type{$k}\t$s\n";
			}
		# }
	}
}

sub find_cols{
	($line)=@_;
	@col=split(//,$line);
	# print $line;
	my $j=0;
	my @arr;
	foreach $elem(@col){
		$j++;
		if ($elem eq '+'){
			push(@arr,$j);
		}
	}
	return (@arr);
}