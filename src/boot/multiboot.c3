module wolfie::boot;

import wolfie::utils;

const uint MULTIBOOT_BOOT_MAGIC = 0x36d76289;

constdef TagType : inline uint
{
	END = 0,
	BOOTLOADER_NAME = 2,
	MMAP_TAG = 6,
	FRAMEBUFFER = 8,
	ACPI_OLD_RSDP = 14,
	ACPI_NEW_RSDP = 15,
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
    uptr start = (uptr)mbi + MultibootHeader::size;   // skip 8-byte fixed header
    uptr end   = (uptr)mbi + mbi.size;

    while (start < end) {
        MultibootTag* tag = (MultibootTag*)start;

        if (tag.type == (uint)TagType.END) break;
        if (tag.type == (uint)wanted) return tag;

        start += ((uptr)tag.size + 7) & ~((uptr)7);          	// round up to 8-byte boundary
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
		utils::klog("[MMAP] no tag!\n");
		return;
	}

	MMAPTag* mmap = (MMAPTag*)raw_mmap;
	uptr entry = (uptr)mmap + MMAPTag::size;
	uptr end = (uptr)mmap + (uptr)(mmap.tag.size);

	utils::klog("[MMAP] memory map:\n");

	if (mmap.entry_size == 0 || mmap.entry_size < MMAPEntry::size)
	{
		utils::klog("[MMAP] bad entry size: ");
		utils::klog_hex(mmap.entry_size);
		utils::klog("\n");
		return;
	}

	while (entry < end)
	{
		MMAPEntry* e = (MMAPEntry*)entry;
		ulong region_end = e.base_addr + e.length;
		utils::klog("  [");
		utils::klog_hex64(e.base_addr);
        utils::klog(" - ");
        utils::klog_hex64(region_end);
        utils::klog("] ");

		switch (e.type)
		{
			case MMAPType.USABLE:
				utils::klog("USABLE");
			case MMAPType.RESERVED:
				utils::klog("RESERVED");
			case MMAPType.ACPI:
				utils::klog("ACPI");
			case MMAPType.NVS:
				utils::klog("NVS");
			case MMAPType.BAD:
				utils::klog("BAD");
			default:
				utils::klog("UNKNOWN");
		}

		utils::klog("\n");
		entry += (uptr)(mmap.entry_size); 
	}
}
