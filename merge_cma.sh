#! /bin/bash

# $1 -> input multicma file
cat $1 |grep '^\$\|^>\|^\{' > a
cat $1 |head -2 > temp_head
cat $1 |tail -1 > temp_tail
j=$(cat a|grep '^>'|wc -l)
k=$(echo $1|sed 's/.cma//')
sed -i "s|)=.*([0-9]\+){|)=$k($j){|" temp_head
echo $j
cat temp_head a temp_tail >$k.merged.cma
rm temp_head a temp_tail
