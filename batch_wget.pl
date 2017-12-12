#! /usr/bin/perl -w  

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$b=$a[0];
	$c=$a[1];
	system "wget http://www.bmrb.wisc.edu/metabolomics/standards/$b/nmr/$c/HH_TOCSY.tar -O $b.$c.TOCSY";
	system "wget http://www.bmrb.wisc.edu/metabolomics/standards/$b/nmr/$c/1H_13C_HSQC.tar -O $b.$c.HSQC";
	system "mkdir $b.$c";
	system "tar -xf $b.$c.HSQC -C $b.$c";
	system "tar -xf $b.$c.TOCSY -C $b.$c";
	system "rm $b.$c.TOCSY $b.$c.HSQC";
}
