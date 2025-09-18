module wolfie;

bitstruct IDTEntryType : char
{
    uint type        : 0..3;
    uint dpl         : 4..5;
    bool is_present  : 7;
}

const IDTEntryType INTERRUPT_NULL  = { .type = 0, .dpl = 0, .is_present = false };
const IDTEntryType INTERRUPT_GATE = { .type = 0xE, .dpl = 0, .is_present = true };
const IDTEntryType INTERRUPT_TRAP  = { .type = 0xF, .dpl = 0, .is_present = true };

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
    defer load_idt((uint)&idt_ptr);
    
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

    idt_set_entry(0, (uint)&exception_0, (char)INTERRUPT_TRAP);
    idt_set_entry(6, (uint)&exception_6, (char)INTERRUPT_TRAP);
    idt_set_entry(14, (uint)&exception_14, (char)INTERRUPT_TRAP);
    idt_set_entry(20,(uint)&exception_20, (char)INTERRUPT_TRAP);
    idt_set_entry(32, (uint)&irq_0, (char)INTERRUPT_GATE);
}
