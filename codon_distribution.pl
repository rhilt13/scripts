#! /usr/bin/perl

use Bio::SeqIO;
use Data::Dumper;

open(IN,$ARGV[0]);		# gly sites list file
$first_line=<IN>;
if ($_=~/^#/){
	$first_line=<IN>;
}

@a=split(/\t/,$first_line);
$id=$a[0];
$num=$a[1]*3 - 3;
#$num=$a[3]*3 - 3;
push @pos,$num;
while(<IN>){
	chomp $_;
	# next if ($_=~/^#/);
	@a=split(/\t/,$_);
	$no_of_sites{$a[0]}=$a[4];
	if ($a[0] eq $id){
		$num=$a[1]*3 - 3;
		#$num=$a[3]*3 - 3;
		push @pos, $num;
	}else{
		$id_hash{$id}= [@pos];
		$id=$a[0];
		@pos=();
		$num=$a[1]*3 - 3;
		#$num=$a[3]*3 - 3;
		push @pos,$num;
	}
}
# print Dumper(\%id_hash);
# print Dumper(\%no_of_sites);

open(IN2,$ARGV[1]);			# codon scores file
while(<IN2>){
	chomp;
	@b=split(/\t/,$_);
	@c=split(/\(/,$b[1]);
	$codon_hash{$b[0]}=$c[0];
}
# print Dumper(\%codon_hash);

# =ccc
$new=Bio::SeqIO->new(-file=>$ARGV[2], -format=>"fasta");
print "+CDS_ID\tsites/protein\tsite\tloc\n";

while($seq=$new->next_seq){
	$id = $seq->id;
	$seq = $seq->seq;
	if (defined $id_hash{$id}){
		# print "aa\n";
		foreach $gly(@{$id_hash{$id}}){
			# print "$gly\n";
			@score=();
			@out=();
			if (($gly+300)<length($seq)){
				$str=substr $seq, $gly, 300;
			}else{
				$str=substr $seq, $gly;
			}
			# print "$gly\t$str\n";
			for ($i=0;$i<length($str);$i+=3){
				$codon=substr $str,$i,3;
				$codon=uc($codon);
				# print "$gly\t$codon\n";
				push(@score,$codon_hash{$codon});
			}
			# foreach $z(@score){
			# 	print "$z\n";
			# }
			# print "-----------------\n";
			# print "$id\t$gly\t@score\n";
			@out=slide_win(\@score);
			# get_win(\@score,0);
			$aa=$gly/3 +1;
			foreach $result(@out){
				print "$id\t$no_of_sites{$id}\t$aa\t$result\n";
			}
		}
	}
}

sub slide_win{
	($one)=@_;
	@score=@{$one};
	# print "@score\n";
	@out=();
	for ($j=0;$j<(scalar(@score)-6);$j++){	## Window size line 1 of 3
		# print "$j\n";
		@win=get_win(\@score, $j);
		# print "@win\n";
		@low= grep {$_ < 13} @win;	## Threshold for codon frequency
		# print "@low\n";
		if (scalar(@low) >= 5){		## No. below threshold within window
			$pos=$j;
			push (@out, $pos);
			# print "@out\n";
			$j=$j+6;		## Window size line 2 of 3
		}
	}
	# print "@out\n";
	return (@out);
}
sub get_win {
	@win=();
	# print "bb\n";
	($one, $two)=@_;
	@str=@{$one};
	# foreach $z(@str){
	# 	print "$z\n";
	# }
	for ($ct=$two;$ct<$two+7;$ct++){	## Window size line 3 of 3
		# print "$ct\t$str[$ct]\n";
		push @win, $str[$ct];
	}
	# print "@win\n";
	return (@win);
}
