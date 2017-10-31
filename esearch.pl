#! /usr/bin/perl -w 

use LWP::Simple;

$db = 'pubmed';
#$dbfrom = 'protein';
#$db2 = 'protein';

$base = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/';


open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$term = $_;
	#$mindate =
	#$maxdate = 

	$url = $base . "esearch.fcgi?db=$db&term=$term&rettype=count";

	#post the URL
	$output = get($url);

	($num)=($output=~/<Count>(.*?)<\/Count>/);
	print "$term\t$num\n";

	for ($i=2002;$i<2017;$i++){
		$mindate=$i."/01/01";
		$maxdate=$i."/12/31";
		$url = $base . "esearch.fcgi?db=$db&term=$term&rettype=count&mindate=$mindate&maxdate=$maxdate";

	#post the URL
	$output = get($url);

	($num)=($output=~/<Count>(.*?)<\/Count>/);
	print "$term\t$i\t$num\n";
	}
}