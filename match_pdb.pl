#! /usr/bin/perl -w 

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	# print "##$a[0]\n";
	@b=split(/:/,$a[2]);
	# print "##$b[0]\n";
	foreach $id(@b){
		# print "##$id\n";
		$pdb=substr $id,0,4;
		# print "@@@$pdb\n";
		$cazy{$pdb}=$a[0];
	}
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@c=split(/\t/,$_);
	@d=split(/:/,$c[2]);
	foreach $id2(@d){
		$pdb2=substr $id2,0,4;
		# print "!!!$pdb2\n";
		$full_id{$pdb2}=$id2;
		$rungaps{$pdb2}=$c[0];
	}
}

open(IN3,$ARGV[2]);
while(<IN3>){
	chomp;
	@c=split(/\t/,$_);
	@d=split(/:/,$c[1]);
	foreach $id2(@d){
		$pdb2=substr $id2,0,4;
		# print "!!!$pdb2\n";
		$full_id{$pdb2}=$id2;
		$cdd{$pdb2}=$c[0];
	}
}

foreach $key(keys %rungaps){
	print "$full_id{$key}\t$rungaps{$key}\t$cazy{$key}\t$cdd{$key}\n";
}