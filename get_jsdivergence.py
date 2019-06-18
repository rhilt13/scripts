#! /usr/bin/env python

def read_aln(file):
    # Read fasta alignment file into a numpy array
    import numpy as np
    from Bio import SeqIO

    records = SeqIO.parse(file, "fasta")
    align_array = np.array([record.seq for record in records], np.character)
    # print("Array shape %i by %i" % align_array.shape)
    return (align_array)

def get_distribution(aln,pos):
    # Get the distribution of amino acids at any given position in numpy alignment
    from collections import Counter

    aa_codes=["A","C","D","E","F","G","H","I","K","L","M","N","P","Q","R","S","T","V","W","Y","-"]
    PSEUDOCOUNT=.0000001
    count_dist=list()
    counts=Counter(aln[:,pos])
    for aa in aa_codes:
        if counts[aa]==0:
            counts[aa]=PSEUDOCOUNT
        count_dist.append(counts[aa])           
    return (count_dist)

def jensen_shannon(p,q):
    # """
    # Calculate Jensen-Shannon divergence of 2 vectors.
    # """
    import numpy as np
    from scipy.stats import entropy

    p=np.array([float(i) for i in p])
    q=np.array([float(i) for i in q]) 
    p, q = p.flatten(), q.flatten()
    p, q = p/p.sum(), q/q.sum()
    m = (p + q) / 2
    return (entropy(p, m) + entropy(q, m)) / 2

def main(args):
    import sys

    f_ar=read_aln(args.foreground)
    b_ar=read_aln(args.background)
    if  f_ar.shape[1] != b_ar.shape[1]:
        print "==>No. of columns in the 2 alignments dont match."
        print "==>Exiting.."
        sys.exit()
    ###### Tests #############
    # i=125
    # f_dist=get_distribution(f_ar,i)
    # b_dist=get_distribution(b_ar,i)
    # print f_dist
    # print b_dist
    # jsd=jensen_shannon(f_dist,b_dist)
    # jss=1-jsd   # {Get a similarity metric instead of divergence}
    # print i,"\t",jss   
    ###########################
    # f_dist=[1e-07, 321, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07]
    # b_dist=[1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 1e-07, 2]
    # jsd=jensen_shannon(f_dist,b_dist)
    # jss=1-jsd   # {Get a similarity metric instead of divergence}
    # print jsd,"\t",jss
    ############################
    for i in range(0, f_ar.shape[1]):
        f_dist=get_distribution(f_ar,i)
        b_dist=get_distribution(b_ar,i)
        jsd=jensen_shannon(f_dist,b_dist)
        jss=1-jsd   # {Get a similarity metric instead of divergence}
        print i+1,"\t",jss


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
           description="Calculate JSD between 2 given alignments. Positiosn must be aligned across the 2 alignments.",
           epilog="Contact Rahil for help.")
    parser.add_argument('-f', '--foreground', help='First Alignment', required=True)
    parser.add_argument('-b', '--background', help='Second Alignment', required=True)

    args = parser.parse_args()
    main(args)