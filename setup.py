#!/usr/bin/env python

import os, sys
script = os.path.basename(__file__)
source_dir = os.path.abspath('./' + os.path.dirname(__file__) + "/")

for f in os.listdir(source_dir):
    if f in [script, '.git', '.gitignore']:
        continue

    destination = os.path.expanduser('~') + "/" + f
    source = source_dir + "/" + f
    try:
        os.symlink(source, destination)
        print "\033[36;1m" + source + "\033[0m ->", destination
    except OSError as e:
        if e.errno == 17:
            try:
                if os.readlink(source) == destination:
                    print source, "is already linked"
                else:
                    print source, "\033[31;1mexists\033[0m (symlink)"
            except OSError as e:
                if e.errno == 22:
                    print source, "\033[31;1mexists\033[0m"
                else:
                    print e
        else:
            print e
