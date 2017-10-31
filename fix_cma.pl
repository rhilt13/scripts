#! /usr/bin/perl -w 

# works with any type of cma file
# Multi layered, mma, chn

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/^\{\(\)/){
		# print "$_\n";
		@a=split(//,$_);
		if ($a[3] eq '-'){
			# print "$_\n";
			# print "$#a\n";
			for ($i=3;$i<$#a;$i++){
				if ($a[$i] ne '-'){
					$a[3]=$a[$i];
					$a[$i]='-';
					last;
				}
			}
			$_=join ('',@a);
			# print "$_\n";
		}
		# print "$a[-1]\t$a[-2]\t$a[-3]\t$a[-4]\n";
		if ($a[-5] eq '-'){
			# print "$_\n";
			for ($i=-5;$i>-$#a;$i--){
				# print "$a[$i]\t";
				if ($a[$i] ne '-'){
					# print "$a[$i]\n";
					$a[-5]=$a[$i];
					$a[$i]='-';
					last;
				}
			}
			$_=join ('',@a);
			# print "$_\n";
		}
		print "$_\n";
	}else{
		print "$_\n";
	}
}