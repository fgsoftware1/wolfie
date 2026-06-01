.section .text

irq_common_stub:
    pusha

    movw    %ds, %ax
    pushl   %eax                    # save ds

    movw    $0x10, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs

    pushl   %esp                    # CPURegs* arg
    call    isr_irq_handler
    addl    $4, %esp                # discard CPURegs* arg

    popl    %ebx                    # restore saved ds
    movw    %bx, %ds
    movw    %bx, %es
    movw    %bx, %fs
    movw    %bx, %gs

    popa
    addl    $0x8, %esp              # skip int_no + err_code
    iret

.macro IRQ num vec
    .globl irq_\num
    .type  irq_\num, @function
irq_\num:
    cli
    pushl   $0
    pushl   $\vec
    jmp     irq_common_stub
.endm

IRQ 0,  32
IRQ 1,  33
IRQ 2,  34
IRQ 3,  35
IRQ 4,  36
IRQ 5,  37
IRQ 6,  38
IRQ 7,  39
IRQ 8,  40
IRQ 9,  41
IRQ 10, 42
IRQ 11, 43
IRQ 12, 44
IRQ 13, 45
IRQ 14, 46
IRQ 15, 47
