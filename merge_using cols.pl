open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/ /,$_);
	$hash{$a[0]}=$a[1];
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@b=split(/,/,$_);
	print "$hash{$b[0]}, $_\n";
}