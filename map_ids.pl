#! /usr/bin/perl -w 

## perl map_ids.pl cel_cazy_fullID cel_gta_cazy_wormbase_map.txt wormbase_id_space_full|less

open(IN,$ARGV[0]);		# IDedited CAZy IDs with GT2-Rham|AAA00000|cel_metazoa type IDs [cel_cazy_fullID]
while(<IN>){
	chomp;
	@a=split(/\|/,$_);
	$hash1{$a[1]}=$a[0]."\t".$a[1];
}

open(IN2,$ARGV[1]);		# File with regular CAZy edited IDs GT2-A|AAA00000|cel_metazoa \t T06E11.12 (wormbase ID) [cel_gta_cazy_wormbase_map.txt]
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	@c=split(/\./,$b[0]);
	$hash_wb2{$b[1]}=$c[0];
}

open(IN3,$ARGV[2]);		# File with wormbase IDs and details from wormbase proteins.fa file separated by spaces [wormbase_id_space_full]
while(<IN3>){
	chomp;
	@d=split(/ /,$_);
	print "$hash1{$hash_wb2{$d[0]}}\t$_\n";
	#@d=spl
}