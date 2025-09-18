module wolfie;

fn void divide_by_zero_exception_handler()
{
    vga_clear(RED, BLACK);
    vga_puts("Divide by zero exception ocurred!");
    vga_clear(WHITE, BLACK);
}

fn void invalid_opcode_exception_handler()
{
    vga_clear(RED, BLACK);
    vga_puts("Invalid opcode exception ocurred!");
    vga_clear(WHITE, BLACK);
}

fn void page_fault_exception_handler()
{
    uint addr = read_cr2();
    vga_puts("Page Fault! CR2=");
    vga_puthex(addr);
    vga_puts("\n");
    panic("Page fault exception ocurred!");
}

fn void virtualization_exception_handler()
{
    vga_clear(RED, BLACK);
    vga_puts("Virtualization exception ocurred!");
    vga_clear(WHITE, BLACK);
}