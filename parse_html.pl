#!/usr/bin/perl -w 
#use strict;
use warnings;

use HTML::TableExtract;

my $te = HTML::TableExtract->new;
$te->parse_file($ARGV[0]);
($fam)=($ARGV[0]=~/\/(GT[0-9]*?)\./);
foreach $ts ($te->tables) {
  #print "Table (", join(',', $ts->coords), "):\n";
  foreach $row ($ts->rows) {
     $line= join('&', @$row);
     $line=~s/\n//g;
     $line=~s/\s+/ /g;
     #print $fam,"&",$line,"***%%%***\n";
  }
}

my $table = $te->first_table_found;

for my $row ($table->rows) {
	print "@$row\n";
}




