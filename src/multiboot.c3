module wolfie;

const uint MULTIBOOT_BOOT_MAGIC = 0x36d76289;

constdef TagType : inline uint
{
	END = 0,
	BOOTLOADER_NAME = 2,
	MMAP_TAG = 6,
	FRAMEBUFFER = 8,
}

struct MultibootTag @packed
{
	TagType type;
	uint size;
}

struct MultibootHeader @packed
{
	uint size;
	uint reserved;
}

struct BootloaderNameTag @packed
{
	MultibootTag* tag;
	char[*] name;
}

constdef MMAPType : inline uint
{
	USABLE = 1,
	RESERVED = 2,
	ACPI = 3,
	NVS = 4,
	BAD = 5,
}

struct MMAPEntry @packed
{
	ulong base_addr;
	ulong length;
	uint type;
	uint reserved;
}

struct MMAPTag @packed
{
	MultibootTag tag;
	uint entry_size;
	uint entry_version;
	MMAPEntry[*] entries;
}

constdef FramebufferType : inline char
{
	INDEXED = 0,
	RGB = 1,
	EGA_TEXT = 2,
}

struct FramebufferTag @packed
{
	MultibootTag tag;
	ulong addr;
	uint pitch;
	uint width;
	uint height;
	char bpp;
	FramebufferType type;
	ushort reserved;
}

fn MultibootTag* mb2_find_tag(MultibootHeader* mbi, TagType wanted)
{
    uptr start = (uptr)mbi + MultibootHeader.sizeof;   // skip 8-byte fixed header
    uptr end   = (uptr)mbi + mbi.size;

    while (start < end) {
        MultibootTag* tag = (MultibootTag*)start;

        if (tag.type == (uint)TagType.END) break;
        if (tag.type == (uint)wanted) return tag;

        start += ((uptr)tag.size + 7) & -8;          	// round up to 8-byte boundary
    }

    return null;
}

fn void mmap_init(uint mbi)
{
	MultibootTag* raw_mmap = mb2_find_tag(
		(MultibootHeader*)(uptr)mbi,
		TagType.MMAP_TAG
	);

	if (raw_mmap == null)
	{
		klog("[MMAP] no tag!\n");
		return;
	}

	MMAPTag* mmap = (MMAPTag*)raw_mmap;
	uptr entry = (uptr)mmap + MMAPTag.sizeof;
	uptr end = (uptr)mmap + (uptr)(mmap.tag.size);

	klog("[MMAP] memory map:\n");

	while (entry < end)
	{
		MMAPEntry* e = (MMAPEntry*)entry;
		klog("  [");
		klog_hex((uint)e.base_addr);
        klog(" - ");
        klog_hex((uint)(e.base_addr + e.length));
        klog("] ");

		switch (e.type)
		{
			case MMAPType.USABLE:
				klog("USABLE");
			case MMAPType.RESERVED:
				klog("RESERVED");
			case MMAPType.ACPI:
				klog("ACPI");
			case MMAPType.NVS:
				klog("NVS");
			case MMAPType.BAD:
				klog("BAD");
			default:
				klog("UNKNOWN");
		}

		klog("\n");
		entry += (uptr)(mmap.entry_size); 
	}
}
