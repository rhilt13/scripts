#! /usr/bin/env perl

# Input:
#[0] - database ortholog pair file
#[1] - ortholog pairs KinOrtho both
#[2] - ortholog pairs KinOrtho full length
#[3] - ortholog pairs KinOrtho domain
#[4] - list of human protein kinases

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

%db={};
%db_ct={};
open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	# print "$a[0]\n";
	$db{$a[0]}{$a[1]}=1;
	$db_ct{$a[0]}++;
	push(@{$ortho{$a[0]}},$a[1]);
}

open(IN2,$ARGV[1]);
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	$both{$b[0]}{$b[1]}=1;
	$both_ct{$b[0]}++;
	push(@{$ortho{$b[0]}},$b[1]);
}

open(IN3,$ARGV[2]);
while(<IN3>){
        chomp;
        @c=split(/\t/,$_);
        $full{$c[0]}{$c[1]}=1;
        $full_ct{$c[0]}++;
        push(@{$ortho{$c[0]}},$c[1]);
}

open(IN4,$ARGV[3]);
while(<IN4>){
        chomp;
        @d=split(/\t/,$_);
        $dom{$d[0]}{$d[1]}=1;
        $dom_ct{$d[0]}++;
        push(@{$ortho{$d[0]}},$d[1]);
}

open(IN5,$ARGV[4]);
print "#KinaseFold\tKinaseGroup\tName\tUniProtID\tDb_ct\tBoth_ct\tDbD_common\tDbB_uniq\tBoth_uniq\tFull_ct\tDbF_common\tDbF_uniq\tFull_uniq\tDom_ct\tDbD_common\tDbD_uniq\tDom_uniq\n";
while(<IN5>){
        chomp;
	@e=split(/\t/,$_);
	$qry=$e[3];
	$qry=$_;
	@filt=[];
	$DbB_comm=0;
	$DbF_comm=0;
	$DbD_comm=0;
	$DbB_uniq=0;
	$DbF_uniq=0;
	$DbD_uniq=0;
	$both_uniq=0;
	$full_uniq=0;
	$dom_uniq=0;
	@filt=uniq(@{$ortho{$qry}});
	#print "$_: @{$ortho{$_}}\n";
	#print "$_: @filt\n";
	foreach $or(@filt){
		if (exists $db{$qry}{$or} && exists $both{$qry}{$or}){
			$DbB_comm++;
		}elsif (exists $db{$qry}{$or}){
			$DbB_uniq++;
		}elsif (exists $both{$qry}{$or}){
			$both_uniq++;
		}
		if (exists $db{$qry}{$or} && exists $full{$qry}{$or}){
                        $DbF_comm++;
                }elsif (exists $db{$qry}{$or}){
                        $DbF_uniq++;
                }elsif (exists $full{$qry}{$or}){
                        $full_uniq++;
                }
		if (exists $db{$qry}{$or} && exists $dom{$qry}{$or}){
                        $DbD_comm++;
                }elsif (exists $db{$qry}{$or}){
                        $DbD_uniq++;
                }elsif (exists $both{$qry}{$or}){
                        $dom_uniq++;
                }
	}
	if (!exists $db_ct{$qry}){$db_ct{$qry}=0;}
	if (!exists $both_ct{$qry}){$both_ct{$qry}=0;}
	if (!exists $full_ct{$qry}){$full_ct{$qry}=0;}
	if (!exists $dom_ct{$qry}){$dom_ct{$qry}=0;}
	print "$_\t$db_ct{$qry}";
	print "\t$both_ct{$qry}\t$DbB_comm\t$DbB_uniq\t$both_uniq";
	print "\t$full_ct{$qry}\t$DbF_comm\t$DbF_uniq\t$full_uniq";
	print "\t$dom_ct{$qry}\t$DbD_comm\t$DbD_uniq\t$dom_uniq\n";
}
