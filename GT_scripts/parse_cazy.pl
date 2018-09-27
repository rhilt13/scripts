#! /usr/bin/perl -w 

open(IN,$ARGV[0]);
@name=split(/_/,$ARGV[0]);


while(<IN>){
	chomp;
	$_=~s/\s+$//g;
	if ($_=~/<\/a>$/){
		if ($_=~/ncbitaxid/){
			($sp)=($_=~/\"ncbitaxid\">(.*)<\/a>/);
		}else{
			($sp)=($_=~/<b>(.*)<\/b>/);
		}
	}elsif ($_=~/protein&val/){
		($id)=($_=~/target=_link><b>(.*)<\/td>/);
		# print "$id\n";
		$id=~s/<\/b>//g;
		$id=~s/<\/a>//g;
		# print "$id\n";
		if ($id=~/<br>/){
			if ($id=~/a href=http/){
				$id=~s/<a href.*?<b>//g;
			}
			@a=split(/<br>/,$id);
			$id=~s/<br>/\t/g;
			$id_map.="$ARGV[0]\t$id\n";
			$first=shift @a;
			$all_list .="$name[0]\tmain\t$sp\t$first\n";
			foreach $i(@a){
				$all_list .="$name[0]\t-\t$sp\t$i\n";
			}
		}else{
			$id_map.="$name[0]\t$id\n";
			$all_list .= "$name[0]\tmain\t$sp\t$id\n";
		}

	}
}

if (exists $ARGV[1] && $ARGV[1] eq 'map'){
	print $id_map;
}else{
	print $all_list;
}
