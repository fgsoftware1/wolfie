target remote localhost:1234
symbol-file isodir/boot/kernel.elf
set architecture i386
break _start
continue
