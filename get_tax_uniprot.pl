#!/usr/bin/env perl 

# Run in gta_revise13/rungaps/uniprot/sense0.5 folder
# Input:
#	$ARGV[0]:proteomes_tax.tab
#	$ARGV[1]:uniprot_rev13.filtered.merged.cma

#less uniprot_rev13.filtered.merged.cma|perl -e 'open(IN,"proteomes_tax.tab");

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$hash{$a[2]}=$a[4];
}
open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	if ($_=~/^>/){
		($tid)=($_=~/OX=([0-9]+) /);
		$tax=$hash{$tid};
		$tax=~s/ //g;
		@b=split(/,/,$tax);
		if ($b[0]=~/^Archaea/){
			if ($b[1] eq ""){
				$b[1]="UnknownArchaea";
			}
			# print "$_\n";
			$t=$b[1]."(A)";
			replace()
		# print "$_\n";

		}elsif ($b[0]=~/^Bacteria/){
			if ($b[1] eq ""){
				$b[1]="UnknownBacteria";
			}
			$t=$b[1]."(B)";
			replace();
			# if ($_=~/}/){
			# 	$_=~s/}/<$t>}/;
			# }else{
			# 	$_=~s/ / {|0(0)|<$t>}/;
			# }
			# if ()
		# print "$_\n";

		}elsif ($b[0]=~/^Eukaryota/){
			if ($b[1]=~/^Fungi/){
				if ($b[3] eq ""){
					$b[3]="UnknownFungi";
				}
				$t=$b[3]."(F)";
				replace();
			# 	if ($_=~/}/){
			# 	$_=~s/}/<$t>}/;
			# }else{
			# 	$_=~s/ / {|0(0)|<$t>}/;
			# }
		# print "$_\n";
			}elsif ($b[1]=~/mycota$|^Microsporidia/){
				$t=$b[1]."(F)";
				replace();
		# print "$_\n";

			}elsif ($b[1]=~/^Metazoa/){
				$t=$b[2]."(M)";
				replace();
		# print "$_\n";
			}elsif ($b[1]=~/Chordata|Cnidaria|Ecdysozoa|Echinodermata|Lophotrochozoa|Platyhelminthes|Placozoa|Porifera/){
				$t=$b[1]."(M)";
				replace();
		# print "$_\n";

			}elsif ($b[1]=~/^Viridiplantae/){
				if ($b[3] eq ""){
					$b[3]="UnknownPlant";
				}
				$t=$b[2]."(V)";
				replace();
		# print "$_\n";
				$_=~s/}/<$t>}/;
			}elsif ($b[1]=~/Chlorophyta|Streptophyta/){
				$t=$b[1]."(V)";
				replace();
		# print "$_\n";
			}else{
				if ($b[1] eq ""){
					$b[1]="UnknownProtist";
				}				$t=$b[1]."(E)";
				$_=~s/}/<$t>}/;
		# print "$_\n";

			}
		}else{
			$_=~s/}/<Unknown(U)>}/;
		# print "$tid\t$tax\t$_\n";

		}
		print "$_\n";
	}else{
		print "$_\n";
	}
}

sub replace(){
	if ($_=~/}/){
		$_=~s/}/<$t>}/;
	}else{
		$_=~s/ / {|0(0)|<$t>}/;
	}
}