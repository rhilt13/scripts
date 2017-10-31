#! /usr/bin/perl -w 

#less nr_nongt2_pdb.p90_pdb.eval|grep '=\|File'|sed 's/^\s\+//g'|cut -f1 -d' '|tr '\n' ' '|sed 's/==/?/g'|tr '?' '\n'|sed '/^$/d;s/File[0-9]\+=//g;s/ //g'|less

#k=0;for i in `cat pdb_list`;do j=$(echo $i|cut -f2 -d'.'|cut -f2 -d'/');k=$(($k+1));chn_vsi nr_nongt2_pdb.p90_pdb.VSI 1 $k -T -skip=W -d2.5 -v -D;chn_vsi nr_nongt2_pdb.p90_pdb.VSI.crs 1 -d2.5 -v -c -D -pml > $j.pml; done

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+|\s+$//g;
	$_=~s/\.\///g;
  	$id_hash{$_}=1;
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	$_
	if (!defined $id_hash{$})
}
