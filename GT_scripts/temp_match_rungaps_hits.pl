#! /usr/bin/perl -w 
use Data::Dumper;

#less ../../../CAZy_families/run_gaps_longer/list_hits.txt

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$hash1{$a[0]}=$a[1];
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	# @a=split(/\t/,$_);
	# print "$_\n";
	if ($_=~/^[0-9]+/){
		$_=~s/\s//g;
		$key=$_;
		# print "$key--\n";
	}elsif ($_=~/^aln/){
		last;
	}else{
		# print "$_\n";
		$_=~s/\t//g;
		# print "$_\n";
		if (defined $hash2{$_}){
			push(@{$hash2{$_}}, $hash1{$key}) unless grep{$_ eq $hash1{$key}} @{$hash2{$_}};
			# print "Hash exists $_ -- $hash2{$_} -- $key -- $hash1{$key}\n";
		}else{
			# print "$_\t$key\n";
			$hash2{$_}= [];
			push @{$hash2{$_}}, $hash1{$key};
		}
	}
}

# print Dumper(\%hash2);

open(IN3,$ARGV[2]);
while(<IN3>){
	chomp;
	@b=split(/\t/,$_);
	@c=split(/\|/,$b[1]);
	$hash3{$b[0]}=$c[1];
}

open(IN4,$ARGV[3]);
while(<IN4>){
	chomp;
	# @a=split(/\t/,$_);
	# print "$_\n";
	if ($_=~/^[0-9]+/){
		$_=~s/\s//g;
		$key2=$_;
		# print "$key--\n";
	}elsif ($_=~/^aln/){
		last;
	}else{
		# print "$_\n";
		$_=~s/\t//g;
		# print "$_\n";
		if (defined $hash4{$_}){
			push(@{$hash4{$_}}, $hash3{$key2}) unless grep{$_ eq $hash3{$key2}} @{$hash4{$_}};
			# print "Hash exists $_ -- $hash2{$_} -- $key -- $hash1{$key}\n";
		}else{
			# print "$_\t$key\n";
			$hash4{$_}= [];
			push @{$hash4{$_}}, $hash3{$key2};
		}
	}
}
# print( scalar(keys(%hash1)), "\n" );
print( scalar(keys(%hash2)), "\n" );
# print( scalar(keys(%hash3)), "\n" );
print( scalar(keys(%hash4)), "\n" );


# foreach $k(keys %hash4){
# 	# push(@allID, $k) unless grep{$_ eq $k} @allID;
# 	print "$k\n";
# 	# print "$k\t@{$hash2{$k}}\t@{$hash4{$k}}\n";
# }
# foreach $y(keys %hash2){
# 	# push(@allID, $y) unless grep{$_ eq $y} @allID;
# 	print "$y\n";
# 	# print "$k\t@{$hash2{$k}}\t@{$hash4{$k}}\n";
# }

# open(IN5,$ARGV[4]);
# while(<IN5>){
# 	chomp;
# 	print "$_\t@{$hash2{$_}}\t@{$hash4{$_}}\n";
# }
# foreach $id(@allID){
# 	print "$id\n";
# }
# print Dumper(\%hash4);

