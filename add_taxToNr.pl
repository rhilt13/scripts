#! /usr/bin/env perl

# Input: 
# $ARGV[0]: Path to taxdump directory

$path=$ARGV[0];
$path=~s/\/$//;
$prot2acc=$path."/prot.accession2taxid";
$names=$path."/names.dmp";
$nodes=$path."/nodes.dmp";
open(IN,
