#! /usr/bin/env perl

open(IN,$ARGV[0]);	# PDB domain bounds file (pdbID,start,end)
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$start{$a[0]}=$a[1];
	$end{$a[0]}=$a[2];
}

open(IN2,$ARGV[1]);	# Cma file with the alignment of pdb sequences (IDs must match the PDB domains file)
while(<IN2>){
	chomp;
	if ($_=~/^>/){
		($id)=($_=~/^>(.*?) /);
	}elsif($_=~/^\{/){
		$_=~s/[*{}()]//g;
		@seq=split(//,$_);
		if (exists($start{$id})){
			$ct_res=$start{$id}-1;
		}else{
			print "#==>>> No domain mapping found for $id. Using start=1.\n";
			$ct_res=0;
		}
		$ct_aln=0;
		$ct_gap=0;
		foreach $res(@seq){
			if ($res=~/[A-Z]/){
				$ct_res++;
				$ct_aln++;
			}elsif ($res=~/[a-z]/){
				$ct_res++;
			}elsif ($res=~/-/){
				$ct_gap++;
				$ct_aln++;
			}
			print "$id\t$res\t$ct_aln\t$ct_res\n";
		}
	}
}