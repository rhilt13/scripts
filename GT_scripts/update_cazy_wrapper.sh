#! /bin/bash

### Things to do Manually:

#	Create a new folder called CAZy_fam_update[]
#	cd into the directory. Sub folders will be created automatically.

#	Get number of CAzy families from http://www.cazy.org/GlycosylTransferases.html
# 	Adjust number range in [num1]

## PART 1: Get family information General
#	Out: CAZy_fam_details
#	Sub: A, B, C, u and lyso

mkdir 
for i in {1..101}; do 		#[num1]
	wget -q -O GT$i.html "http://www.cazy.org/GT${i}.html"