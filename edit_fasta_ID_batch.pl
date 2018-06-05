#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;

# Adds annotations to the sequence ID of fasta file 
# Input:
# $ARGV[0]= fasta file
# $ARGV[1]...$ARGV[n] = tsv annotations file ( 1st col= Seq id, 2nd col= Annotation)
# Annotations added in order separated by "|"

$fa_file= shift @ARGV;
# print @ARGV;

$file_num=0;
foreach $file(@ARGV){
	$file_num++;
	open(IN,$file);  # File with info to edit IDs
	while(<IN>){
	  	chomp $_;
	  	# @a=split(/\t/,$_);
	  	# @b=split(/;/,$a[1]);
	  	# $b[1]=~s/^\s+//g;
  		# $b[1]=~s/\s+$//g;
  		# $b[2]=~s/^\s+//g;
  		# $b[2]=~s/\s+$//g;
  		# $b[0]=~s/\s+$//g;
  		# $b[0]=~s/^\s+//g;
  		# $b[0]=~s/ /_/g;
  		# $id_hash{$file_num}{$a[0]}=$b[1].".".$b[2].".".$b[0];
	
	  	@a=split(/\t/,$_);
	  	$id_hash{$file_num}{$a[0]}=$a[1];
	}
}

# print Dumper(\%id_hash);

$new=Bio::SeqIO->new(-file=>$fa_file, -format=>"fasta");

while($seq=$new->next_seq){
  $i=$seq->id;
  $s=$seq->seq;
  # $i=~s/\.[0-9]+$//g;
  # print $i;
  # $i=~s/[A-Z]$//;
  #@b=split(/\|/,$i);
  # $seq_hash{$a[1]}=$s;
  # @b=split(/\|/,$i);
  # $a=($i=~/^>(.*?)\|/);
  # print "$i\n";
  # print "$b[3]\n";
  print ">";
  for ($j=1;$j<=$file_num;$j++){
  	if(defined $id_hash{$j}{$i}){
  	  # if(defined $id_hash{$b[2]}){
  	  # if(defined $id_hash{$a[1]} && (!(defined($print_hash{$a[1]})))){
  	  # if($i=~/GT78/){
  	  # if ($i=~/^consensus/){
  	  print "$id_hash{$j}{$i}|";
 	  # print ">$id_hash{$b[2]}\n$s\n";
  	  # $print_hash{$a[1]}=1;
  	  # print ">human_".$b[3]."|$id_hash{$b[3]}\n$s\n";
  	  # print ">GT-A|consensus\n$s\n";
    }else{
    	print "-|"
    }
  }
  print "$i\n$s\n";

}
