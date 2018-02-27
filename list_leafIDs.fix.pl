#! /usr/bin/perl -w

use Data::Dumper;

# $ARGV[0] - .details file with actual name for tip nodes
# $ARGV[1] - .nodes file with all the nodes
# $ARGV[2] - .col.nodes file with all the nodes selected in pruned file

open(IN3,$ARGV[0]);
while(<IN3>){
	chomp;
	@a=split(/\t/,$_);
	$name_hash{$a[0]}=$a[1];
}

open(IN,$ARGV[1]);	#.nodes file with all nodes
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$a[0]=~s/^\s+//g;
	$a[0]=~s/\s+$//g;
	$size= scalar @a;
	# print scalar (@a),"\n";
	if ($size>1){
		# print "BLABAL";
		# print "$a[1]\n";
		@b=split(/ /,$a[1]);
		foreach $name(@b){
			$name=~s/^\s+//g;
			$name=~s/\s+$//g;
			if ($name!~/^I[0-9]+$/){
				push @{$tip_hash{$a[0]}},$name;
				# get seq from cma file
			}
		}
		# if (!exists $hash{'internal'}{$a[0]}){
			# print "$a[0]\ttHAHAHAHA\n";
		# }
		# print "$_\n";
	}else{
		# get seq from cma
		push @{$tip_hash{$a[0]}},$a[0];
	}
}
# print Dumper(\%{$tip_hash});
# =ccc
my $directory = "sub_cma";
unless(-e $directory or mkdir $directory) {
	die "Unable to create $directory\n";
}

open(IN2,$ARGV[2]);	#.col.nodes for the pruned tree
$ct=0;
$j=1;
while(<IN2>){
	$ct++;
	chomp;
	@a=split(/\t/,$_);
	$a[0]=~s/^\s+//g;
	$a[0]=~s/\s+$//g;
	@b=split(/ /,$a[1]);
	$size= scalar @b;
	# print scalar (@a),"\n";
	if ($size==1){
		$level{$a[0]}=$j;
		$file=$directory."/".$name_hash{$a[0]}."_tip.selID";
		open(OUT,">",$file);
		# print "================$a[0]\n";
		if (exists $tip_hash{$a[0]}){
			foreach $id(@{$tip_hash{$a[0]}}){
				print OUT "$id\n";
				# $printed{$id}=1;
			}
		}else{
			print "================> NOT DEFINED\n";
		}
		close OUT;
		# foreach $id(sort keys %{$tip_hash{$a[0]}}){
		# 	print "$a[0]\t$id\t@{$tip_hash{$id}}\n";
		# }
	}else{
		$file=$directory."/".$a[0]."_int.selID";
		open(OUT,">",$file);
		foreach $name(@b){
			print OUT $name_hash{$name}."\n";
		}
		close OUT;
	}
}
close IN2;
=ccc
foreach $line(@check){
		@a=split(/\t/,$line);
		$a[0]=~s/^\s+//g;
		$a[0]=~s/\s+$//g;
		if (!exists $level{$a[0]}){
			$size= scalar @a;
			# print "--------------$a[0]\n";
			@b=split(/ /,$a[1]);
			foreach $name(@b){
				if (!exists $level{$name}){
						# print "$name--\tBLABLA\n";
					goto SKIP;
				}
			}
			$file=$directory."/".$a[0]."_"."l".$j.".selID";
			open(OUT,">",$file);
			# print "================$a[0]\n";
			foreach $id(@b){
				# print $id;
				if (!exists $printed{$id}){
					print OUT $name_hash{$id}."_l$level{$id}\n";
					$printed{$id}=1;
				}

				# print OUT "$id\n";
			}
			$name_hash{$a[0]} = $a[0];	# Change here if other levels have names
			close OUT;
			# print "$j***>>>>$a[0]\t@b\n";
			$level{$a[0]}=$j;
		}
		SKIP:
	}
	$size = keys %level;
}
=cut