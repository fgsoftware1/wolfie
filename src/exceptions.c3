module wolfie;

fn void divide_by_zero_exception_handler(CPURegs* regs)
{
    vga_clear(RED, BLACK);
    vga_puts("Divide by zero exception occurred!");
    vga_clear(WHITE, BLACK);
}

fn void invalid_opcode_exception_handler(CPURegs* regs)
{
    vga_clear(RED, BLACK);
    vga_puts("Invalid opcode exception at EIP: ");
    vga_puthex(regs.eip);
    vga_puts("\n");
    while(true) halt();
}

fn void page_fault_exception_handler(CPURegs* regs)
{
    uint addr = read_cr2();
    vga_puts("Page Fault! CR2=");
    vga_puthex(addr);
    vga_puts("\n");
    panic("Page fault exception occurred!");
}

fn void virtualization_exception_handler(CPURegs* regs)
{
    panic("Virtualization exception occurred!");
}