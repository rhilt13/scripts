#! /usr/bin/perl -w 

open(IN,$ARGV[0]);	# file with list of pdb # Only 4 digit code: 1g8o
while (<IN>){
	chomp;
	# @a=split(/\t/,$_);
	# @b=split(/:/,$a[2]);
	# foreach $c(@b){
	# 	$d=substr $c,0,4;
	# 	push (@list,$d);
	# }
	push (@list,$_);
}

foreach $z(@list){
	print "$z\n";
	`wget http://www.rcsb.org/pdb/files/$z.pdb.gz`
}
`gunzip *gz`;
# print @list;

