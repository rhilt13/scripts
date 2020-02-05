#!/usr/bin/env python
from Bio import SeqIO
import sys

i=0;
# args 1 - input genbank file
with open(sys.argv[1],"rU") as input_handle:
	for rec in SeqIO.parse(input_handle, "genbank"):
		# print(rec)
		for feature in rec.features:
			if feature.type == 'CDS':
				if 'translation' in feature.qualifiers:
					i=i+1
					# print(feature)
					# print("###>>>",feature.type)
					print ">ORF%s %d-%d(%s)" % (i,int(feature.location.start),int(feature.location.end),feature.location.strand),
					# print ">ORF%s %d=%d",i,"~",int(feature.location.start),"-",int(feature.location.end),feature.location.strand,
					print "|%s|%s|%s" % (feature.qualifiers['standard_name'][0],feature.qualifiers['product'][0],feature.qualifiers['note'][0])
					# print "|%s" % (feature.qualifiers['product'][0]),
					# print "|%s" % (feature.qualifiers['note'][0])
					print feature.qualifiers['translation'][0]
				# for key, val in feature.qualifiers.items():
					# print feature.location.strand,key,val
					#print("Protein id: {0}\n{1}: {2}\n{3}\n\n".format(feature.qualifiers['protein_id'][0], key, val[0], feature.qualifiers['translation'][0]))                   
                    