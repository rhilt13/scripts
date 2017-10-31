#! /usr/bin/perl -w 

## perl map_function.pl |less

use Data::Dumper;

# open(IN,$ARGV[0]);		# cel_allIDs_map.txt
# while(<IN>){
# 	chomp;
# 	@a=split(/\t/,$_);
# 	($wid)=($a[2]=~/gene\=(WB.*?) /);
# 	# print "$wid--\n";
# 	$hash1{$wid}=$_;
# }

# print Dumper(\%hash1);
# open(IN2,$ARGV[1]);		# wormbase_data/c_elegans.PRJNA13758.current_development.functional_descriptions.txt.table
# while(<IN2>){
# 	chomp;
# 	next if $_=~/^#/;
# 	@b=split(/\t/,$_);
# 	# print "$b[0]--\n";
# 	if (defined $hash1{$b[0]}){
# 		# print "BLABLA";
# 		print "$hash1{$b[0]}\t$_\n";
# 	}
# }


open(IN,$ARGV[0]);		# cel_allIDs_map.txt
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	@b=split(/ /,$a[2]);
	$wid=$b[0];
	# ($wid)=($a[2]=~/gene\=(WB.*?) /);
	# print "$wid\n";
	$hash1{$wid}=$_;
}

open(IN2,$ARGV[1]);		# wormbase_data/c_elegans.PRJNA13758.current_development.knockout_consortium_alleles.xml.list
while(<IN2>){
	chomp;
	next if $_=~/^$/;
	@b=split(/\t/,$_);
	$b[1]=~s/ *$//g;
	# print "$b[1]--\n";
	if (defined $hash1{$b[1]}){
		# print "BLABLA";
		print "$hash1{$b[1]}\t$_\n";
	}
}
