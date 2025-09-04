module wolfie;

enum IDTEntryType : const inline char
{
    INTERRUPT_GATE = 0x8E,
    TRAP_GATE = 0x8F,
    TASK_GATE = 0x85
}

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

fn void idt_set_entry(char vector, uint isr, char flags) {
    IDTEntry* descriptor = &idt[vector];

    descriptor.base_low = (ushort)(isr & 0xFFFF);
    descriptor.kernel_cs = 0x08;
    descriptor.reserved = 0;
    descriptor.flags = flags;
    descriptor.base_high = (ushort)((isr >> 16) & 0xFFFF);
}

fn void init_idt(){
    defer{
        load_idt((uint)&idt_ptr);
        enable_interrupts();
    }
    idt_ptr.limit = (ushort)(256 * 8 - 1);
    idt_ptr.base = (uint)&idt[0];

    for (int i = 0; i < 256; i++)
    {
        idt[i].base_low = 0;
        idt[i].kernel_cs = 0;
        idt[i].reserved = 0;
        idt[i].flags = 0;
        idt[i].base_high = 0;
    }

    idt_set_entry(0, (uint)&exception_0, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(1, (uint)&exception_1, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(2, (uint)&exception_2, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(3, (uint)&exception_3, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(4, (uint)&exception_4, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(5, (uint)&exception_5, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(6, (uint)&exception_6, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(7, (uint)&exception_7, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(8, (uint)&exception_8, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(9, (uint)&exception_9, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(10, (uint)&exception_10, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(11, (uint)&exception_11, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(12, (uint)&exception_12, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(13, (uint)&exception_13, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(14, (uint)&exception_14, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(15, (uint)&exception_15, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(16, (uint)&exception_16, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(17, (uint)&exception_17, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(18, (uint)&exception_18, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(19, (uint)&exception_19, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(20, (uint)&exception_20, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(21, (uint)&exception_21, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(22, (uint)&exception_22, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(23, (uint)&exception_23, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(24, (uint)&exception_24, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(25, (uint)&exception_25, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(26, (uint)&exception_26, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(27, (uint)&exception_27, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(28, (uint)&exception_28, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(29, (uint)&exception_29, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(30, (uint)&exception_30, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(31, (uint)&exception_31, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(32, (uint)&irq_0, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(33, (uint)&irq_1, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(34, (uint)&irq_2, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(35, (uint)&irq_3, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(36, (uint)&irq_4, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(37, (uint)&irq_5, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(38, (uint)&irq_6, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(39, (uint)&irq_7, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(40, (uint)&irq_8, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(41, (uint)&irq_9, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(42, (uint)&irq_10, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(43, (uint)&irq_11, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(44, (uint)&irq_12, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(45, (uint)&irq_13, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(46, (uint)&irq_14, IDTEntryType.INTERRUPT_GATE);
    idt_set_entry(47, (uint)&irq_15, IDTEntryType.INTERRUPT_GATE);
}
