#! /usr/bin/env perl

# Ver:0.0.1
# 2020-01-16

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/protId/){
		# print "orig:: $_\n";
		$gid=getinfo("gene id");
		$pid=getinfo("protId");
		if (!exists $hash{$gid}){
			$hash{$gid}=$pid;
		}else{
			die("ERROR:Gene id $gid repeated.");
		}
	}
}
close(IN);
# foreach $key(keys %hash){
# 	print "$key\t$hash{$key}\n";
# }

open(IN2,$ARGV[0]);
while(<IN2>){
	chomp;
	if ($_=~/orthologGroup/){
		($g1,$g2)=($_=~/<geneRef id=\"(.*?)\" \/><geneRef id=\"(.*?)\" \/>/);
		print "$hash{$g1}\t$hash{$g2}\n";
	}
}
sub getinfo {
	($id)=@_;
	($val)=($_=~/[< ]$id="(.*?)"/);
	return $val;
}