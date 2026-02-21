#!/bin/fish

gdb --batch isodir/boot/kernel.elf | tee gdb_out.txt