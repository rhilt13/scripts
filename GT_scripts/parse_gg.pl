#!/usr/bin/perl -w

open(IN,$ARGV[0]);
$ct=0;
$a=0;
@pat=(qr/GGDB Symbol/,qr/Alias/,qr/Organism/,qr/Expression/,
      qr/GeneID/,qr/HGNC/,
      qr/Acceptor Substrates \(Reference\)/, qr/Acceptor Substrates \(KEM-C\)/,
      qr/Orthologous Gene/,qr/map/,qr/EC#/,
      qr/CAZy/,qr/OMIM/,qr/Designation/,);
@pat2=(qr/mRNA/,qr/Protein/,);

@g=split(/_/,$ARGV[0]);
$out.=$g[0]."\t";
while(<IN>){
  chomp;
  if ($_=~/Open ALL Close ALL/){
    $ct=1;
    next;
  }
  if ($_=~/^Biological Resources$/){
    $ct=0;
  }
  if ($ct==1){
    if ($_=~/^\[IMAGE\]$/){
      next;
    }
    if ($_=~/^[-=]+$/){
      next;
    }
    if ($_=~/^Orthologous Gene$/){
      $a=1;
    }
    $_=~s/\[IMAGE\] /=/g;
    $_=~s/ \(CDS\)$//g;
    foreach $p(@pat){
      if ($_=~/^$p$/){
        $out.="\t$_:\n";
          goto SKIP;
      }
    }
    if ($a==1){
      foreach $p(@pat2){
        if ($_=~/^$p$/){
          $out.="/$_:\n";
          goto SKIP;
        }
      }
    }else{
      foreach $p(@pat2){
        if ($_=~/^$p$/){
          $out.="\t$_:\n";
          goto SKIP;
        }
      }
    }
    $out.="$_\n";   
  }
  SKIP:
}

print $out;