#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
# sort { $a <=> $b } keys(%hash)

# ARGV[0]= multiple sequence alignment file
# ARGV[1]=a # if want to print only aligned positions else leave blank
$re='\*\([0-9]+\)\*';
# $re='[0-9]+';
open(IN,$ARGV[0]);
while(<IN>){
	next if ($_=~/^>/);
	chomp;
	while ($_ =~ /\*\([0-9]+\)\*+/g) {
        push @ret, ( $-[0]."-".$+[0] );
    }
	#$mat=match_all_positions($re,$_);
	# foreach $m($mat){
	# 	print "$m\n";
	# }
	# print "---------------\n";
	#@arr=split(//,$_);
	#$ct=0;
	#foreach $posn(@arr){
# 		if ($_!~/[-A-Z]/ && $hash{$ct}<5){
# 			$hash{$ct}++;
# 		}else{
# 			$ct++;
# 		}
# 	}
}
foreach $p(@ret){
	@a=split(/-/,$p);
	$hash{$a[0]}=$a[1]-$a[0];
}
# print Dumper( \%hash );

$new1=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");        ## multiple sequence alignment
while($seq=$new1->next_seq){
    $id=$seq->id;
	$desc=$seq->desc;
    $s=$seq->seq;
    $i=1;
    print ">$id\n";
    $s=~s/[*()0-9]//g;
    @b=split(//,$s);
    $ct=1;
    foreach $pos(@b){
    	print "$pos";
    	if (exists $hash{$ct} && $b[$ct]!~/\*/){
			for ($i=0;$i<$hash{$ct};$i++){
				print "*";
			}
		}
		if($pos=~/[-A-Z]/){
			$ct++;
		}
    }
    print "\n";
    print "$ct\n";
}

# sub match_positions {
#     my ($regex, $string) = @_;
#     return if not $string =~ /$regex/;
#     return ($-[0], $+[0]);
# }
# sub match_all_positions {
#     my ($regex, $string) = @_;
#     my @ret;
#     while ($string =~ /$regex/g) {
#         push @ret, [ $-[0], $+[0] ];
#     }
#     print @$ret;
#     return @ret
# }
=ccc
sub match_positions {
    my ($regex, $string) = @_;
    return if not $string =~ /($regex)/;
    return (pos($string), pos($string) + length $1);
}
sub all_match_positions {
    my ($regex, $string) = @_;
    my @ret;
    while ($string =~ /($regex)/g) {
    	print "$regex\t$string\n";
    	print pos($string), pos($string) + length $1;
        push @ret, [pos($string), pos($string) + length $1];
        print @ret;
    }
    return @ret;
}