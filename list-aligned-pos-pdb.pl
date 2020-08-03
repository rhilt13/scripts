#! /usr/bin/env perl

# Build PDB domain bounds file
# 1) Either use the pdb_map folder from omcBPPS that maps pdbs to omcBPPS sets
# 		( Does not map all pdbs if omcBPPS set for that pdb family is not found)
# 2) Use the pdb,cif file to extract the first residue position in pdb file, add this number to the start of mapped domain in the cma ID description.
#		Use script Map pdb cma domains
# Note: 
#    Check pattern matching to grep sequence lines
#    Check column number for sequence start and end 

use Data::Dumper;

if ($ARGV[0]=~/domain/){
	open(IN,$ARGV[1]);	# PDB domain bounds file (pdbID,start,end)
	while(<IN>){
		chomp;
		@a=split(/\t/,$_);
		$start{$a[0]}=$a[2]; # $a[1]; Check to make sure right column is selected.
		$end{$a[0]}=$a[4]; # $a[2];
	}
}elsif ($ARGV[0]=~/full/){
	open(IN,$ARGV[1]);	# PDB full length bounds file (pdbID,start,end)
	while(<IN>){
		chomp;
		@a=split(/\t/,$_);
		$fullstart{$a[0]}=$a[2];
		$fullend{$a[0]}=$a[4];
	}
}else{
	print "ERROR:First argument not understood:$ARGV[0]\n";
	print "\tEnter either domain or full.\n";
	die();
}

open(IN2,$ARGV[2]);	# Cma file with the alignment of pdb sequences (IDs must match the PDB domains file)
while(<IN2>){
	chomp;
	if ($_=~/^>/){
		($id)=($_=~/^>(.*?) /);
		if ($ARGV[0]=~/full/){
			($offset)=($_=~/^>.*? +\{\|([0-9]+)\(/);
		}
	# }elsif($_=~/^\{/){
	}elsif($_=~/^[A-Za-z]/){
		$_=~s/[*{}()]//g;
		@seq=split(//,$_);
		if (exists($start{$id})){
			$ct_res=$start{$id}-1;
		}elsif (exists($fullstart{$id})){
			$ct_res=$fullstart{$id}+$offset-1;
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