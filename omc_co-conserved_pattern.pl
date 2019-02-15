#!/usr/bin/env perl

#$1=file
#$2=position

use Data::Dumper;

open(IN,$ARGV[0]);
$hitct=0;
while(<IN>){
	chomp;
	%ct=();
	$hit=0;
	@a=split(/\t/,$_);
	@b=split(/,/,$a[4]);
	@c=@b;
	shift(@c);
	if ($ARGV[1]=~/^[0-9]+$/){
		foreach $pattern(@b){
			$pos=$pattern;#$b[$i];
			$pos=~s/[A-Z]//g;
			if ($pos == $ARGV[1]){
				$hit=1;
				$hitct++;
			}
		}
		if ($hit ==1){
			$hitmech{$a[2]}++;
			foreach $pattern(@b){
				$pos=$pattern;
				$pos=~s/[A-Z]//g;
				$posCt{$a[2]}{$pos}++;
			}
		}
	}elsif ($ARGV[1]=~/list/){

		for ($i=0;$i<=$#b;$i++){
			for ($j=0;$j<=$#b;$j++){
				$p1=$b[$i];
				$p1=~s/[A-Z]//g;
				$p2=$b[$j];
				$p2=~s/[A-Z]//g;
				# print "$p1<$p2\n";
				if ($p1=~/^[0-9]+$/ && $p2=~/^[0-9]+$/){
					if ($p1<$p2 && !exists($ct{$p1}{$p2})){
						# print "HAHA";
						$connect{$p1}{$p2}++;
						$ct{$p1}{$p2}=1;
					}elsif ($p1>$p2 && !exists($ct{$p2}{$p1})){
						$connect{$p2}{$p1}++;
						$ct{$p2}{$p1}=1;
					}
				}
			}
		}
	}else{
		die("Could not recognize argument.");
	}
}

# print Dumper(\%connect);
if ($ARGV[1]=~/^[0-9]+$/){
	print "$ARGV[1]\t$hitct=";
	foreach $k(sort keys %hitmech){
		print "\n$k($hitmech{$k})|";
		foreach $m(sort { $posCt{$k}{$b} <=> $posCt{$k}{$a} } keys(%{$posCt{$k}})){
			if ($posCt{$k}{$m} > $ARGV[2]){
				print "$m($posCt{$k}{$m}),";
			}
		}
	}
	print "\n";
}elsif ($ARGV[1]=~/list/){
	foreach $key1(sort { $a <=> $b } keys(%connect)){
		foreach $key2(sort { $a <=> $b } keys(%{$connect{$key1}})){
			print "Pos$key1\t$connect{$key1}{$key2}\tPos$key2\t";
			if ($connect{$key1}{$key2}>=10){
				print "1\n";
			}else{
				print "0\n";
			}
		}
	}
}
