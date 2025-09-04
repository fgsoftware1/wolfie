module wolfie;

fn void divide_by_zero_exception_handler()
{
    panic("Divide by zero exception!");
}

fn void invalid_opcode_exception_handler()
{
    panic("Invalid opcode exception!");
}

fn void page_fault_exception_handler()
{
    uint addr = read_cr2();
    vga_puts("Page Fault! CR2=");
    vga_puthex(addr);
    vga_puts("\n");
    panic("Page fault exception!");
}
