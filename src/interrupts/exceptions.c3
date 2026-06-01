module wolfie::interrupts;

import wolfie::display;
import wolfie::cpu;
import wolfie::drivers;

fn void divide_by_zero_exception_handler(CPURegs* regs)
{
    display::vga_clear(RED, BLACK);
    display::vga_puts("Divide by zero exception occurred!");
    display::vga_clear(WHITE, BLACK);
}

fn void invalid_opcode_exception_handler(CPURegs* regs)
{
    display::vga_clear(RED, BLACK);
    display::vga_puts("Invalid opcode exception at EIP: ");
    display::vga_puthex(regs.eip);
    display::vga_puts("\n");
    while (true) drivers::halt();
}

fn void page_fault_exception_handler(CPURegs* regs)
{
    uint addr = cpu::read_cr2();
    display::vga_puts("Page Fault! CR2=");
    display::vga_puthex(addr);
    display::vga_puts(" EIP=");
    display::vga_puthex(regs.eip);
    display::vga_puts(" ERR=");
    display::vga_puthex(regs.err_code);
    display::vga_puts("\n");
    display::panic("Page fault exception occurred!");
}

fn void virtualization_exception_handler(CPURegs* regs)
{
    display::panic("Virtualization exception occurred!");
}
