#! /bin/bash 

keys=($(cat list))

for k in "${keys[@]}"
do
	# line= $(grep -f temp $k)
	word=$(echo $k|sed 's/\.m$//')
	# echo "$word"
	line=$(cat $k|grep ")$\|);"|grep -v function|grep -f temp |grep -v $word|grep -v "^%")
	if [[ $line ]]; then
		echo ">>>$k"
	    	echo "$line"
	fi
done;


