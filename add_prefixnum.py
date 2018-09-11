#!/usr/bin/env python2.7
from Bio import Phylo
import re
def add_num(tree):
    import string, random
    def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
        return ''.join(random.choice(chars) for x in range(size))
    i = 0
    j = 0
    for clade in tree.find_clades():
        if clade.name is not None:
            n=re.sub(r'[^\w]', '', clade.name)
            if len(sys.argv) > 3:
                clade.name = str(i) + '_' + n
            else:
                clade.name = n
        else:
            if len(sys.argv) > 3:
                clade.name = str(i) + '_' + "I" + str(j)
            else:
                clade.name = "I" + str(j)
            j+=1
        i += 1
    return tree

if __name__ == "__main__":
    import sys
    Phylo.write(add_num(Phylo.read(sys.argv[1], 'newick')), sys.argv[2], 'newick')
