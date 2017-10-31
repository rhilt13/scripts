#! /bin/bash

## Run hieraln to get profiles from omcbpps output

## Input:
## $1 - Input prefix
## $2 - Output prefix
## $3 - realign?
## $4 -

## Start from omcBPPS output directory
## Must have 	*.mma ( original mma file, not the _new.mma)
##				*_new.sets or *_chk.sets
##				*_new.hpt or *_chk.hpt

## Example run
## In folder /home/rtaujale/rhil_project/GT/GT-A/omcbpps_revise3/non-gt2
## 
mkdir hier 
cp $1.mma hier/$2.mma

## Check to see if _new.sets and _new.hpt files present
if [ -f $1_new.sets ]; then 
	cp $1_new.sets hier/$2.sets
elif [ -f $1_chk.sets ]; then
	cp $1_chk.sets hier/$2.sets
else
	echo "No sets file. Check for *.sets file."
	exit 1
fi

if [ -f $1_new.hpt ]; then 
	cp $1_new.hpt hier/$2.hpt
elif [ -f $1_chk.hpt ]; then
	cp $1_chk.hpt hier/$2.hpt
else
	echo "No hpt file. Check for *.hpt file."
	exit 1
fi

cd hier
if [ $3 == "realign" ]; then
	hieraln $2 -realign
else
	hieraln $2
fi
## After running this, use run_hierview_omcbpps.sh