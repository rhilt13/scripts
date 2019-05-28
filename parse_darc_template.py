#!/usr/bin/env python
import sys

with open(sys.argv[1], 'r') as listfile:
	for line in listfile.readlines():
		cols=line.strip().split('\t')
		pdb=cols[0]
		# save each pattern pair in the line as dictionary with pdb id and a counter as key
		# (use aligned position numbers to compare across pdbs)

# Iterate through the dictionary - find a way to iterate through all keys of a dictionary
# For each pdb pair,
	# compare all pairs of positions
	# If pair is present, continue, say its present
	# If pair is not present , flag that pattern pair, flag the pdb pair, 


## Output: Pattern pairs that are shared by the pair of pdbs compared, pattern pairs that are unique to each pdb
## Output: Count of how many pdbs each pattern pair occurs in

		# define a dictionary
		store[pdb]={}
		
		# Syntax to assign values to a dictionary
		store[pdb]['pattern1']=cols[num1] # Change <num1> to appropriate column number
		store[pdb]['pattern2']=cols[num2]
