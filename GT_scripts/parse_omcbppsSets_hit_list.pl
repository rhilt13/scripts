#! /usr/bin/perl -w 

## perl ~/rhil_project/GT/scripts/parse_omcbppsSets_hit_list.pl hits_details ~/rhil_project/GT/new_ID_order > hits_details_parse

$full=`ls *Set1.cma`;
chomp $full;
($pref)=($full=~/(.*?)Set1\.cma/);

open(IN,$ARGV[0]);		 ## hits_details file obtained by omcbpps analysis
while(<IN>){
	chomp;
	if ($_=~/^Set/){
		$_=~s/Set//g;
		$a=$_;
		push(@arr,$a);
	}elsif ($_=~/File/){
		($b,$c)=($_=~/GT-A\|(.*?)[| ].*\((\d+)/);
		$hash{$a}{$b}=$c;
	}
}

@sorted_arr = sort { $a <=> $b } @arr;

print "\t";
foreach $set(@sorted_arr){
	$name=$pref."Set".$set.".cma";
	# print "$name\t";
	$num=`cat $name|grep '^>'|wc -l`;
	chomp $num;
	print "$num\t";
}
print "\n";


print "\t";
foreach $n(@sorted_arr){
	print "$n\t";
}
print "\n";

open (IN2,$ARGV[1]);		## order file
while(<IN2>){
	chomp;
	push (@name_arr,$_);
}
foreach $m(@name_arr){
	print "$m\t";
	foreach $n(@sorted_arr){
		if (defined $hash{$n}{$m}){
			print "$hash{$n}{$m}\t";
		}else{
			print "0\t";
		}
	}
	print "\n";
}