#! /usr/bin/env perl

use Bio::SeqIO;
use Data::Dumper;

{                                                                               # using a naked block to avoid variable overlaps
# open(IN,$ARGV[0]) "/home/z1717783/assign2_gene.fa" or die "No DNA sequence file.";
# open(OUT,$ARGV[1] ">assign2_protein.fa" or die " Couldn't open protein output file";    # the file with all the proteins

my $codon;      my $prot_id;            my $base_length;        my @codon_list;
my $protein;    my %translate_code;     my %pep_fa;             my $num;        my %num_hash;

$new=Bio::SeqIO->new(-file=>$ARGV[0], -format=>"fasta");

translate();          # invoke sub routine 1

while($seq=$new->next_seq){
    $protein='';
    $i=$seq->id;
    $d=$seq->desc;
    $d=' '.$d;
    $s=$seq->seq;
    $s=uc $s;
    $base_length = length($s);
    for (my $ct=0; $ct < $base_length - 2; $ct += 3){
        $codon = substr $s, $ct, 3;                    # breaking down sequence to codons
        push @codon_list, $codon;
        if (exists $translate_code{$codon}){ 
            $protein .= $translate_code{$codon};    # to remove errors with X's
        }
    }
    $protein =~s/!//g;
    print ">$i$d\n$protein\n";
}

sub translate{
        %translate_code =(
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => '!',    # Stop
    'TAG' => '!',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => '!',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
    'NNN' => 'X',    # Unknown                                          # translates series of Ns to Xs  
    );
        foreach my $codon(keys %translate_code){
                return $translate_code{$codon};
        }
}
}                                                                               # End of Naked Block
