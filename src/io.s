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
    movl 4(%esp), %edx
    xor %eax, %eax
    inb %dx, %al
    ret

.global outportb
.type outportb, @function
outportb:
    mov 4(%esp), %edx
    mov 8(%esp), %eax
    outb %al, %dx
    ret
