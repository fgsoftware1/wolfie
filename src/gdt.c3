module wolfie;

struct GDTEntry @packed
{
    ushort limit_low;
    ushort base_low;
    char base_middle;
    char access;
    char granularity;
    char base_high;
}

struct GDTPtr @packed
{
    ushort limit;
    uint base;
}

struct TSSEntry @packed
{
  uint prev_tss;
  uint esp0;     
  uint ss0;      
  uint esp1;
  uint ss1;
  uint esp2;
  uint ss2;
  uint cr3;
  uint eip;
  uint eflags;
  uint eax;
  uint ecx;
  uint edx;
  uint ebx;
  uint esp;
  uint ebp;
  uint esi;
  uint edi;
  uint es;
  uint cs;
  uint ss;
  uint ds;
  uint fs;
  uint gs;
  uint ldt_segment_selector;
  ushort trap;
  ushort iomap_base;
}

GDTEntry[6] gdt @align(16);
GDTPtr gdt_ptr;
TSSEntry tss;

extern fn void load_gdt(uint gdt_ptr);
extern fn void load_tss();

fn void gdt_set_entry(int num, uint base, uint limit, char access, char granularity) {
    gdt[num].limit_low = (ushort)(limit & 0xFFFF);
    gdt[num].base_low = (ushort)(base & 0xFFFF);
    gdt[num].base_middle = (char)((base >> 16) & 0xFF);
    gdt[num].access = access;
    gdt[num].granularity = (char)((limit >> 16) & 0x0F);
    gdt[num].granularity |= (char)(granularity & 0xF0);
    gdt[num].base_high = (char)((base >> 24) & 0xFF);
}

fn void init_gdt(){
    defer{
        load_gdt((uint)&gdt_ptr);
        load_tss();
    }
    gdt_ptr.limit = ((GDTEntry.sizeof) * 6) - 1;
    gdt_ptr.base = (uint)&gdt;

    gdt_set_entry(0, 0, 0, 0, 0);                // Null segment
    gdt_set_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF); // Code segment
    gdt_set_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF); // Data segment
    gdt_set_entry(3, 0, 0xFFFFFFFF, 0xFA, 0xCF); // User mode code segment
    gdt_set_entry(4, 0, 0xFFFFFFFF, 0xF2, 0xCF); // User mode data segment
    tss.ss0 = 0x10;
    tss.esp0 = (uint)stack_top;
    tss.iomap_base = TSSEntry.sizeof;
    gdt_set_entry(5, (uint)&tss, TSSEntry.sizeof, 0x89, 0x00); // TSS segment
}
