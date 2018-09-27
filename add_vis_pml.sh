#! /bin/bash

cat $1|grep $2|grep -v cealign|sed "$ a cmd.create(\"$3_hyphoObj\",\"$3_hypho\")\ncmd.show(\"sticks\",\"$3_hyphoObj\")\ncmd.show(\"surface\",\"$3_hyphoObj\")\ncmd.set(\"cartoon_transparency\", 0.7)\ncmd.set(\"transparency\", 0.3)"