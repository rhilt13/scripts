#!/usr/bin/env perl

# Input:
# $ARGV[0] : cma file witht the sequences to calculate inserts for.
# $ARGV[1] : (optional) Full Length of sequences, mapped by seq IDs

use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };

@name=split(/\./,$ARGV[0]);
$fam=$name[0];

if (exists $ARGV[1]){
	open(IN2,$ARGV[1]);
	while(<IN2>){
		chomp;
		@a=split(/\t/,$_);
		$lenHash{$a[0]}=$a[1];
	}
}
open(IN,$ARGV[0]);
while(<IN>){
	$ins{hv1}=0;
	$ins{hv2}=0;
	$ins{hv3}=0;
    @ret=();
    chomp;
	if ($_=~/^\$/){
		($len)=($_=~/=([0-9]+)\(/);
	}elsif ($_=~/^>/){
        ($id)=($_=~/^>(.*?)\s/);
        ($nterm,$cterm)=($_=~/\{\|([0-9]+)\(([0-9]+)\)\|/);
        ($tax,$kingdom)=($_=~/<([A-Za-z ]*)\(([ABVFMEXU])\)>\}/);
        $tax=~s/ /_/g;
        $re=reverse($_);
        ($species)=($re=~/\](.*?)\[\s/);
        $species=reverse($species);
        $species=~s/ /_/g;
        if ($species eq '' || not defined $species){
        	$species='Unknown';
        }
        if ($tax eq '' || not defined $tax){
        	# print "$id**\n";
        	$tax='Unknown';
        }
        if ($kingdom eq '' || not defined $kingdom){
        	$kingdom='Unknown';
        }
        # ($nt,$ct)=($_=~/ \{\|([0-9]+)\(([0-9]+)\)</);
        # print "$id\t-$tax-\t-$kingdom-";
    }elsif ($_=~/^\{/){
        $_=~s/[{}()*]//g; 
    	@a=split(//,$_);
    	$ct=0;
    	foreach $res(@a){
    		# print "$res\n";
    		if ($res=~/[A-Z-]/){
    			$ct++;
    		}
    		if ($ct>=62 && $ct<=65){
    			if ($res=~/[a-z]/){
    				$ins{hv1}++;
    			}
    		}
    		if ($ct>=119 && $ct<=148){
    			if ($res=~/[a-z]/){
    				$ins{hv2}++;
    			}
    		}
    		if ($ct>=210){
    			if ($res=~/[a-z]/){
    				$ins{hv3}++;
    			}
    		}
    	}
    	# print "\t-$nterm-\n";
    	print "$fam\t$id\t$species\t$tax\t$kingdom\t$len\t$ins{hv1}\t$ins{hv2}\t$ins{hv3}\t$nterm";
    	if (exists $lenHash{$id}){
    		$Clen=$lenHash{$id}-($nterm+$len);
    		print "\t$Clen\t$lenHash{$id}\n";
    	}else{
    		print "\t-\t-\n";
    	}
    }
}

# print Dumper(\%ins);
# 	    while ($_ =~ /[a-z]+/g) {
#             push @ret, ( $-[0]."-".$+[0] );
#         }
#         foreach $val(@ret){
#         	# print $val;
#         	@a=split(/-/,$val);
#         	next if (abs($a[1]-$a[0])<$ARGV[1]);
#         	$i++;
#         	$one=$a[0]+$add;
#         	$two=$a[1]+$add;
#        		# print "$one-$two,";
#         	if ($one>=62 && $two<=65){
#         		print "$one-$two,\n$id,$tax,$kingdom\n$_\n";
#         	}
#         }
#         print "BLA";
#         $inserts{$id}=[@ret];
#     }
# }



# print Dumper( \%inserts );

# foreach $key(sort keys %inserts){
#     # print "KEY=>$key\n";
#     # my @value_arr = @{$inserts{$key}};
#     if (exists($start{$key})){
#         # print $key;
#         $add=$start{$key};
#     }else{
#         $add=0;
#     }
#     print "$key\t$add\t";
#     $i=0;
#     foreach $val(@{$inserts{$key}}){
#         @a=split(/-/,$val);
#         next if (abs($a[1]-$a[0])<$ARGV[1]);
#         $i++;
#         $one=$a[0]+$add;
#         $two=$a[1]+$add-1;
#         print "$one-$two,";
#     }
#     if ($i==0){
#         print "None";
#     }
#     print "\n";
#     # print "$key\t$inserts{$key}\n";
# }