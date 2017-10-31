#! /usr/bin/perl -w 

use LWP::Simple;

open(IN,$ARGV[0]);
@lines = <IN>;
close(IN);
chomp(@lines);
while (scalar(@lines) > 0) {
	@z=splice (@lines, 0, 5);
	$id_list=join(',',@z);
	push(@list,$id_list);
}
# print "$id_list\n";
# =ccc
$db = 'protein';
$dbfrom = 'protein';
$db2 = 'protein';
# $id_list = '223692354,CP001087.1,ACN15637.1,ADV46958.1';
 # $id_list = '194680922,50978626,28558982,9507199,6678417';
foreach $id_list(@list){
	#assemble the epost URL
	$base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';

	# Efetch - get gi numbers
	$url = $base . "efetch.fcgi?db=protein&id=$id_list&rettype=gi";

	#post the URL
	$output = get($url);
	# print "$output";
	
	@a=split(/\n/,$output);
	$gi_list=join ',', @a;

	# print "$gi_list";
	#epost
	$url = $base . "epost.fcgi?dbfrom=$dbfrom&db=$db&id=$gi_list";
	#post the epost URL
	$output = get($url);
	# print "$output";

	#assemble the elink URL
	# $url = $base . "elink.fcgi?dbfrom=$db1&db=$db2&id=$id_list";
	# $url .= "&linkname=$linkname&cmd=neighbor_history";

	# #post the elink URL
	# $output = get($url);
	# print "$output";

	#parse WebEnv and QueryKey
	$web = $1 if ($output =~ /<WebEnv>(\S+)<\/WebEnv>/);
	$key = $1 if ($output =~ /<QueryKey>(\d+)<\/QueryKey>/);

	### include this code for EPost-ESummary
	#assemble the esummary URL
	#$url = $base . "esummary.fcgi?db=$db&query_key=$key&WebEnv=$web";

	#post the esummary URL
	#$docsums = get($url);
	#print "$docsums";
	#print "end summary\n";	

	


	### include this code for EPost-EFetch
	#assemble the efetch URL
	$url = $base . "efetch.fcgi?dbfrom=$dbfrom&db=$db&query_key=$key&WebEnv=$web";
	$url .= "&rettype=fasta&retmode=text";

	#post the efetch URL
	$data = get($url);
	print "$data";
	# print "hehe\n";

}