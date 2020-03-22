#/bin/bash

cat $1|perl -lne 'if ($_=~/^>/){print $_;}elsif ($_=~/^\{/){$_=~s/[a-z{}()*]//g;$_=uc($_);print $_;}'
