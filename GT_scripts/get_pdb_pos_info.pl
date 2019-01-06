#! /usr/bin/env perl

# Description: 
# 	Get information about the positions in a PDB file

# Input: 
#	$ARGV[0]: pdb_list.mapped.details file in the omcBPPS pdb_map folder obtained from map_pdb_afteromcBPPS.sh script under the omcBPPS_analysis.sh pipeline
#	$ARGV[1]: (pdb GT-fam mappping file)
# Change surface area files location:(~/GT/pdb/ver_0918_gta/SURF_AREA/)

open(IN,$ARGV[0]);	# pdb_list.mapped.details
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$file=$a[0];
	@b=split(/,/,$a[1]);
	$chain=$b[1];
	$size=@a;
	# If matching Surface AREA information 
	$path="/home/rtaujale/GT/pdb/ver_0918_gta/SURF_AREA";
	$pdb_info="$path/$file.pdb_$chain.asa";
	if (-e $pdb_info){
		open(IN2,$pdb_info);
		while(<IN2>){
			chomp;
			@sf=split(/\s+/,$_);
			$surf{$sf[1]}=$sf[2];
		}
	}else{
		print "ERROR:> PDB info for $pdb_info not found.\n";
		next;
	}
	open(IN2,);
	for ($i=2;$i<$size;$i++){
		@c=split(/,/,$a[$i]);
		$class=$c[0];
		@d=split(/ /,$c[1]);
		$sum_surf=0;
		$j=0;
		foreach $res(@d){
			($pos) = $res =~ /(\d+)/;
			$j++;
			$sum_surf=$sum_surf+$surf{$pos};
			print "$file\t$class\t$pos\t$surf{$pos}\n";
		}
		$avg_surf=$sum_surf/$j;
		print "==>$file\t$class\t$j\t$sum_surf\t$avg_surf\n";
		# print "$file,$a[$i]";
	}
}