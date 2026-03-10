module wolfie;

const uint MULTIBOOT_BOOT_MAGIC = 0x36d76289;

enum TagType : const inline uint
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

enum MMAPType : const inline uint
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

enum FramebufferType : const inline char
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

fn MultibootTag* multibootFindTag(MultibootHeader* mbi, TagType want)
{
	uptr p = (uptr)mbi + 8;
	uptr end = (uptr)mbi + mbi.size;

	while (p < end)
	{
		MultibootTag* tag = (MultibootTag*)p;
		if (tag.type == TagType.END) break;
		if (tag.type == want) return tag;
		p += (tag.size + 7) / 8 * 8;
	}
	return null;
}

fn void mmap_init(uint mbi)
{
	MultibootTag* raw_mmap = multibootFindTag(
		(MultibootHeader*)mbi,
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
