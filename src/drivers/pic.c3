module wolfie::drivers;

import wolfie::display;

const ushort PIC_MASTER_COMMAND = 0X20;
const ushort PIC_MASTER_DATA = 0X21;
const ushort PIC_SLAVE_COMMAND = 0XA0;
const ushort PIC_SLAVE_DATA = 0xA1;
const char PIC_ICW1 = 0x11;
const char PIC_ICW4 = 0x01;
const char PIC_EOI = 0x20;
const char PIC_READ_IRR = 0x0A;
const char PIC_READ_ISR = 0x0B;

fn void init_pic() {
    display::vga_puts("Initializing PIC...\n");

    char master = inportb(PIC_MASTER_DATA);
    char slave = inportb(PIC_SLAVE_DATA);

    drivers::outportb(PIC_MASTER_COMMAND, PIC_ICW1);
    drivers::outportb(PIC_SLAVE_COMMAND, PIC_ICW1);

    drivers::outportb(PIC_MASTER_DATA, 0x20);
    drivers::outportb(PIC_SLAVE_DATA, 0x28); 

    drivers::outportb(PIC_MASTER_DATA, 4);
    drivers::outportb(PIC_SLAVE_DATA, 2);

    drivers::outportb(PIC_MASTER_DATA, PIC_ICW4);
    drivers::outportb(PIC_SLAVE_DATA, PIC_ICW4);

    drivers::outportb(PIC_MASTER_DATA, master);
    drivers::outportb(PIC_SLAVE_DATA, slave);

    drivers::outportb(PIC_MASTER_DATA, 0xFF);  
    drivers::outportb(PIC_SLAVE_DATA, 0xFF);  
}


//* Sends an End Of Interrupt (EOI) signal to the appropriate PIC (Programmable Interrupt Controller)
//? [Master PIC] If irq < 8, send EOI to master PIC.
//? [Slave PIC] If irq >= 8, send EOI to slave PIC.
//! IN: 
//!  irq: The IRQ number to acknowledge.
fn void pic_eoi(char irq){
    drivers::outportb((irq < 8) ? PIC_MASTER_COMMAND : PIC_SLAVE_COMMAND, PIC_EOI);
}

//* Mask (disable) a specific IRQ line
//? [Master PIC] If irq < 8, send EOI to master PIC.
//? [Slave PIC] If irq >= 8, send EOI to slave PIC.
//! IN: 
//!  irq: The IRQ number to mask.
fn void pic_mask(char irq){ 
    ushort port = (irq < 8) ? PIC_MASTER_DATA : PIC_SLAVE_DATA;
    char offset = (irq & 7);

    drivers::outportb(port, inportb(port) | (1 << offset));
}

//* Unmask (enable) a specific IRQ line
//? [Master PIC] If irq < 8, send EOI to master PIC.
//? [Slave PIC] If irq >= 8, send EOI to slave PIC.
//! IN: 
//!  irq: The IRQ number to unmask.
fn void pic_unmask(char irq){
    ushort port = (irq < 8) ? PIC_MASTER_DATA : PIC_SLAVE_DATA;
    char offset = (irq & 7);

    drivers::outportb(port, inportb(port) & ~(1 << offset));
}

// Read Interrupt Request Register (IRR)
//! IN: 
//!  pic: The PIC to read from (0 for master, 1 for slave).
fn char pic_read_irr(char pic){
    if(pic == 0) {
        drivers::outportb(PIC_MASTER_COMMAND, PIC_READ_IRR);
        return inportb(PIC_MASTER_DATA);
    } else {
        drivers::outportb(PIC_SLAVE_COMMAND, PIC_READ_IRR);
        return inportb(PIC_SLAVE_DATA);
    }
}

// Read In-Service Register (ISR)
//! IN: 
//!  pic: The PIC to read from (0 for master, 1 for slave).
fn char pic_read_isr(char pic){
    if(pic == 0) {
        drivers::outportb(PIC_MASTER_COMMAND, PIC_READ_ISR);
        return inportb(PIC_MASTER_DATA);
    } else {
        drivers::outportb(PIC_SLAVE_COMMAND, PIC_READ_ISR);
        return inportb(PIC_SLAVE_DATA);
    }
}

fn void probe_pic() {
    char imr_master = inportb(PIC_MASTER_DATA);
    char imr_slave = inportb(PIC_SLAVE_DATA);
    char irr_master = pic_read_irr(0);
    char irr_slave = pic_read_irr(1);
    char isr_master = pic_read_isr(0);
    char isr_slave = pic_read_isr(1);

    display::vga_puts("PIC Master IMR: ");
    display::vga_puthex(imr_master);
    display::vga_puts("\nPIC Slave IMR: ");
    display::vga_puthex(imr_slave);
    display::vga_puts("\nPIC Master IRR: ");
    display::vga_puthex(irr_master);
    display::vga_puts("\nPIC Slave IRR: ");
    display::vga_puthex(irr_slave);
    display::vga_puts("\nPIC Master ISR: ");
    display::vga_puthex(isr_master);
    display::vga_puts("\nPIC Slave ISR: ");
    display::vga_puthex(isr_slave);
    display::vga_puts("\n");
}
