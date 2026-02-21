module wolfie;

fn void e9(char c) {
    outportb(0xE9, c);
}

fn void e9_puts(char* s) {
    while (*s != 0) { e9(*s); s++; }
}

fn void e9_puthex(uint v) {
    e9_puts("0x");
    for (int i = 28; i >= 0; i -= 4) {
        char n = (char)((v >> (uint)i) & 0xF);
        e9(n < 10 ? '0' + n : 'A' + n - 10);
    }
}

fn void kmain(uint magic, uint info) @export("kmain") {
    disable_interrupts();
    if (magic != MULTIBOOT_BOOT_MAGIC) {
        panic("Invalid magic number!\n");
    }
    if (info & 7) {
        panic("Multiboot info misaligned!\n");
    }

    vga_clear(WHITE, BLACK);
    vga_puts("WolfieOS Booting...\n");

    e9_puts("1\n");init_gdt();
    e9_puts("2\n");init_idt();
    e9_puts("3\n");init_pic();
    e9_puts("4\n");isr_register_exception(0, &divide_by_zero_exception_handler);
    e9_puts("5\n");isr_register_exception(6, &invalid_opcode_exception_handler);
    e9_puts("6\n");isr_register_exception(14, &page_fault_exception_handler);
    e9_puts("7\n");isr_register_exception(20, &virtualization_exception_handler);
    e9_puts("8\n");isr_register_irq(Irq.PIT, &pit_handler);
    e9_puts("9\n");enable_interrupts();
    //probe_pic();
    e9_puts("10\n");

	MultibootTag* tag = multibootFindTag((MultibootHeader*)info, TagType.FRAMEBUFFER);
    if(tag == null) panic("No framebuffer found!");

    FramebufferTag* fbtag = (FramebufferTag*)(tag);
    if(fbtag.type != FramebufferType.RGB) panic("Couln't get RGB framebuffer!");

    FrameBuffer fb = (FrameBuffer){
        (uint*)((usz)fbtag.addr),
        fbtag.pitch,
        fbtag.width,
        fbtag.height,
        fbtag.bpp
    };

    PSF2Header* font = (PSF2Header*)(FONT_DATA.ptr);
    if(font.magic != PSF2_MAGIC) panic("Framebuffer font have wrong magic!");

    fb.debug();
    fb.putStr(font, 2, 1, "We got Framebuffer!");

    while (true) {
        disable_interrupts();
        halt();
    }
}
