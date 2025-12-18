module wolfie;

fn void kmain(uint magic, uint info) @export("kmain")
{
    disable_interrupts();
    if(magic != 0x36d76289) panic("Invalid magic number!\n");
    if(info & 7) panic("Multiboot info misaligned!\n");

    vga_clear(WHITE, BLACK);
    vga_puts("WolfieOS Booting...\n");

    init_gdt();
    init_idt();
    init_pic();
    isr_register_exception(0, &divide_by_zero_exception_handler);
    isr_register_exception(6, &invalid_opcode_exception_handler);
    isr_register_exception(14, &page_fault_exception_handler);
    isr_register_exception(20, &virtualization_exception_handler);
    isr_register_irq(Irq.PIT, &pit_handler);  
    enable_interrupts();
    probe_pic();

    //uint size = *(uint*)info;
    //vga_puts("Announce mbi size: ");
    //vga_puthex(size);
    //vga_puts("\n");

    MultibootTag* tag;

    for (tag = (MultibootTag*)(info + 8); tag.type != TagType.END; tag = (MultibootTag*)((char*)tag + ((tag.size + 7) & ~7)))
    {
        //vga_puts("type: ");
        //vga_puthex(tag.type);
        //vga_puts(" size: ");
        //vga_puthex(tag.size);
        //vga_puts("\n");
        
        switch (tag.type)
        {
        case BOOTLOADER_NAME:
            vga_puts("Bootloader: ");
            vga_puts(&((BootloaderNameTag*)tag).name);
            vga_puts("\n");
            break;
        }
    }

    while(true) {
        halt();
    }
}
