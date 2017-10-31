#!/usr/bin/env python2.7

"""Print the first several pdb files in Gromacs trajectory snapshots

The script is used to replace print_first_pdb.py
"""

import sys

def main(args):
    pdbfile = args.trj
    pdbnum = args.num
    n = 1
    with pdbfile as pdb:
        cur_context = ""
        for i in pdb.readlines():
            if not i.startswith('ENDMDL'):
                cur_context = cur_context+i
            else:
                cur_context = cur_context+i
                f = open(args.dir + str(n) + '.pdb', 'w')
                f.write(cur_context)
                f.close()
                cur_context = ""
                print n
                if n == pdbnum:
                    break
                else:
                    n += 1

if __name__ == '__main__':

    from argparse import ArgumentParser
    from argparse import FileType

    parser = ArgumentParser(description=sys.__doc__)
    parser.add_argument('-n', dest='num', action='store', default=1,
                        type=int, help='number of pdbs to print')
    parser.add_argument('-t', dest='trj', action='store', type=FileType('r'), required=True)
    parser.add_argument('--split', dest='dir', action='store', type=str, required=True)

    args = parser.parse_args()
    main(args)

