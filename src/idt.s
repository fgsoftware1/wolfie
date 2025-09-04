.section .text

.global load_idt
.type load_idt, @function
load_idt:
    pushl %ebp
    movl %esp, %ebp

    mov 8(%ebp), %eax
    lidt (%eax)

    leave
    ret
