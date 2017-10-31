#! /usr/bin/perl

## Input: annot_file

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	@a=split(/\t/,$_);
	$file=$a[0]."."."FASTA.press";
	# print "$file\n";
	if (-e $file){
		$cmd='cat '.$file.'|sed "s/'.$a[0].'/'.$a[1].'/" > '.$a[1].'.FASTA.press';
		$cmd2='rm '.$file;
		# print "$cmd\n";
		system($cmd);
		system($cmd2);
	}
}