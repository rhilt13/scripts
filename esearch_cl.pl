#!/usr/bin/perl -w

use Data::Dumper;
use List::MoreUtils qw/ uniq /;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$fam=shift @a;
	$first_id=$a[0];
	$str=join(',',@a);
#	foreach $id(@a){
#		$hash{$id}=1;
#	}
	$hits=`esearch -db protein -query $str|efetch -format ipg|cut -f6|sed '1d'`;
	@b=split(/\n/,$hits);
#	foreach $elem(@b){
#		$hash{$elem}=1;
#	}
	push (@a,@b);
	my @unique = uniq @a;
	my @sort_uniq=sort @unique;
	print "$fam\t$first_id";#$a[0]";
	foreach (@sort_uniq){
		print "\t$_";
	}
#	foreach $hit(sort keys %hash){
#		print "\t$hit";
#	}
	print "\n";
#	%hash=();
}
