.section .multiboot 
.align 8
multiboot_hdr_start:
    .long 0xE85250D6
    .long 0
    .long multiboot_hdr_end - multiboot_hdr_start
    .long 0x100000000 - (0xE85250D6 + 0 + (multiboot_hdr_end - multiboot_hdr_start))
end_tag_start:
    .word 0
    .word 0
    .long end_tag_end - end_tag_start
end_tag_end:
multiboot_hdr_end:

.section .text

.global _start 
_start:
    xorl %ebp, %ebp
    movl $stack_top, %esp
    movl %esp, %ebp
    pushl %ebx
    pushl %eax
    call kmain

.section .bss
.align 16

.global stack_top
.global stack_bottom
stack_bottom:
    .space 16384
stack_top:
