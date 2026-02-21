module wolfie;

struct CPURegs @packed {
    uint ds;                                    	// pushed manually
    uint edi, esi, ebp, esp, ebx, edx, ecx, eax; 	// pusha order (reversed)
    uint int_no, err_code;                      	// pushed by stub
    uint eip, cs, eflags, useresp, ss;          	// pushed by CPU
}

alias Exception = fn void(CPURegs*);
alias Isr = fn void(CPURegs*);

Exception[32] exception_handlers;
Isr[16] isr_handlers;

fn void print_registers(CPURegs* regs)
{
    vga_puts("EAX: "); vga_puthex(regs.eax); vga_puts("\n");
    vga_puts("EBX: "); vga_puthex(regs.ebx); vga_puts("\n");
    vga_puts("ECX: "); vga_puthex(regs.ecx); vga_puts("\n");
    vga_puts("EDX: "); vga_puthex(regs.edx); vga_puts("\n");
    vga_puts("ESI: "); vga_puthex(regs.esi); vga_puts("\n");
    vga_puts("EDI: "); vga_puthex(regs.edi); vga_puts("\n");
    vga_puts("EBP: "); vga_puthex(regs.ebp); vga_puts("\n");
    vga_puts("ESP: "); vga_puthex(regs.esp); vga_puts("\n");
    vga_puts("EIP: "); vga_puthex(regs.eip); vga_puts("\n");
    vga_puts("CS:  "); vga_puthex(regs.cs);  vga_puts("\n");
    vga_puts("DS:  "); vga_puthex(regs.ds);  vga_puts("\n");
    vga_puts("SS:  "); vga_puthex(regs.ss);  vga_puts("\n");
    vga_puts("EFLAGS: "); vga_puthex(regs.eflags);  vga_puts("\n");
}

fn void isr_register_exception(int n, Exception handler)
{
    if (n >= 0 && n < 32) {
        exception_handlers[n] = handler;
        klog(&g_tty, "[IDT] exception 0x");
        klog_hex(&g_tty, (uint)n);
        klog(&g_tty, " -> 0x");
        klog_hex(&g_tty, (uint)handler);
        klog(&g_tty, "\n");
    }
}

fn void isr_register_irq(Irq n, Isr handler)
{
    if (n >= Irq.PIT && n <= Irq.ATA_SECONDARY) {
        isr_handlers[n] = handler;
        pic_unmask((char)n);
        isr_handlers[n] = handler;
        pic_unmask((char)n);
        klog(&g_tty, "[IRQ] 0x");
        klog_hex(&g_tty, (uint)n);
        klog(&g_tty, " -> 0x");
        klog_hex(&g_tty, (uint)handler);
        klog(&g_tty, "\n");
    }
}

fn void exception_dispatch(uint n, CPURegs* regs){
    if (n < 32 && exception_handlers[n]) {
        exception_handlers[n](regs);
    } else {
        panic("Unhandled exception!\n");
        halt();
    }
}

fn void irq_dispatch(uint n, CPURegs* regs){
    if (n < 15 && isr_handlers[n]) {
        isr_handlers[n](regs);
    } else {
        panic("Unhandled IRQ!\n");
        halt();
    }
}

fn void isr_exception_handler(CPURegs* regs) @export("isr_exception_handler") @noreturn
{
    if(regs.int_no < 32) {
        vga_puts("Exception: ");
        vga_puthex(regs.int_no);
        vga_puts("\n");
    } else {
        vga_puts("Unknown exception!\n");
    }
    exception_dispatch(regs.int_no, regs);
}

fn void isr_irq_handler(CPURegs* regs) @export("isr_irq_handler")
{    
    uint irq = regs.int_no - 32;
    if (irq < 15 && isr_handlers[irq]) {
        isr_handlers[irq](regs);
    } else {
        vga_puts("Unhandled IRQ: ");
        vga_puthex(irq);
        vga_puts("\n");
        halt();
    }

	pic_eoi((char)irq);
}
