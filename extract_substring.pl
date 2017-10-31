use Data::Dumper;
use Bio::SeqIO;

open (IN,$ARGV[0]);
while(<IN>){
        chomp;
        @a=split(/\t/,$_);
        ($st)=($a[2]=~/\:(\d+)\./);
        ($en)=($a[2]=~/\.(\d+)/);
        $a[0]=~s/^\s+|\s+$//g;
        $start{$a[0]}=$st;
        $end{$a[0]}=$en;
}
# print Dumper(\%end);
# =cc

$new=Bio::SeqIO->new(-file=>$ARGV[1], -format=>"fasta");

while($seq=$new->next_seq){
        foreach $id(sort keys %start){
                $id_name = $id;
                $id_start = $start{$id};
                $id_end = $end{$id};
                $st_pos = $id_start - 1;                        # correcting the start at 0 on perl and 1 in gff3 file
                $len = ($id_end - $id_start) + 1;               # calculating the length oc the cds 
                $cds_seq = substr $seq->seq, $st_pos, $len;
                print ">$id|$start{$id}-$end{$id}|$len\n$cds_seq\n";
        }
}
