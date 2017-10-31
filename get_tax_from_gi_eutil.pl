#! /usr/bin/perl -w 

use LWP::Simple;
use Data::Dumper;

open(IN,$ARGV[0]);
@lines = <IN>;
close(IN);
chomp(@lines);
while (scalar(@lines) > 0) {
	@z=splice (@lines, 0, 5);
	$id_list=join(',',@z);
	push(@list,$id_list);
}
#print Dumper(\@list);
# print "$id_list\n";
# =ccc

$db = 'taxonomy';
$dbfrom = 'protein';
$db2 = 'protein';
# $id_list = '223692354,CP001087.1,ACN15637.1,ADV46958.1';
 # $id_list = '194680922,50978626,28558982,9507199,6678417';
foreach $id_list(@list){
	#assemble the epost URL
	$base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

	# Efetch - get gi numbers
	$url = $base . "efetch.fcgi?db=protein&id=$id_list&rettype=gb";

	#post the URL
	$output = get($url);
	# print "AA\n";
	# print "$output";
	@b=split(/\n/,$output);
	$all=join '~', @b;
	# $output=~s/\t/~/g;
	# print $all;
	@c=split(/\/\//,$all);
	foreach $en(@c){
		$acc = $1 if ($en =~/LOCUS\s+(.*?)\s/);
		if ($en =~ /ORGANISM(.*?)\~REFERENCE/){
			$tax = $1;
			$tax=~s/ +/ /g;
			$tax=~s/~/ /g;
			print "$acc\t$tax\n";
			# print "$id_list\t$acc\t$tax\n";
		}else{
			# print "$acc\tno match found.\n";
		}
	}
}