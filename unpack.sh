#!/usr/bin/env bash

for filename in _vmlinux*.7z; do
    7za x -aoa ${filename}
done

cd ref

for filename in _kallsyms*.txt.7z; do
    7za x -aoa ${filename}
done
