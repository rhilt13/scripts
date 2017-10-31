#! /bin/bash
if [[ "$2" == *\/ ]]; then
    	dest=$2$1
 else
 	file=$2
 	file+="/"
 	dest=$file$1
fi
# echo "$dest"

if [ -f $dest ]; then
	echo ">>>$1"
	d=$(diff $1 $dest)
	if [[ $(diff $1 $dest) ]]; then
	    echo "$d"
	else
		mv $1 $2
		echo "Copy found. No difference. Transfer complete."
	fi
else
	#mv $1 $2
	echo "$1 File not found."
fi
