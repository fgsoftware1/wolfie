module wolfie;

Tty g_tty;
FrameBuffer g_fb;
PSF2Header* g_font;

fn void kmain(uint magic, uint info) @export("kmain") {
    disable_interrupts();
    if (magic != MULTIBOOT_BOOT_MAGIC) panic("Invalid magic number!\n");
    if (info & 7) panic("Multiboot info misaligned!\n");

    MultibootTag* tag = multibootFindTag((MultibootHeader*)info, TagType.FRAMEBUFFER);
    if (tag == null) panic("No framebuffer tag!\n");
    FramebufferTag* fbtag = (FramebufferTag*)tag;
    if (fbtag.type != FramebufferType.RGB) panic("No RGB framebuffer!\n");

    g_fb = (FrameBuffer){
        (uint*)((usz)fbtag.addr),
        fbtag.pitch,
        fbtag.width,
        fbtag.height,
        fbtag.bpp
    };

    g_font = (PSF2Header*)FONT_DATA.ptr;
    if (g_font.magic != PSF2_MAGIC) panic("Bad font magic!\n");

    g_tty.init(&g_fb, g_font, 0xFFFFFF, 0x000000);
    klog("[wolfie] booting...\n");
    mmap_init(info);

    init_gdt();  klog("[GDT] ok\n");
    init_idt();  klog("[IDT] ok\n");
    init_pic();  klog("[PIC] ok\n");
    init_pit();  klog("[PIT] ok\n");

    isr_register_exception(0,  &divide_by_zero_exception_handler);
    isr_register_exception(6,  &invalid_opcode_exception_handler);
    isr_register_exception(14, &page_fault_exception_handler);
    isr_register_exception(20, &virtualization_exception_handler);
    isr_register_irq(Irq.PIT, &pit_handler);

    enable_interrupts();
    klog("[wolfie] ready\n");

    while (true) {
        disable_interrupts();
        halt();
    }
}
