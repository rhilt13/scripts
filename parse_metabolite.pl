#! /usr/bin/perl -w 
use Data::Dumper;

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$a[0]=~s/^\s+//;
	$a[0]=~s/\s+$//;
	$a[2]=~s/^\s+//;
	$a[2]=~s/\s+$//;
	if ($a[2]=~/^\d/){
#print "$a[0]\n";	
		Get_no($a[0],$a[2]);
	}elsif($a[2]=~/^&/){
#print "$a[0]\n";
		@z=split(/;/,$a[2]);
		$z[1]=~s/^\s+//;
		Get_no($a[0],$z[1]);
	}elsif ($a[2]=~/Not Applicable/){
#		next;
#print "$a[0]\n";
	}else{
#		 print "$_\n";
	}
}

foreach $c(sort keys %total){
	$avg=$total{$c}/$ct{$c};
	print "$c\t";
	printf ("%.4f", $avg);
	print "\n";
}

#print Dumper(\%total);
# print Dumper(\%ct);

sub Get_no {
	($met,$con)=@_;
	@arr=split(/ /,$con);
	# print "--$arr[0]--\n";
	if ($arr[0]=~/^[\d.]+$/){
#print "$_\n";
		$num=$arr[0];
		# ($num)=($arr[0]=~/^([\d.]+)/);
		# print "num:$num\n";
		Conv($con, $num);
	}elsif ($arr[0]=~/^[\d.-]+$/){
#print "$_\n";
		# print "$arr[0]\n";
		@y=split(/-/,$arr[0]);
		# print "$y[0] -- $y[1]\n";
		$num=($y[0]+$y[1])/2;
		# print "$met\t$arr[0]\n";
		Conv($con,$num);
	}elsif ($arr[0]=~/^[\d.]+\+\/\-/){
#print "$_\n";
		@y=split(/\+/,$arr[0]);
		$num=$y[0];
		Conv($con,$num);
	}elsif ($arr[0]=~/^[\d.]+\(/){
#print "$_\n";
		@y=split(/\(/,$arr[0]);
		$num=$y[0];
		Conv($con,$num);
	}else{
#print "$_\n";
		next;
		# print "$met\t$con\n";
	}
}

sub Conv{
	($con,$num)=@_;
	if ($con=~/umol\/mmol/){
		$total{$met}+=$num;
		$ct{$met}++;
	}elsif ($con=~/nmol\/mmol/){
		$num=$num/1000;
		$total{$met}+=$arr[0];
		$ct{$met}++;
	}elsif ($con=~/uM/){
		# $arr[0]=0;
		$total{$met}+=$num;
		$ct{$met}++;
	}
}
