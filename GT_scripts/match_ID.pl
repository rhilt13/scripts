#! /usr/bin/perl -w 
use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$hash{$a[3]}=$a[0];
	$tot_cazy{$hash{$a[3]}}++;
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	@c=split(/\|/,$b[0]);
	$id=$b[1].$b[2];
	$ct_cdd{$id}++;
	if (exists ($hash{$c[3]})){
		$cnt{$id}{$hash{$c[3]}}++;
		push (@{$name{$id}{$hash{$c[3]}}}, "$c[3]");
		push (@{$db{$id}{$hash{$c[3]}}}, "$c[2]")
		# print "$b[1]|$b[2]\t$hash{$c[3]}\t$c[3]\n";
	}else{
		push(@{$not_name{$id}}, "$c[3]");
		push(@{$not_db{$id}}, "$c[2]");
	}
}

open(IN3,$ARGV[2]);
while(<IN3>){
	chomp;
	push (@z,$_);
}

# print Dumper(\%cnt);
print "#CDD_no.(#seq)\tCAZy_no.(#match/#tot_seq)\t%match\tMatch_frm\tUnmatch_frm\tUnmatched_ID_CDD\n";
foreach $cdd(sort keys %ct_cdd){
	foreach $cazy(@z){
		if (exists ($cnt{$cdd}{$cazy})){
			$num=($cnt{$cdd}{$cazy}/$ct_cdd{$cdd})*100;
			$percent=sprintf("%.2f",$num);
			print "$cdd ($ct_cdd{$cdd})\t$cazy ($cnt{$cdd}{$cazy}/$tot_cazy{$cazy})\t$percent\t(@{$db{$cdd}{$cazy}})-\t-(@{$not_db{$id}})\t@{$not_name{$cdd}}\n";
		}
	}
}