#! /usr/bin/perl -w 

use Bio::SeqIO;
use Data::Dumper;
$Data::Dumper::Sortkeys = sub { [sort { $a <=> $b } keys %{$_[0]}] };
# sort { $a <=> $b } keys(%hash)

# ARGV[0]= multiple sequence alignment file (cma) (insert regions need to be lowercase)
# ARGV[1]= 10 (int, consider insert only if longer than this)
# ARGV[2]= file with a start point for each sequence (pdb_list.mapped.details)
if (exists $ARGV[2]){
    open(IN2,$ARGV[2]);
    while(<IN2>){
        chomp;
        @a=split(/\t/,$_);
        @b=split(/-/,$a[1]);
        @c=split(/,/,$a[1]);
        $id=$a[0]."_".$c[1];
        $start{$id}=$b[0];
        # print "ID=>",$id;
    }
}

open(IN,$ARGV[0]);
while(<IN>){
    @ret=();
	if ($_=~/^>/){
        # print $_;
        # $_=~s/^>//;
        # $full_id=$_;
        # $id=substr $_,0,4;  # for pdb IDs ( Change as required)
        ($id)=($_=~/^>(.*?)\s/);
        # print $id;
    }elsif ($_=~/^\{/){
    chomp;
        $_=~s/[{}()*-]//g;
        # print $_;    
	    while ($_ =~ /[a-z]+/g) {
            # print $_;
            push @ret, ( $-[0]."-".$+[0] );
        }
        # print "IDseq $id\n";
        $inserts{$id}=[@ret];
    }
}
# print Dumper( \%inserts );
    # print @ret
foreach $key(sort keys %inserts){
    # print "KEY=>$key\n";
    # my @value_arr = @{$inserts{$key}};
    if (exists($start{$key})){
        # print $key;
        $add=$start{$key};
    }else{
        $add=0;
    }
    print "$key\t$add\t";
    $i=0;
    foreach $val(@{$inserts{$key}}){
        @a=split(/-/,$val);
        next if (abs($a[1]-$a[0])<=$ARGV[1]);
        $i++;
        $one=$a[0]+$add;
        $two=$a[1]+$add-1;
        print "$one-$two,";
    }
    if ($i==0){
        print "None";
    }
    print "\n";
    # print "$key\t$inserts{$key}\n";
}