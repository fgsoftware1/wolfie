#!/bin/fish

mkdir -p build/src

for file in (find src -type f -name "*.s")
    set out_file build/(string replace -r '\.s$' '.o' $file)
    echo "--AS ASSEMBLING $file"
    as --32 -o $out_file $file > /dev/null 
end

set c3_files (find src -type f -name "*.c3")
echo "--C3 COMPILING $c3_files"
c3c compile-only --no-entry --target elf-x86 --use-stdlib=no --link-libc=no -O0 --single-module=yes -o build/src/c3_combined.o $c3_files > /dev/null
rm -rf obj

set obj_files (find build -type f -name "*.o")
echo "--LD LINKING $obj_files"
ld -T src/linker.ld -m elf_i386 -o kernel.elf $obj_files
mv kernel.elf isodir/boot/
grub-mkrescue -o wolfieOS.iso isodir
