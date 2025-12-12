.section .text

.global load_gdt
.type load_gdt, @function
load_gdt:
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %eax
    lgdt    (%eax)

    jmp     $0x08, $.reload_cs
.reload_cs:
    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movw    %ax, %ss
    
    leave
    ret

.global load_tss
.type load_tss, @function
load_tss:
    pushl   %ebp
    movl    %esp, %ebp

    movw    $0x28, %ax
    ltr     %ax

    leave
    ret
    