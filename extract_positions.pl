#! /usr/bin/perl -w

use Bio::SeqIO;
use Data::Dumper;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");
$seqct=0;
while($seq=$new->next_seq){
	$i=$seq->id;
	$s=$seq->seq;
	$seqct++;
	($st,$end)=($i=~/.*\/(\d+)-(\d+)/);
	if ($st > $end){
		($st, $end) = ($end, $st);
	}
	if ($seqct%2!=0){ 	# CP
		$cphash=store_base($st,$s);
#		print "%$cphash\n";
#		$start=206573;
#		$end=234395;
#		$s =~ s/-//g;
#		my $section = substr($s, $start-1, $end-$start);
#		print "$section\n";
		
	}else {		# Tahoma
#print "$i\tTa\n";
		($tahash,$map)=store_base_map($st,$s);
#       	print $seq->id,"\t$len\n";
#	        $hash{$seq->id}=$len;
#	}else{
#
#	}
	}
}

#print Dumper(\%$cphash);

open(IN,$ARGV[1]);
@c=split(/\./,$ARGV[0]);
$cp=">$c[0]\n";
$ta=">Tohama_1954\n";
while(<IN>){
	chomp;
#	print "$_\t${$cphash}{$_}\t${$tahash}{$_}\t${$map}{$_}\t${$tahash}{${$map}{$_}}\t${$cphash}{${$map}{$_}}\n";
	if (exists ${$map}{$_} && ${$cphash}{${$map}{$_}} && ${$tahash}{${$map}{$_}}){
		$cp.=${$cphash}{${$map}{$_}};
		$ta.=${$tahash}{${$map}{$_}};
	}elsif (!exists ${$map}{$_}){
		$report.="$_ - Missing map.Not aligned in reference.\n";
	}elsif (!exists ${$cphash}{${$map}{$_}}){
		$report.="$_ - Missing CP position.Not aligned in CP.\n";
	}elsif (!exists ${$tahash}{${$map}{$_}}){
		$report.="$_ - Missing Tohama position.Not aligned in .\n";
	}else{
		$cp.="X";
		$ta.="X";
	}
}
print "$cp\n$ta\n$report";

sub store_base {
	my ($val_st,$seq)=@_;
#	print "$val_st\n";
	@base=split(//,$seq);
	foreach $b(@base){
#		print "$b";
		$cpbase_hash{$val_st}=$b;
		$val_st++;
	}
	return(\%cpbase_hash);
}

sub store_base_map {
        my ($val_st,$seq)=@_;
	my $tact=$val_st;
#	print "$val_st\n";
        @base=split(//,$seq);
        foreach $b(@base){
#		print "$b";
                $tabase_hash{$val_st}=$b;
                if ($b ne '-'){
			$pos_map{$tact}=$val_st;
			$tact++;
		}
		$val_st++;
        }
        return(\%tabase_hash,\%pos_map);
}

