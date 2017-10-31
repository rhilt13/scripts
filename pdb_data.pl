#! /usr/bin/perl -w 

# Use:
# perl ~/rhil_project/scripts/pdb_data.pl <pdb_code> <res_num> <pdb_code> <res_num> ......

$path="/home/rtaujale/rhil_project/GT/pdb/str";

$sec="##### Secondary Struture:\n#H:Alpha helix|B:Beta bridge|E:Strand|G:Helix-3|I:Helix-5|T:Turn|S:Bend\n";
$dist= "##### Distance:\n";
$surf= "##### Surface Area:\n";
$ener= "##### Energy:\n";

while (scalar(@ARGV) > 0) {
    $pdb = shift(@ARGV);
    $no = shift(@ARGV);
    # print "i: $i, j:$j\n";
    if (!$pdb || !$no){
    	die ("ERROR: Not enough arguments in pairs!!!");
    }
    $sec= $sec."### $pdb\nS.No. ";
    $sec= $sec.`cat $path/2oSTRUCT/$pdb.dssp|grep '^ \\+#\\|^ \\+[0-9]\\+ \\+$no '`;
    $dist= $dist."### $pdb\n";
    $dist= $dist.`cat $path/DISTANCE/$pdb.min|grep ' $no '`;
    $surf= $surf."### $pdb\n";
    $surf= $surf.`cat $path/SURF_AREA/$pdb.asa|grep ' $no '`;
    $ener= $ener."### $pdb\n";
    # $ener= $ener.`cat $path/ENERGY/$pdb.ener|grep ' $no '`;
    # $ener= $ener.`cat $path/ENERGY/$pdb.ener|grep ' $no '|awk 'BEGIN{FS=" "}{print \$0}'`; #{if (sqrt(($10)^2) > 50 || sqrt(($13)^2) > 10 || sqrt(($16)^2) > 10){print $0}}'`;
    $ener= $ener.`cat $path/ENERGY/$pdb.ener|grep ' $no '|awk 'BEGIN{FS=" "}{if ($1~/ARG/ || $5~/ARG/ || sqrt((\$10)^2) > 5 || sqrt((\$13)^2) > 1 || sqrt((\$16)^2) > 1){print \$0}}'`;
    $ener= $ener.`cat $path/ENERGY/$pdb.ener|grep ' $no '|awk 'BEGIN{FS=" "}{if (sqrt((\$10)^2) > 5 || sqrt((\$13)^2) > 1 || sqrt((\$16)^2) > 1){print \$0}}'`;
}
print $sec,$dist,$surf,$ener

# #ener -ve favorable
# <-1 kcal/mol - interaction exist
# avg strength of h bond 2.5 kcal/mol
# 0 -.5 -1 -1.5 -2 

# salt bridge - -3 - -6

# #Distance
# 5 Ao

# 10 Ao - 