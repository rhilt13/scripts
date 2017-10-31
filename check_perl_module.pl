#! /usr/bin/perl
eval 'require JSON;';
if ($@) { 
    print "We don't have bioperl\n"; 
}
else {
    print "Bioperl found\n";
}

