#!/usr/bin/env perl

# Generate input file using the following command
# for i in `ls *cma`; do j=$(echo $i|sed 's/.cma//');echo $j; tweakcma $j -show=1:156; done > pos156

# Input:
# $ARGV[0]: pos file generated using the command above. Output of tweakcma show

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/^GT/){
		$name=$_;
		$name=~s/.merged//;
	}elsif ($_=~/^res:/){
		$i=1;
	}else{
		if ($i>0){
			# print "HAHA]-$_\n";
			($res[$i-1])=($_=~/^  ([A-Z])\: /);
			# ($res)=($_=~/^  ([A-Z])\: /);
			# print $res,$i;
			$i++;
			if ($i>$ARGV[1]){
				$i=0;
			}
		}
	}
	if ($_=~/total=/){
		print "$name\t";
		foreach $aa(@res){
			print "$aa,";
		}
		print "\n";
		$name='';
		@res=[];
	}
}