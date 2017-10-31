#! /usr/bin/perl -w

use JSON::Parse 'parse_json';
use JSON qw( decode_json );
use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	while ($_ =~ /metabolite_name/g) { $count++ }
	($id)=($_=~/\{\"study_id\":\"(.*?)\",/);
	# ($an)=($_=~/\"analysis_summary\":\"(.*?)\",/);
	my @met = ( $_ =~ /\"metabolite_name\":\"(.*?)\",/g );
	# print "$id\t$an\t$count\n";
	foreach $count(@met){
		if  ($count=~/13C/){
			next;
		}else{
			print "$id\t$count\n";
		}
	}
#	$json= decode_json($_);
#	for $key(@{$json}){
#		print "$key->{name}\n";
#	}
#	print $json->{stduy_id};
}

#print Dumper(\%json);
