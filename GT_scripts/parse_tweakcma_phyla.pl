#! /usr/bin/perl -w 

# Previous steps:
# for i in `ls sets_rungaps_nr/*_is90_is92.cma`; do j=$(echo $i|sed 's/.cma$//');echo $j; tweakcma $j -phyla; done > gta_rev12_rungaps_tax.raw
# cat gta_rev12_rungaps_tax.raw|grep '^sets_\|^==\|Chordata\|Chlorophyta\|Streptophyta\|viruses\|^ number'|sed 's/^ number/number/'|grep -v '^=\+$' > gta_rev12_rungaps_tax.raw.e1
# cat ../../profile/order |cat -n|sed 's/^ \+//g' > map_fam_info

# Input (generate from above):
# $ARGV[0] = map_fam_info
# $ARGV[1] = *_tax.raw.e1

# Run:
# parse_tweakcma_phyla.pl map_fam_info gta_rev12_rungaps_tax.raw.e1 > gta_rev12_rungaps_tax.raw.e1.table

# open(IN,"$ARGV[0]");
# while(<IN>){
# 	chomp;
# 	@n=split(/\t/,$_);
# 	push(@famList,$n[1]);
# 	$hash{$n[0]}=$n[1];
# }
open(IN2,"$ARGV[1]");
while(<IN2>){
	# print $_;
	chomp;
	# if($_=~/^sets_/){
	# 	# ($fam_num)=($_=~/_new_(Set[0-9]+).cma.edit/);	#OmcSets Change based on where the family name/num is 
	# 	($fam_num)=($_=~/nr_gtrev12_([0-9]+)\.l140/);	#RunGaps Change based on where the family name/num is 
	# 	# $fam=$hash{$fam_num};
	# 	# print "$_\t--$fam_num\n";
	# 	$fam=$fam_num;
	# 	push (@famList,$fam);
	# if($_=~/^nrtx/){		# For new nrtx sets
	# 	($fam_num)=($_=~/nrtx.pID_([0-9]+)\.nocsq/);	#RunGaps Change based on where the family name/num is 
	# 	$fam=$fam_num;
	# 	push (@famList,$fam);
	# if($_=~/^nr_rev/){		# For new omcBPPS sets
	# 	($fam_num)=($_=~/sel3_new_(Set[0-9]+)\.cma/);	#OmcBPPS Change based on where the family name/num is 
	# 	$fam=$fam_num;
	# 	push (@famList,$fam);
	if($_=~/^GT/){		# For new omcBPPS sets
		($fam_num)=($_=~/^(.*?)\.merged/);	#Rungaps, main fam combined
		$fam=$fam_num;
		push (@famList,$fam);
	}elsif($_=~/^==/){
		$_=~s/=//g;
		@a=split(/ /,$_);
		if ($_=~/unknown/){
			@b=split(/\(/,$a[2]);
			if (exists($h1{$b[0]})){
				$h1{$b[0]}+=$a[1];
			}else{
				$h1{$b[0]}=$a[1];
			}
		}else{
			$h1{$a[2]}=$a[1];
		}
	}elsif($_=~/^ /){
		$_=~s/[()]//g;
		$_=~s/^ +//g;
		@d=split(/ /,$_);
		if ($_=~/viruses/){
			shift @d;
			if (exists($h1{"viruses"})){
				$h1{"viruses"}+=$d[1];
			}else{
				$h1{$d[0]}=$d[1];
			}
		}else{
			$h1{$d[0]}=$d[1];
		}
	}elsif($_=~/^number/){
		($kingdom,$phyla)=($_=~/kingdoms = ([0-9]+); phyla = ([0-9]+)/);
		$out{$fam} .="$fam,";
		if (exists($h1{"archea"})){
			$out{$fam} .=$h1{"archea"}.",";
		}else{$out{$fam} .="-,";}
		if(exists($h1{"bacteria"})){
			$out{$fam} .=$h1{"bacteria"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"protozoa"})){
			$out{$fam} .=$h1{"protozoa"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"fungi"})){
			$out{$fam} .=$h1{"fungi"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"metazoa"})){
			$out{$fam} .=$h1{"metazoa"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"Chordata"})){
			$out{$fam} .=$h1{"Chordata"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"Chlorophyta"})){
			$out{$fam} .=$h1{"Chlorophyta"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"Streptophyta"})){
			$out{$fam} .=$h1{"Streptophyta"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"viruses"})){
			$out{$fam} .=$h1{"viruses"}.",";
		}else{$out{$fam} .="-,";}
		if (exists($h1{"unknown"})){
			$out{$fam} .=$h1{"unknown"}.",";
		}else{$out{$fam} .="-,";}
		$out{$fam} .="$kingdom,$phyla\n";
		%h1=();
	}
}

foreach $f(@famList){
	print $out{$f};
}