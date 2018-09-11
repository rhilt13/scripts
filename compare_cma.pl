#! /usr/bin/perl -w 

open(IN,$ARGV[0]);
$id=0;
$grp=0;
while(<IN>){
	chomp;
	if ($_=~/^\[/){
		$grp++;
		$sep1=$_;
		($sep1_1,$num,$sep1_2)=($sep1=~/(.*\()(\d+?)(\).*)/);
	}elsif ($_=~/^\$/){
		$id++;
		($l,$pl)=($_=~/=(\d+)\((\d+)\):/);
		$len{$id}=$l;
		$prof{$id}=$pl;
	}elsif ($_=~/^>/){
		$_=~s/^\s+//g;
		$_=~s/\s+$//g;
		$_=~s/>//;
		$seq_id{$id}=$_;
		# print "##$id\t$seq_id{$id}\n";
		$seq_id_back{$_}=$id;
		$grp_num{$id}=$grp;
	}elsif ($_=~/^\{/ || $_=~/^[A-Za-z]/){
		$seq{$id}=$_;
		$direct_seq{$seq_id{$id}}=$_;
		$_=~s/[{}()\-\*]//g;
		$_=uc($_);
		$faseq{$id}=$_;
	}elsif ($_=~/^\(/){
		$sep2=$_;
		($prof_len)=($_=~/^\(([0-9]+?)\)/);
		# $prof{$id}=$prof_len;
	}elsif ($_=~/^_\d/){
		$sep3=$_;
	}elsif ($_=~/^$/){
		next;
	}else{
		print "ERROR: Don't know what to do with this line\n";
		print "$_\n";
	}
}