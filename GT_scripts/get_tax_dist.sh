for i in `ls $1`; do
	j=$(echo $i|cut -f1 -d'.');
	less $1$i|grep '^>'|cut -f2 -d'|' > $j.gi;
	perl ~/rhil_project/scripts/get_tax_from_gi_eutil.pl $j.gi > $j.gi.tax;
	cat $j.gi.tax|cut -f1 -d';'|awk '{print $NF}'|sort|uniq -c > $j.gi.tax.cnt;
	cat $j.gi.tax|cut -f1,2 -d';'|awk '{print $(NF-1),"\t",$NF}'|sort|uniq -c > $j.gi.tax.cnt2;
done
