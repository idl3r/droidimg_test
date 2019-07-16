#!/usr/bin/env bash

# Unpack
./unpack.sh

# Run test
./run_vmlinux.sh 2>&1 | tee log.txt

# Check results
grep -P "^\!\!\!TEST \d+ FAILED\!\!\!$" log.txt
if [ $? -eq 0 ]; then
    echo "Failure detected"
    exit 1
fi

exit 0
