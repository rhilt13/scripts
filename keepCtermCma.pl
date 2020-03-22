#! /usr/bin/perl -w
open(IN,$ARGV[0]);	# *.seqLen file 
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	open(IN2,"sel_sub/$a[0].cma");
	while(<IN2>){
		if ($_=~/^\(/){
			($tot)=($_=~/([0-9]+)/);
			$rem=$tot-$a[1];
			print $rem;
			last;
		}
	}
	system("tweakcma sel_sub/$a[0] -T1:-$rem"); 
	system(`cat sel_sub/${a[0]}_trim.cma|sed "s\/^{([A-Z]\\+)\/{()\/" > sel_sub/${a[0]}_trim.e1.cma`); 
	system("parse_cma.pl sel_sub/${a[0]}_trim.e1.cma sel-pos 1-$a[1] SkipZero sel-region > sel_sub/$a[0]_trim.e2.cma");
} # Dumper($poop);
