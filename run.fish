#!/bin/fish

qemu-system-i386 -cdrom wolfieOS.iso -m 512M -display gtk,gl=on,zoom-to-fit=on \
    #-debugcon file:debug.log -d int,cpu_reset -D qemu.log -no-reboot