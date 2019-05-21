#!/usr/bin/env python

import __main__
import re

# Input:
# -i => dca_pml file with the list of dca couplings for each pdb structure

def main(args):

	# print store
	info=parse_pdbDetails(args.listfile)
	i=0
	out=''
	if args.insertlist is not None:
		ins=parse_insertfile(args.insertlist)
	if args.cma is not None:
		mapped_pos=map_aligned_pos(args.cma,info)
	if args.domains is not None:
		mapped_dom=map_domains(args.domains,mapped_pos)
	with open(args.inlist, 'r') as inlist:
		for line in inlist.readlines():
			if line.startswith("#"):
				continue
			i+=1
			gtfam,pdb=line.strip().split('\t')
			path=args.pathtostr.rstrip('\/')
			pdb_new=gtfam+"_"+pdb+"full"
			gtpdb=gtfam+"_"+pdb
			gtpdbss=gtpdb+"_ss"
			# print info[pdb]['ends']
			start,end=info[pdb]['ends'].split('-')
			start=str(int(start)-1)
			end=str(int(end)+1)

			# Load structure
			out+="cmd.load(\""+path+"/"+pdb+".pdb\")\n"
			out+="cmd.color(\"gray9\",\""+pdb+" and (resi 1-"+start+" or resi "+end+"-10000)\")\n"
			# Select GT domain
			out+="cmd.select(\""+gtpdb+"\",\"resi "+info[pdb]['ends']+" and "+pdb+" and chain "+info[pdb]['chain']+"\")\n"
			# Select sec. str. of GT domain
			out+="cmd.select(\""+gtpdbss+"\",\"(ss h+s) and "+gtpdb+"\")\n"
			out+="hide everything,"+pdb+"\n"
			out+="show cartoon, "+gtpdb+"\n"

			# Align to the first structure
			if (i==1):
				template=gtpdbss
			else:
				out+="cmd.cealign(\""+template+"\",\""+gtpdbss+"\")\n"
				# print "AA"

			# Map omcBPPS/mcBPPS patterns
			# print info[pdb]
			# print gtpdb
			# print info[pdb]['patterns']
			out+=map_patterns(gtpdb,info[pdb]['patterns'])

			# Map inserts
			pdb_ch=pdb+"_"+info[pdb]['chain']
			if pdb_ch in ins and ins[pdb_ch] != 'None':
				out+="cmd.select(\""+gtpdb+"Ins\",\""+gtpdb+" and resi "+ins[pdb_ch]+"\")\n"
				out+="cmd.color(\"gray3\",\""+gtpdb+"Ins\")\n"

			# Map domains
			for d in mapped_dom:
				if pdb in mapped_dom[d]:
					out+="cmd.select(\""+gtpdb+"_"+d+"\",\""+gtpdb+" and resi "+mapped_dom[d][pdb]+"\")\n"
					# print d,pdb

			# Change name to order everything
			out+="cmd.set_name(\""+pdb+"\",\""+pdb_new+"\")\n"

	#
	# print "OUTFILE------------",out
	# Map alignment positions
	# First, get alignment start position in pdb
	out+=set_default()
	if args.output is not None:
		with open(args.output, 'w') as pmlfile:
			pmlfile.write(out)

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Generate pml scripts as required based on input.",
           epilog="Contact Rahil for help.")
    parser.add_argument('-i', '--infile', help='Input dca_pml file from darc', required=True)

    args = parser.parse_args()
    main(args)