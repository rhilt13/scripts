#! /usr/bin/perl -w 

use Data::Dumper;

open(IN,$ARGV[0]);
$grp=0;
while(<IN>){
	chomp;
	if ($_=~/^\[/){
		$grp++;
	}
	if ($grp == 2){
		print "$_\n";
	}else{
		next;
	}
}