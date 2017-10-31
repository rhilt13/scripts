#! /usr/bin/perl -w

use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
  chomp;
  if ($_=~/GT2/){print "$_\t#b0171f\n";}	# crimson red
  if ($_=~/GT6/){print "$_\t#cd6889\n";}	# pale violet red
  if ($_=~/GT7/){print "$_\t#8b008b\n";}	# magenta
  if ($_=~/GT8/){print "$_\t#551a8b\n";}	# purple
  if ($_=~/GT12/){print "$_\t#cd8500\n";}
  if ($_=~/GT13/){print "$_\t#008b45\n";}	# spring green
  if ($_=~/GT15/){print "$_\t#\n";}
  if ($_=~/GT21/){print "$_\t#8b8b00\n";}	# yellow
  if ($_=~/GT24/){print "$_\t#b0171f\n";}
  if ($_=~/GT27/){print "$_\t#000080\n";}	# blue
  if ($_=~/GT43/){print "$_\t#00868b\n";}	# turqoise
  if ($_=~/GT55/){print "$_\t#b0171f\n";}
  if ($_=~/GT64/){print "$_\t#00cd00\n";}	# green
  if ($_=~/GT78/){print "$_\t#b0171f\n";}
  if ($_=~/GT81/){print "$_\t#B0171F\n";}
  if ($_=~/GT82/){print "$_\t#B0171F\n";}
  if ($_=~/GT84/){print "$_\t#B0171F\n";}
}

