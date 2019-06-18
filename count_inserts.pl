#! /usr/bin/env perl

# Input:
# $ARGV[0]: cma file

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/^>/){
		$id =$_;
		$id=~s/^>//g;
	}elsif ($_=~/^\{/){
		$ins=0;
		$aln=0;
		$seqct++;
		$gap=0;
		@a=split(//,$_);
		foreach $res(@a){
			if ($res=~/[a-z]/){
    			$ins++;
    		}
    		if ($res=~/[A-Z]/){
    			$aln++;
    		}
    		if ($res=~/[A-Za-z]/){
    			$seqct++;
    		}
    		if ($res=~/-/){
    			$gap++;
    		}
    	}
    	print "$id\t$ins\t$aln\t$gap\n";
	}
}