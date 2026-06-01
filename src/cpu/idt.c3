module wolfie::cpu;

import wolfie::utils;
import wolfie::interrupts;

bitstruct IDTEntryType : char
{
	uint type : 0..3;
	uint zero : 4..4; // reserved, must always be 0
	uint dpl : 5..6;
	bool is_present : 7;
}

const IDTEntryType INTERRUPT_NULL = (IDTEntryType) { .type = 0, .dpl = 0, .is_present = false };
const IDTEntryType INTERRUPT_GATE = (IDTEntryType) { .type = 0xE, .dpl = 0, .is_present = true };
const IDTEntryType INTERRUPT_TRAP = (IDTEntryType) { .type = 0xF, .dpl = 0, .is_present = true };
const IDTEntryType SYSCALL_GATE   = (IDTEntryType) { .type = 0xF, .dpl = 3, .is_present = true };

struct IDTEntry @packed
{
	ushort base_low;
	ushort kernel_cs;
	char reserved;
	char flags;
	ushort base_high;
}

struct IDTPtr @packed
{
	ushort limit;
	uint base;
}

IDTEntry[256] idt @align(16);
IDTPtr idt_ptr;

extern fn void load_idt(uint idt_ptr);

fn void idt_set_entry(uint vector, uint isr, char flags)
{
	IDTEntry* descriptor = &idt[vector];
	descriptor.base_low = (ushort)(isr & 0xFFFF);
	descriptor.kernel_cs = 0x08;
	descriptor.reserved = 0;
	descriptor.flags = flags;
	descriptor.base_high = (ushort)((isr >> 16) & 0xFFFF);
}

fn void init_idt()
{
	defer load_idt((uint)&idt_ptr);

	idt_ptr.limit = (ushort)(256 * IDTEntry::size - 1);
	idt_ptr.base = (uint)&idt[0];

	// zero-out IDT table
	for (uint i = 0; i < 256; i++)
	{
		idt_set_entry(i, (uint)null, (char)INTERRUPT_NULL);
	}

	// populate exceptions
	idt_set_entry(0, (uint)&interrupts::exception_0, (char)INTERRUPT_TRAP);
	idt_set_entry(1, (uint)&interrupts::exception_1, (char)INTERRUPT_TRAP);
	idt_set_entry(2, (uint)&interrupts::exception_2, (char)INTERRUPT_TRAP);
	idt_set_entry(3, (uint)&interrupts::exception_3, (char)INTERRUPT_TRAP);
	idt_set_entry(4, (uint)&interrupts::exception_4, (char)INTERRUPT_TRAP);
	idt_set_entry(5, (uint)&interrupts::exception_5, (char)INTERRUPT_TRAP);
	idt_set_entry(6, (uint)&interrupts::exception_6, (char)INTERRUPT_TRAP);
	idt_set_entry(7, (uint)&interrupts::exception_7, (char)INTERRUPT_TRAP);
	idt_set_entry(8, (uint)&interrupts::exception_8, (char)INTERRUPT_TRAP);
	idt_set_entry(9, (uint)&interrupts::exception_9, (char)INTERRUPT_TRAP);
	idt_set_entry(10, (uint)&interrupts::exception_10, (char)INTERRUPT_TRAP);
	idt_set_entry(11, (uint)&interrupts::exception_11, (char)INTERRUPT_TRAP);
	idt_set_entry(12, (uint)&interrupts::exception_12, (char)INTERRUPT_TRAP);
	idt_set_entry(13, (uint)&interrupts::exception_13, (char)INTERRUPT_TRAP);
	idt_set_entry(14, (uint)&interrupts::exception_14, (char)INTERRUPT_TRAP);
	idt_set_entry(15, (uint)&interrupts::exception_15, (char)INTERRUPT_TRAP);
	idt_set_entry(16, (uint)&interrupts::exception_16, (char)INTERRUPT_TRAP);
	idt_set_entry(17, (uint)&interrupts::exception_17, (char)INTERRUPT_TRAP);
	idt_set_entry(18, (uint)&interrupts::exception_18, (char)INTERRUPT_TRAP);
	idt_set_entry(19, (uint)&interrupts::exception_19, (char)INTERRUPT_TRAP);
	idt_set_entry(20, (uint)&interrupts::exception_20, (char)INTERRUPT_TRAP);
	idt_set_entry(21, (uint)&interrupts::exception_21, (char)INTERRUPT_TRAP);
	idt_set_entry(22, (uint)&interrupts::exception_22, (char)INTERRUPT_TRAP);
	idt_set_entry(23, (uint)&interrupts::exception_23, (char)INTERRUPT_TRAP);
	idt_set_entry(24, (uint)&interrupts::exception_24, (char)INTERRUPT_TRAP);
	idt_set_entry(25, (uint)&interrupts::exception_25, (char)INTERRUPT_TRAP);
	idt_set_entry(26, (uint)&interrupts::exception_26, (char)INTERRUPT_TRAP);
	idt_set_entry(27, (uint)&interrupts::exception_27, (char)INTERRUPT_TRAP);
	idt_set_entry(28, (uint)&interrupts::exception_28, (char)INTERRUPT_TRAP);
	idt_set_entry(29, (uint)&interrupts::exception_29, (char)INTERRUPT_TRAP);
	idt_set_entry(30, (uint)&interrupts::exception_30, (char)INTERRUPT_TRAP);
	idt_set_entry(31, (uint)&interrupts::exception_31, (char)INTERRUPT_TRAP);

	// populate IRQs
	idt_set_entry(32, (uint)&interrupts::irq_0, (char)INTERRUPT_GATE);
	idt_set_entry(33, (uint)&interrupts::irq_1, (char)INTERRUPT_GATE);
	idt_set_entry(34, (uint)&interrupts::irq_2, (char)INTERRUPT_GATE);
	idt_set_entry(35, (uint)&interrupts::irq_3, (char)INTERRUPT_GATE);
	idt_set_entry(36, (uint)&interrupts::irq_4, (char)INTERRUPT_GATE);
	idt_set_entry(37, (uint)&interrupts::irq_5, (char)INTERRUPT_GATE);
	idt_set_entry(38, (uint)&interrupts::irq_6, (char)INTERRUPT_GATE);
	idt_set_entry(39, (uint)&interrupts::irq_7, (char)INTERRUPT_GATE);
	idt_set_entry(40, (uint)&interrupts::irq_8, (char)INTERRUPT_GATE);
	idt_set_entry(41, (uint)&interrupts::irq_9, (char)INTERRUPT_GATE);
	idt_set_entry(42, (uint)&interrupts::irq_10, (char)INTERRUPT_GATE);
	idt_set_entry(43, (uint)&interrupts::irq_11, (char)INTERRUPT_GATE);
	idt_set_entry(44, (uint)&interrupts::irq_12, (char)INTERRUPT_GATE);
	idt_set_entry(45, (uint)&interrupts::irq_13, (char)INTERRUPT_GATE);
	idt_set_entry(46, (uint)&interrupts::irq_14, (char)INTERRUPT_GATE);
	idt_set_entry(47, (uint)&interrupts::irq_15, (char)INTERRUPT_GATE);
}

fn void idt_dump()
{
	utils::klog("[IDT] dump start\n");
	for (uint i = 0; i < 256; i++)
	{
		IDTEntry* e = &idt[i];
		uint addr   = ((uint)e.base_high << 16) | (uint)e.base_low;
		if (addr == 0) continue;
		utils::klog("entry=");
		utils::klog_hex(i);
		utils::klog(" ");
		utils::klog_hex(addr);
		utils::klog("\n");
	}
	utils::klog("[IDT] dump done\n");
}
