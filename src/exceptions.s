.section .text

.global exception_0
.global exception_1
.global exception_2
.global exception_3
.global exception_4
.global exception_5
.global exception_6
.global exception_7
.global exception_8
.global exception_9
.global exception_10
.global exception_11
.global exception_12
.global exception_13
.global exception_14
.global exception_15
.global exception_16
.global exception_17
.global exception_18
.global exception_19
.global exception_20
.global exception_21
.global exception_22
.global exception_23
.global exception_24
.global exception_25
.global exception_26
.global exception_27
.global exception_28
.global exception_29
.global exception_30
.global exception_31
.global exception_128

exception_handler:
    pusha
    xorl    %eax, %eax
    movw    %ds, %ax
    pushl   %eax

    pushl   %esp

    movl    $0x10, %eax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs

    call    isr_exception_handler

    popl    %eax
    popl    %ebx
    movw    %bx, %ds
    movw    %bx, %es
    movw    %bx, %fs
    movw    %bx, %gs

    popa
    addl    $0x8, %esp

    sti
    iret

#TODO: create macros for excepions for easier readability and maintainability 
exception_0:
    cli
    pushl   $0
    pushl   $0
    jmp     exception_handler

exception_1:
    cli
    pushl   $0
    pushl   $1
    jmp     exception_handler

exception_2:
    cli
    pushl   $0
    pushl   $2
    jmp     exception_handler

exception_3:
    cli
    pushl  $0
    pushl  $3
    jmp    exception_handler

exception_4:
    cli
    pushl  $0
    pushl  $4
    jmp    exception_handler

exception_5:
    cli
    pushl  $0
    pushl  $5
    jmp    exception_handler

exception_6:
    cli
    pushl  $0
    pushl  $6
    jmp    exception_handler

exception_7:
    cli
    pushl  $0
    pushl  $7
    jmp    exception_handler

exception_8:
    cli
    pushl  $8
    jmp    exception_handler

exception_9:
    cli
    pushl   $0
    pushl   $9
    jmp     exception_handler

exception_10:
    cli
    pushl   $10
    jmp     exception_handler

exception_11:
    cli
    pushl   $11
    jmp     exception_handler

exception_12:
    cli
    pushl   $12
    jmp     exception_handler

exception_13:
    cli
    pushl   $13
    jmp     exception_handler

exception_14:
    cli
    pushl   $14
    jmp     exception_handler

exception_15:
    cli
    pushl   $0
    pushl   $15
    jmp     exception_handler

exception_16:
    cli
    pushl   $0
    pushl   $16
    jmp     exception_handler

exception_17:
    cli
    pushl   $0
    pushl   $17
    jmp     exception_handler

exception_18:
    cli
    pushl   $0
    pushl   $18
    jmp     exception_handler

exception_19:
    cli
    pushl   $0
    pushl   $19
    jmp     exception_handler

exception_20:
    cli
    pushl   $0
    pushl   $20
    jmp     exception_handler

exception_21:
    cli
    pushl   $0
    pushl   $21
    jmp     exception_handler

exception_22:
    cli
    pushl   $0
    pushl   $22
    jmp     exception_handler

exception_23:
    cli
    pushl   $0
    pushl   $23
    jmp     exception_handler

exception_24:
    cli
    pushl   $0
    pushl   $24
    jmp     exception_handler

exception_25:
    cli
    pushl   $0
    pushl   $25
    jmp     exception_handler

exception_26:
    cli
    pushl   $0
    pushl   $26
    jmp     exception_handler

exception_27:
    cli
    pushl   $0
    pushl   $27
    jmp     exception_handler

exception_28:
    cli
    pushl   $0
    pushl   $28
    jmp     exception_handler

exception_29:
    cli
    pushl   $0
    pushl   $29
    jmp     exception_handler

exception_30:
    cli
    pushl   $0
    pushl   $30
    jmp     exception_handler

exception_31:
    cli
    pushl   $0
    pushl   $31
    jmp     exception_handler

exception_128:
    cli
    pushl   $0
    pushl   $128
    jmp     exception_handler
