.global cpu_get_msr
.type cpu_get_msr, @function
cpu_get_msr:
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %eax
    movl    %eax, %ecx
    rdmsr
    movl    %eax, %ecx
    movl    12(%ebp), %eax
    movl    %ecx, (%eax)
    movl    16(%ebp), %eax
    movl    %edx, (%eax)

    leave
    ret

.global cpu_set_msr
.type cpu_set_msr, @function
cpu_set_msr:
    pushl   %ebp
    movl    %esp, %ebp

    movl    8(%ebp), %ecx
    movl    12(%ebp), %eax
    movl    16(%ebp), %edx
    wrmsr

    leave
    ret

.global read_cr2
.type read_cr2, @function
read_cr2:
    pushl   %ebp
    movl    %esp, %ebp

    movl    %cr2, %eax

    leave
    ret
