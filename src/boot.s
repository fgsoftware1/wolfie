# For tags structure info refer to 
# https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html#Header-tags
.section .multiboot 
.align 8
multiboot_hdr_start:
    .long   0xE85250D6
    .long   0
    .long   multiboot_hdr_end - multiboot_hdr_start
    .long   -(0xE85250D6 + 0 + (multiboot_hdr_end - multiboot_hdr_start))
    .align 8
framebuffer_tag_start:
    .word 5
    .word 0 
    .long framebuffer_tag_end - framebuffer_tag_start
    .long 1024
    .long 768
    .long 32
framebuffer_tag_end:
    .align 8
end_tag_start:
    .word   0
    .word   0
    .long   end_tag_end - end_tag_start
end_tag_end:
multiboot_hdr_end:

.section .text

.global _start 
_start:
    xorl    %ebp, %ebp
    movl    $stack_top, %esp
    movl    %esp, %ebp
    pushl   %ebx
    pushl   %eax
    call    kmain

hang:
    cli
    hlt
    jmp hang

.section .bss
.align 16

.global stack_top
.global stack_bottom
stack_bottom:
    .space  16384
stack_top:
