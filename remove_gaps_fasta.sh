less $1|perl -lne 'if ($_=~/^>/){print $_;}else{$_=~s/-//g;print $_;}'
