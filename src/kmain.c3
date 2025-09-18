module wolfie;

fn void kmain(uint magic, uint multiboot_info) @export("kmain")
{
    disable_interrupts();
    if(magic != 0x36d76289) panic("Invalid magic number!\n");
    if(multiboot_info & 7) panic("Multiboot info misaligned!\n");

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

    while(true) {
        halt();
    }
}
