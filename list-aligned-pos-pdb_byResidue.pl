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

open(IN,$ARGV[0]);	# PDB position mapping file (pdbID,start,end)
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$map{$a[0]}{$a[1]}=$a[3]; # $a[1]; Check to make sure right column is selected.
	$mod{$a[0]}{$a[1]}=$a[4];
}
# print Dumper(\%map);
open(IN2,$ARGV[1]);	# Cma file with the alignment of pdb sequences (IDs must match the PDB domains file)
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
		$ct_aln=0;
		$ct_gap=0;
		$num=0;
		for ($i=0;$i<=$#seq;$i++){
			$res=$seq[$i];
			if ($res=~/[A-Z]/){
				$num++;
				$ct_res=$map{$id}{$num};
				$isMod=$mod{$id}{$num};
				$ct_aln++;
				$curr_aln=$ct_aln;
				$curr_res=$ct_res;
			}elsif ($res=~/[a-z]/){
				$num++;
				$ct_res=$map{$id}{$num};
				$isMod=$mod{$id}{$num};
				$curr_aln="-";
				$curr_res=$ct_res;
			}elsif ($res=~/-/){
				$ct_gap++;
				$ct_aln++;
				$curr_aln=$ct_aln;
				$curr_res="-";
				$isMod="-";
			}
			print "$id\t$res\t$curr_aln\t$curr_res\t$isMod\n";
		}
	}
}
# 		}
# 		if (exists($start{$id})){
# 			$ct_res=$start{$id}-1;
# 		}elsif (exists($fullstart{$id})){
# 			$ct_res=$fullstart{$id}+$offset-1;
# 		}else{
# 			print "#==>>> No domain mapping found for $id. Using start=1.\n";
# 			$ct_res=0;
# 		}
# 		$ct_aln=0;
# 		$ct_gap=0;
# 		foreach $res(@seq){
# 			if ($res=~/[A-Z]/){
# 				$ct_res++;
# 				$ct_aln++;
# 			}elsif ($res=~/[a-z]/){
# 				$ct_res++;
# 			}elsif ($res=~/-/){
# 				$ct_gap++;
# 				$ct_aln++;
# 			}
# 			print "$id\t$res\t$ct_aln\t$ct_res\n";
# 		}
# 	}
# }