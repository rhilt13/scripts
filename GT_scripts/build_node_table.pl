#! /usr/bin/env perl

## Input
# $ARGV[0]: pattern_cts.inv - sort|uniq -c output for all patttern positiosn in Inverting fams
# $ARGV[1]: pattern_cts.ret - sort|uniq -c output for all patttern positiosn in Retaining fams
# $ARGV[2]: Integer - # of Inv families (57 if using all fam, 43 if using mainfam, rev13)
# $ARGV[3]: Integer - # of Ret families (42 if using all fam, 35 if using mainfam, rev13)

open(IN,$ARGV[0]);	#pattern_cts.inv
while(<IN>){
	chomp;
	$_=~s/^\s+//g;
	# print $_;
	@a=split(/ /,$_);
	$inv_count{$a[1]}=$a[0];
	if (!exists $seen{$a[1]} && $a[1]!~/-/){
		$seen{$a[1]}=1;
	}
}

open(IN2,$ARGV[1]);	#pattern_cts.ret
while(<IN2>){
	chomp;
	$_=~s/^\s+//g;
	# print $_;
	@a=split(/ /,$_);
	$ret_count{$a[1]}=$a[0];
	if (!exists $seen{$a[1]}){
		$seen{$a[1]}=1;
	}
}

$invNum=$ARGV[2];
$retNum=$ARGV[3];
$totNum=$invNum + $retNum;
print "Position\tTotalCnt\tTotalPct\tRetCnt\tRetPct\tInvCnt\tInvPct\tRetVsInvPct\n";
foreach $pos(sort {$a<=>$b} keys %seen){
	$pctInv=0;
	$pctRet=0;
	$ratio=0;
	$total=0;
	if (!exists ($inv_count{$pos})){
		$inv_count{$pos}=0;
	}
	if (!exists ($ret_count{$pos})){
		$ret_count{$pos}=0;
	}
	if ($invNum==0){
		$pctInv=0;
	}else{
		$pctInv=($inv_count{$pos}/$invNum)*100;
	}
	if ($retNum==0){
		$pctRet=0;
	}else{
		$pctRet=($ret_count{$pos}/$retNum)*100;
	}
	# $Ratio=(($ret_count{$pos}-$inv_count{$pos})/($ret_count{$pos}+$inv_count{$pos}))*100;
	$pctRatio=(($pctRet-$pctInv)/($pctRet+$pctInv))*100;
	$total=$inv_count{$pos} + $ret_count{$pos};
	if ($totNum==0){
		$pctTotal=0;
	}else{
		$pctTotal=($total/$totNum)*100;
	}
	print "$pos\t$total\t$pctTotal\t$ret_count{$pos}\t$pctRet\t$inv_count{$pos}\t$pctInv\t$pctRatio\n";
}