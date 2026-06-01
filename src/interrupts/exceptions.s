.section .text

.global exception_0,  exception_1,  exception_2,  exception_3
.global exception_4,  exception_5,  exception_6,  exception_7
.global exception_8,  exception_9,  exception_10, exception_11
.global exception_12, exception_13, exception_14, exception_15
.global exception_16, exception_17, exception_18, exception_19
.global exception_20, exception_21, exception_22, exception_23
.global exception_24, exception_25, exception_26, exception_27
.global exception_28, exception_29, exception_30, exception_31
.global exception_128

exception_handler:
    pusha

    xorl    %eax, %eax
    movw    %ds, %ax
    pushl   %eax                    # save ds

    pushl   %esp                    # CPURegs* arg

    movl    $0x10, %eax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs

    call    isr_exception_handler

    popl    %eax                    # discard frame pointer arg
    popl    %ebx                    # restore saved ds
    movw    %bx, %ds
    movw    %bx, %es
    movw    %bx, %fs
    movw    %bx, %gs

    popa
    addl    $0x8, %esp              # skip int_no + err_code
    iret                            # restores eip, cs, eflags — do NOT sti before this

# Macros for exception stubs.
# Exceptions without an error code: push dummy 0 then vector.
# Exceptions with an error code: CPU already pushed it, push only the vector.

.macro EXC_NOERR num
exception_\num:
    cli
    pushl   $0
    pushl   $\num
    jmp     exception_handler
.endm

.macro EXC_ERR num
exception_\num:
    cli
    pushl   $\num
    jmp     exception_handler
.endm

EXC_NOERR 0     # #DE divide error
EXC_NOERR 1     # #DB debug
EXC_NOERR 2     # NMI
EXC_NOERR 3     # #BP breakpoint
EXC_NOERR 4     # #OF overflow
EXC_NOERR 5     # #BR bound range
EXC_NOERR 6     # #UD invalid opcode
EXC_NOERR 7     # #NM device not available
EXC_ERR   8     # #DF double fault        (error code always 0)
EXC_NOERR 9     # coprocessor overrun (FPU)
EXC_ERR   10    # #TS invalid TSS
EXC_ERR   11    # #NP segment not present
EXC_ERR   12    # #SS stack fault
EXC_ERR   13    # #GP general protection
EXC_ERR   14    # #PF page fault
EXC_NOERR 15    # reserved
EXC_NOERR 16    # #MF x87 FPU error
EXC_ERR   17    # #AC alignment check
EXC_NOERR 18    # #MC machine check
EXC_NOERR 19    # #XF SIMD FP exception
EXC_NOERR 20    # #VE virtualization
EXC_ERR   21    # #CP control protection
EXC_NOERR 22
EXC_NOERR 23
EXC_NOERR 24
EXC_NOERR 25
EXC_NOERR 26
EXC_NOERR 27
EXC_NOERR 28    # #HV hypervisor injection
EXC_ERR   29    # #VC VMM communication
EXC_ERR   30    # #SX security exception
EXC_NOERR 31

EXC_NOERR 128   # syscall (int 0x80)
