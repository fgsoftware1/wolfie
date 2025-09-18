.section .text

.global disable_interrupts
.type disable_interrupts, @function
disable_interrupts:
    cli
    ret

.global enable_interrupts
.type enable_interrupts, @function
enable_interrupts:
    sti
    ret

.global halt
.type halt, @function
halt:
    hlt

.global inportb
.type inportb, @function
inportb:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %edx
    xor %eax, %eax
    inb %dx, %al

    leave
    ret

.global outportb
.type outportb, @function
outportb:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %edx   
    movl 12(%ebp), %eax   
    outb  %al, %dx        

    leave
    ret
