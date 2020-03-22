#! /usr/bin/env perl

# $ARGV[0] => input tpl or cma file
#

open(IN,$ARGV[0]);
while(<IN>){
	chomp;
	if ($_=~/^[{}*]/){
		$out1=fix1($_);
		#print "Out1=>$out1\n";
		if ($out1=~/^[{}()*]+?-/){
			$out2=fix2($out1);
			$out3=fix1($out2);
		}else{
			$out3=$out1;
		}
		$out3=reverse($out3);
		#print "Out3=>$out3\n";
		$out4=fix1($out3);
		#print "Out4=>$out4\n";
		if ($out4=~/^[{}()*]+?-/){
			$out5=fix2($out4);
			$out6=fix1($out5);
			#print "+++>>>Fixed one: $out4\n";
		}else{
			$out6=$out4;
		}
		$out6=reverse($out6);
		#print "Out6=>$out6\n";
		$out7=fix3($out6);
		print "$out7\n";
	}else{
		print "$_\n";
	}
}

sub fix1{
	my $in=$_[0];
	#print "Fix1 in=> $in\n";
	my $line;
	#print "Begin Fix1 line => $line\n";
	my @a;
	my $i;
	my $j;
	my $ent;
	if ($in=~m/\-[a-z]/){
		@a=split(//,$in);
		#print @a;
		for ($i=0;$i<=$#a;$i++){
			if ($a[$i] eq "-" && $a[$i+1]=~/[a-z]/){
				$a[$i+1]=uc($a[$i+1]);
				for ($j=$i+2;$j<=$#a;$j++){
					if ($a[$j]=~/-/){
						$ent=splice @a,$j,1;
						splice @a,$i,0,$ent;
					}elsif ($a[$j]=~/[A-Z]/){
						$a[$j]=lc($a[$j]);
						last;
					}
				}
			}
		}
		$line=join("",@a);
		#print "joined line=>$line\n";
	}else{
		$line=$in;
	}
	#print "Fix1 line=> $line\n";
	return($line);
}

sub fix2{
	my $in =$_[0];
	#print "Fix2 in=> $in\n";
	my $line2;
	if ($in=~/^[{}()*]+?-/){
		@b=split(//,$in);
		$ck=0;
		for ($i=0;$i<=$#b;$i++){
			if ($b[$i] eq "-" && $ck==0){
				$st=$i;
				$ck=1;
				# print "$i:$b[$i]:$st:$ck";
			}elsif ($b[$i]=~/[a-z]/){
				print "NEW ERROR:insertion before match after deletion at beginning: $_";
				last;
			}elsif ($b[$i]=~/[A-Z]/){
				$ent=splice @b,$i,1;
				splice @b,$st,0,$ent;
				last;
			}
		}
		$line2=join("",@b);
		#print $line2;
	}else{
		$line2=$in;
	}
	return($line2);
}

sub fix3{
	my $in=$_[0];
	my $line3;
	if ($in=~/-[a-z]+[A-Z]-/){
		#print "Found it => $in";
		@c=split(//,$in);
		$ck=0;
		my $ct3=0;
		for (my $i=0;$i<=$#c;$i++){
			if ($c[$i] eq "-"){
				#print "==Start loop here:\n";
				my $ck2=0;
				my $ct2=0;
				my $ct=0;
				for (my $j=$i;$j<=$#c;$j++){
					if ($c[$j] eq "-"){
						#print "$j:$c[$j]:$ct:$ck2:$ct2\n";
						if ($ck2==0){
							$ct++;
						}
						if ($ct2==1 && $ck2==1){
							#print "BLAHIT=> $j:$c[$j]:$ct:$ck2:$ct2\n";
							my @ent=splice @c,$i,$ct;
							#print "GAPS: @ent\n";
							splice @c,$j-$ct+$ct3,0,@ent;
							$ct3++;
							#$temp=join("",@c);
							#print "Temp=> $temp\n";
							$i=$j;
							$ct2=2;
							last;
						}elsif ($ct2>1){
							last;
						}
					}elsif ($c[$j]=~/[a-z]/){
						$ck2=1;
					}elsif ($c[$j]=~/[A-Z]/){
						$ct2++;	
					}
				}
			}
		}
		$line3=join("",@c);
	}else{
		$line3=$in;
	}
	return($line3);
}
