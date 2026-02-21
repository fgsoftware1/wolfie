module wolfie;

const uint MULTIBOOT_BOOT_MAGIC = 0x36d76289;

enum TagType : const inline uint
{
    END = 0,
    BOOTLOADER_NAME = 2,
    FRAMEBUFFER = 8,
}

struct MultibootTag @packed {
	TagType type;
	uint size;
}

struct MultibootHeader @packed {
	uint size;
	uint reserved;
}

struct BootloaderNameTag @packed {
	MultibootTag* tag;
	char[*] name;
}

enum FramebufferType : const inline char
{
    INDEXED = 0,
    RGB = 1,
    EGA_TEXT = 2,
}

struct FramebufferTag @packed {
	MultibootTag tag;
	ulong addr;
	uint pitch;
  	uint width;
  	uint height;
  	char bpp;
  	FramebufferType type;
  	ushort reserved;
}

fn MultibootTag* multibootFindTag(MultibootHeader* mbi, TagType want) {
    uptr p   = (uptr)mbi + 8;
    uptr end = (uptr)mbi + mbi.size;

    while (p < end) {
        MultibootTag* tag = (MultibootTag*)p;
        if (tag.type == TagType.END) break;
        if (tag.type == want) return tag;
        p += (tag.size + 7) / 8 * 8;
    }
    return null;
}
