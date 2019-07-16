#!/usr/bin/env bash

for filename in vmlinux*; do
    archive_file=_${filename}.7z
    if [ -f "$archive_file" ]; then
        echo "Skipping ${filename}"
    else
        7za a -mx=9 _${filename}.7z ${filename}
    fi
done

cd ref

for filename in kallsyms*.txt; do
    archive_file=_${filename}.7z
    if [ -f "$archive_file" ]; then
        echo "Skipping ${filename}"
    else
        7za a -mx=9 _${filename}.7z ${filename}
    fi
done
