#!/bin/bash

mkdir -p build/src

find src -type f -name "*.c3" | while read -r file; do
    out_file="build/${file%.c3}.o"
    echo "--C3 COMPILING $file"
    c3c compile-only --no-entry --target elf-x86 --use-stdlib=no --link-libc=no -O0 --single-module=yes -o "$out_file" "$file" > /dev/null 
done

rm -rf obj
