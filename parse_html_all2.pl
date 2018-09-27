#!/usr/bin/perl -w 

use warnings;
use HTML::TableExtract;

my $te = HTML::TableExtract->new;
$te->parse_file($ARGV[0]);

#($fam)=($ARGV[0]=~/\/(GT[0-9]*?)\./);
#$fam="";
foreach $ts ($te->tables) {
  # print $ts->coords;
  $a=join(',', $ts->coords);
  print $a;
  @b=split(/,/,$a);
  foreach $row ($ts->rows) {
    print $ts->rows;
    $line= join('&', @$row);
    $line=~s/\n//g;
    $line=~s/\s+/ /g;
 # print "$b[0]\t$b[1]\n";
 # $ts->coords;
 # print "\n";
 # print "Table (", join(',', $ts->coords), "):\n";
    if ($b[0]==0 && $b[1]==0){
#      print "BLABLABAL$line\n";
      ($org)=($line=~/Orthologous Gene (.+?)Acceptor/);
      # print "$org\n";
    }elsif ($b[0]==1 && $b[1]==0){
      next;
    }else{
      # print "$line\n";
    }
  }
}
my $table = $te->first_table_found;

#for my $row ($table->rows) {
#	print "@$row\n";
#}
