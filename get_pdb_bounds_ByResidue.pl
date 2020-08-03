#! /usr/bin/env perl

# Input:
# $ARGV[0] = pdb in cif format

use Data::Dumper;

dAAName = {'CYS': 'C', 'ASP': 'D', 'SER': 'S', 'GLN': 'Q', 'LYS': 'K',
     'ILE': 'I', 'PRO': 'P', 'THR': 'T', 'PHE': 'F', 'ASN': 'N', 
     'GLY': 'G', 'HIS': 'H', 'LEU': 'L', 'ARG': 'R', 'TRP': 'W', 
     'ALA': 'A', 'VAL':'V', 'GLU': 'E', 'TYR': 'Y', 'MET': 'M'}

open(IN,$ARGV[0]);	# pdb file in .cif format

$line=0;
$ct=0;
while(<IN>){
	chomp;
	if ($_=~/^data_/){
		$_=~s/ +/\t/g;
		# print $_;
		@p=split(/_/,$_);
		$pdb=lc($p[1]);
		# print @p,$pdb;
	}elsif ($_=~/^_pdbx_poly_seq_scheme.hetero/){
		$line=1;
		$ct++;
	}elsif ($_=~/^#/){
		$line=0;
	}else{
		if ($line==1){
			$_=~s/ +/\t/g;
			@ent=split(/\t/,$_);
			push(@{$atoms{$ent[9]}},$ent[5]);
			push(@{$num{$ent[9]}},$ent[4]);
			push(@{$res{$ent[9]}},$ent[3]);
			if ($_=~/\?/){
				$miss="?";
			}else{
				$miss="P";
			}
			push(@{$mod{$ent[9]}},$miss);
		}
	}
}
# print $pdb,@a;
# print Dumper(\%atoms);

for $chain(sort keys %atoms){
	for ($i=0;$i<=$#{$atoms{$chain}};$i++){
		# PDB_Chain 
		print $pdb."_".$chain."\t$num{$chain}[$i]\t$dAAName{$res{$chain}[$i]}\t$atoms{$chain}[$i]\t$mod{$chain}[$i]\n";
	}
	# print $pdb."_".$chain."\t".$res{$chain}[0]."\t".$atoms{$chain}[0]."\t".$res{$chain}[-1]."\t".$atoms{$chain}[-1],"\n";
}
# $a[0]=~s/ +/\t/g;
# @first=$a[0];
# print $a[0];
# print $pdb."_".$first[9]."\t".$first[]

# $a[-1]=~s/ +/\t/g;
# @last=$a[-1];

# print $a[-1];
