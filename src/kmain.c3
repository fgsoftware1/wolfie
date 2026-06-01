module wolfie;

import wolfie::interrupts;
import wolfie::boot;
import wolfie::display;
import wolfie::utils;
import wolfie::cpu;
import wolfie::drivers;

display::Tty g_tty;
display::FrameBuffer g_fb;
display::PSF2Header* g_font;

fn void kmain(uint magic, uint info) @export("kmain")
{
	drivers::disable_interrupts();
	if (magic != boot::MULTIBOOT_BOOT_MAGIC) display::panic("Invalid magic number!\n");
	if (info & 7) display::panic("Multiboot info misaligned!\n");

	boot::MultibootTag* tag = boot::mb2_find_tag((boot::MultibootHeader*)info, boot::TagType.FRAMEBUFFER);
	if (tag != null)
	{
		boot::FramebufferTag* fbtag = (boot::FramebufferTag*)tag;
		if (fbtag.type == boot::FramebufferType.RGB)
		{
			g_fb = (display::FrameBuffer) { (uint*)((usz)fbtag.addr), fbtag.pitch, fbtag.width, fbtag.height, fbtag.bpp };

			g_font = (display::PSF2Header*)display::FONT_DATA.ptr;
			if (g_font.magic != display::PSF2_MAGIC) display::panic("Bad font magic!\n");

			g_tty.init(&g_fb, g_font, 0xFFFFFF, 0x000000);
			utils::console_init_framebuffer();
			g_fb.fill(0x001020);
			g_fb.debug();
		}
		else
		{
			utils::console_init_vga();
			utils::klog("[wolfie] framebuffer is not RGB, using VGA text fallback\n");
		}
	}
	else
	{
		utils::console_init_vga();
		utils::klog("[wolfie] no framebuffer tag, using VGA text fallback\n");
	}

	utils::klog("[wolfie] booting...\n");
	boot::mmap_init(info);

	cpu::init_gdt();
	cpu::init_idt();
	drivers::init_pic();

	interrupts::isr_register_exception(0, &interrupts::divide_by_zero_exception_handler);
	interrupts::isr_register_exception(6, &interrupts::invalid_opcode_exception_handler);
	interrupts::isr_register_exception(14, &interrupts::page_fault_exception_handler);
	interrupts::isr_register_exception(20, &interrupts::virtualization_exception_handler);
	interrupts::isr_register_irq(Irq.PIT, &drivers::pit_handler);

	drivers::enable_interrupts();
	utils::klog("[wolfie] ready\n");

	while (true) drivers::halt();
}
