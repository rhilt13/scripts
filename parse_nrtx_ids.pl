#! /usr/bin/perl -w 

while(<>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/\|/,$a[0]);
	$gid=$b[3];
	($phyla,$kingdom,$name)=($a[1]=~/<(.*?)\(([ABEFMV])\)>.*\[(.*?)\]/);#.*\[(.*?)\]$/);
	$phyla=~s/ //g;
	@c=split(/ /,$name);
	$genus=substr $c[0],0,1;
	$species=$c[1];
	$sp=$genus.".".$species;
	# $a[2]=uc($a[2]);
	print "$a[0]\t$a[3]|$gid|${sp}_$phyla|$kingdom|$a[2]\n";
}