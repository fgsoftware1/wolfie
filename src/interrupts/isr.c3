module wolfie::interrupts;

import wolfie::display;
import wolfie::utils;
import wolfie::drivers;

struct CPURegs @packed {
    uint ds;                                        // pushed manually
    uint edi, esi, ebp, esp, ebx, edx, ecx, eax;   // pusha order (reversed)
    uint int_no, err_code;                          // pushed by stub
    uint eip, cs, eflags, useresp, ss;             // pushed by CPU
}

alias Exception = fn void(CPURegs*);
alias Isr       = fn void(CPURegs*);

Exception[32] exception_handlers;
Isr[16]       isr_handlers;

fn void print_registers(CPURegs* regs)
{
    display::vga_puts("EAX: ");    display::vga_puthex(regs.eax);    display::vga_puts("\n");
    display::vga_puts("EBX: ");    display::vga_puthex(regs.ebx);    display::vga_puts("\n");
    display::vga_puts("ECX: ");    display::vga_puthex(regs.ecx);    display::vga_puts("\n");
    display::vga_puts("EDX: ");    display::vga_puthex(regs.edx);    display::vga_puts("\n");
    display::vga_puts("ESI: ");    display::vga_puthex(regs.esi);    display::vga_puts("\n");
    display::vga_puts("EDI: ");    display::vga_puthex(regs.edi);    display::vga_puts("\n");
    display::vga_puts("EBP: ");    display::vga_puthex(regs.ebp);    display::vga_puts("\n");
    display::vga_puts("ESP: ");    display::vga_puthex(regs.esp);    display::vga_puts("\n");
    display::vga_puts("EIP: ");    display::vga_puthex(regs.eip);    display::vga_puts("\n");
    display::vga_puts("CS:  ");    display::vga_puthex(regs.cs);     display::vga_puts("\n");
    display::vga_puts("DS:  ");    display::vga_puthex(regs.ds);     display::vga_puts("\n");
    display::vga_puts("SS:  ");    display::vga_puthex(regs.ss);     display::vga_puts("\n");
    display::vga_puts("EFLAGS: "); display::vga_puthex(regs.eflags); display::vga_puts("\n");
}

fn void isr_register_exception(int n, Exception handler)
{
    if (n >= 0 && n < 32) {
        exception_handlers[n] = handler;
        utils::klog("[IDT] exception ");
        utils::klog_hex((uint)n);
        utils::klog(" -> ");
        utils::klog_hex((uint)handler);
        utils::klog("\n");
    }
}

fn void isr_register_irq(Irq n, Isr handler)
{
    if (n >= Irq.PIT && n <= Irq.ATA_SECONDARY) {
        isr_handlers[n] = handler;  
        utils::klog("[IRQ] ");
        utils::klog_hex((uint)n);
        utils::klog(" -> ");
        utils::klog_hex((uint)handler);
        utils::klog("\n");
    }
}

fn void exception_dispatch(uint n, CPURegs* regs)
{
    if (n < 32 && exception_handlers[n]) {
        exception_handlers[n](regs);
    } else {
        utils::klog("[EXC] unhandled vector ");
        utils::klog_hex(n);
        utils::klog(" eip=");
        utils::klog_hex(regs.eip);
        utils::klog(" err=");
        utils::klog_hex(regs.err_code);
        utils::klog("\n");
        display::panic("Unhandled exception!\n");
        drivers::halt();
    }
}

fn void irq_dispatch(uint n, CPURegs* regs)
{
    if (n < 16 && isr_handlers[n]) {  // fix: was n < 15, dropping IRQ 15
        isr_handlers[n](regs);
    } else {
        utils::klog("[IRQ] unhandled ");
        utils::klog_hex(n);
        utils::klog("\n");
        display::panic("Unhandled IRQ!\n");
        drivers::halt();
    }
}

// fix: removed @noreturn — exception_dispatch can return for handled exceptions
fn void isr_exception_handler(CPURegs* regs) @export("isr_exception_handler")
{
    utils::klog("[EXC] vector ");
    utils::klog_hex(regs.int_no);
    utils::klog("\n");
    exception_dispatch(regs.int_no, regs);
}

fn void isr_irq_handler(CPURegs* regs) @export("isr_irq_handler")
{
    uint irq = regs.int_no - 32;

    if (irq < 16 && isr_handlers[irq]) {  // fix: was irq < 15
        isr_handlers[irq](regs);
    } else {
        utils::klog("[IRQ] unhandled ");
        utils::klog_hex(irq);
        utils::klog("\n");
        drivers::halt();
    }

    drivers::pic_eoi((char)irq);
}
