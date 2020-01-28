#!/usr/bin/env python3
from Bio import SeqIO
import sys

# args 1 - input genbank file

for rec in SeqIO.parse(sys.argv[1], "gb"):
    for feature in rec.features:
        for key, val in feature.qualifiers.items():
            print("Protein id: {0}\n{1}: {2}\n{3}\n\n".format(feature.qualifiers['protein_id'][0], key, val[0], feature.qualifiers['translation'][0]))                   
                    