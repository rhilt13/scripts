#! /usr/bin/env perl

use Data::Dumper;

#Input:
# $ARGV[0] => position map file with 3 columns: ID_pos dom_pos Res ~/GT/gta_revise12/analysis/disease/data2/pos_map/aligned_ps_map.e4
# $ARGV[1] => disease mutation data ~/GT/gta_revise12/analysis/disease/data2/GT_Disease_COSMIC_TCGA_Filtered.txt.e4

##############################################
# Define domain regions:
@motifs=(90,91,92,150,151,152,179,180,206,207);

@Nterm=(1..96);
@Mterm=(97..181);
@Cterm=(182..231);
@H1=(62..65);
@H2=(120..148);
@H3=(210..231);

for ($i=1;$i<=231;$i++){$mainDom{$i}="GTA";}

for ($i=1;$i<=96;$i++){$region{$i}="Nterm";}
for ($i=97;$i<=181;$i++){$region{$i}="Mterm";}
for ($i=182;$i<=231;$i++){$region{$i}="Cterm";}

for ($i=62;$i<=65;$i++){$var{$i}="H1";}
for ($i=120;$i<=148;$i++){$var{$i}="H2";}
for ($i=210;$i<=231;$i++){$var{$i}="H3";}

foreach $i(@motifs){$var{$i}="motifs";}

push (@domains, \@Nterm);
push (@domains, \@Mterm);
push (@domains, \@Cterm);
push (@domains, \@motifs);
push (@domains, \@H1);
push (@domains, \@H2);
push (@domains, \@H3);

# print Dumper(\@domains);

###############################################
# Go through file map to map region
$start_seq=0;
open(IN,$ARGV[0]);	#pos_map/aligned_pos_map.e4
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$seq=$a[0];
	$seq=~s/_([!0-9]+)$//;
	($pos)=($a[0]=~/_([!0-9]+)$/);
	if ($a[1]==1){
		$start_seq=$seq;
	}
	if ($pos ne '!'){
		$ct{full}{$seq}++;
	}
	if ($a[1] eq '!'){
		if ($start_seq ne $seq){
			$subdom{$a[0]}="Nup";
			$ct{Nup}{$seq}++;
			# print "$seq\t$pos\t$a[1]\tN_up\t-\t$ct{Nup}{$seq}\n";
		}else{
			$subdom{$a[0]}="Cdown";
			$ct{Cdown}{$seq}++;
			# print "$seq\t$pos\t$a[1]\tCdown\t-\t$ct{Cdown}{$seq}\n";
		}
	}elsif ($pos ne '!'){
		$gtaDom{$a[0]}=$mainDom{$a[1]};
		$ct{GTA}{$seq}++;
		if ($a[1] eq '-'){
			$subdom{$a[0]}=$region{$prev_pos};
			$ct{$region{$prev_pos}}{$seq}++;
			if (exists $var{$prev_pos}){
				$spdom{$a[0]}=$var{$prev_pos};
				$ct{$var{$prev_pos}}{$seq}++;
			}
			# print "$seq\t$pos\t$a[1]\t$region{$prev_pos}\t$var{$prev_pos}\t$ct{$region{$prev_pos}}{$seq}\t$ct{$var{$prev_pos}}{$seq}\n";
		}else{
			$subdom{$a[0]}=$region{$a[1]};
			$ct{$region{$a[1]}}{$seq}++;
			if (exists $var{$a[1]}){
				$spdom{$a[0]}=$var{$a[1]};
				$ct{$var{$a[1]}}{$seq}++;
			}
			# print "$seq\t$pos\t$a[1]\t$region{$a[1]}\t$var{$a[1]}\t$ct{$region{$a[1]}}{$seq}\t$ct{$var{$a[1]}}{$seq}\n";
		}
	}else{
		# print "$seq\t$pos\t$a[1]\n";
	}
	if ($a[1] ne '-' && $a[1] ne '!' ){
		$prev_pos=$a[1];
	}
}	


# foreach $k(sort keys %ct){
# 	$size = keys %{$ct{$k}};
# 	print "$k\t$size\n";
# }
# print Dumper(\%ct);

###############################################
# Go through disease map file to get counts for each sub and specific domains

open(IN2,$ARGV[1]);	# GT_Disease_COSMIC_TCGA_Filtered.txt.e5
while(<IN2>){
	$_=~s/[\n\r]//g;
	@b=split(/\t/,$_);
	if (exists $subdom{$b[1]}){
		if (exists $spdom{$b[1]}){
			# print "$subdom{$b[1]}\t$spdom{$b[1]}\t$_\n";
			$mut_ct{$subdom{$b[1]}}{$b[2]}++;
			$mut_ct{$spdom{$b[1]}}{$b[2]}++;
		}else{
			# print "$subdom{$b[1]}\t-\t$_\n";
			$mut_ct{$subdom{$b[1]}}{$b[2]}++;
		}
	}
	if (exists $gtaDom{$b[1]}){
		$mut_ct{GTA}{$b[2]}++;
	}
	$mut_ct{full}{$b[2]}++;
	# print "$b[1]\t$subdom{$b[1]}\t$spdom{$b[1]}\n$_\n";
}

# print Dumper(\%mut_ct);
# print Dumper(\%ct);
###############################################
@dom_order=("full","GTA","Nup","Cdown","Nterm","Mterm","Cterm","motifs","H1","H2","H3");
# Get the per residue counts
foreach $doms(@dom_order){
	foreach $seqid(sort keys %{$mut_ct{$doms}}){
		if (exists $mut_ct{$doms}{$seqid} and exists $ct{$doms}{$seqid}){
			$PerResCt=$mut_ct{$doms}{$seqid}/$ct{$doms}{$seqid};
			$PerResPerMutCt=($PerResCt/$mut_ct{full}{$seqid})*100;
		}
		print "$doms\t$seqid\t$mut_ct{$doms}{$seqid}\t$ct{$doms}{$seqid}\t$mut_ct{full}{$seqid}\t$PerResCt\t$PerResPerMutCt\n";
	}
}