#! /usr/bin/perl - w 

## Header file: bmse_ID	Name	PubChem_ID	Peak_ID	ChemShift	Coupling_pattern
## for i in `ls bmse_entries`; do perl ~/db/scripts/parse_bmrb_entries.pl bmse_entries/$i; done > nmr_peaks
## cat header nmr_peaks > peaklist_bmrb.txt


$chk=0;
$chk2=0;
$chk3=0;
$num=-1;
$num1=-1;
open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	$_=~s/^\s+//g;
	$_=~s/\s+$//g;
	next if ($_=~/^$/);
	if ($_=~/^save_entry_information/){
		$chk=1;
	}elsif ($_=~/^save_chem_comp_1/){
		$chk=2;
	}elsif ($_=~/^save_spectral_peak_1H$/){
		$chk=3;
	}elsif ($chk==1){
		if ($_=~/^_Entry.ID/){
			($id)=($_=~/\s+(.*)$/);
		}elsif ($_=~/^_Entry.Title/){
			($title)=($_=~/\s+(.*)$/);
		}elsif ($_=~/^loop_$/){
			$chk=0;
		}
	}elsif ($chk==2){
		if ($_=~/^_Chem_comp_db_link/){
			$chk2=1;
			$num1++;
			$col{$_}=$num1;
		}elsif ($chk2==1){
			if ($_=~/^stop_/){
				$chk=0;
			}else{
				$_=~s/\s\s+/\t/g;
				@b=split(/\t/,$_);
				if ($b[$col{"_Chem_comp_db_link.Accession_code_type"}] eq "cid"){
					$pubID{$id}=$b[$col{"_Chem_comp_db_link.Accession_code"}]
				}
			}
		}
	}elsif ($chk==3){
		if ($_=~/^_Peak_char/){
			$chk3=1;
			$num++;
			$col{$_}=$num;
		}elsif ($chk3==1){
			if ($_=~/^\d/){
				$_=~s/\s\s+/\t/g;
				@a=split(/\t/,$_);
				print "$id\t$title\t$pubID{$id}\t".$a[$col{"_Peak_char.Peak_ID"}]."\t".$a[$col{"_Peak_char.Chem_shift_val"}]."\t".$a[$col{"_Peak_char.Coupling_pattern"}]."\n";
			}elsif ($_=~/^stop_/){
				$chk=0;
			}
		}
	}
}
