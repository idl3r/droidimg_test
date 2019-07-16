#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import json
import sys
import argparse

def print_err(*args):
    print("".join(map(str,args)), file=sys.stderr)

def print_out(*args):
    print("".join(map(str,args)), file=sys.stdout)

def main(argv):
    fname1 = argv[1]
    fname2 = argv[2]

    dict1 = {}
    with open(fname1, 'r') as f:
        lines = f.read()
        for line in lines.splitlines(False):
            items = line.split(' ')
            if len(items) != 3:
                continue

            addr = int(items[0], 16)
            t = items[1]
            symname = items[2]

            dict1[symname] = (addr, t)

    dict2 = {}
    with open(fname2, 'r') as f:
        lines = f.read()
        for line in lines.splitlines(False):
            items = line.split(' ')
            if len(items) != 3:
                continue

            addr = int(items[0], 16)
            t = items[1]
            symname = items[2]

            dict2[symname] = (addr, t)

    # shared_symbols = {k: dict1[k] for k in dict1 if k in dict2 and dict1[k] == dict2[k]}
    shared_symbols = {k: dict1[k] for k in dict1 if k in dict2}
    # print("%d %d %d" % (len(dict1), len(dict2), len(shared_symbols)))

    # We must have all symbols in the reference result
    if len(shared_symbols) < len(dict2):
        print_err("[!]result is %d symbols short" % (len(dict2) - len(shared_symbols)))
        sys.exit(1)

    # Check address
    for k in shared_symbols.keys():
        (addr1, t1) = dict1[k]
        (addr2, t2) = dict2[k]

        if addr1 != addr2:
            print_err("[!]address mismatch: %s (%x->%x)" % (k, addr2, addr1))
            sys.exit(1)

        if t1 != t2: # just warning
            print_err("[+]type mismatch:  %s (%s->%s)" % (k, t2, t1))

    # Everything looks fine
    print_err("[+]%d new symbols detected. Everything looks good" % (len(dict1) - len(dict2)))

if __name__ == "__main__":
    try:
        main(sys.argv)
    except:
        sys.exit(1)

    sys.exit(0)
