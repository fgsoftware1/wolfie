module wolfie;

enum TagType : const inline int
{
    END = 0,
    BOOTLOADER_NAME = 2,
    FRAMEBUFFER = 8,
}

struct MultibootTag
{
	TagType type;
	uint size;
}

struct BootloaderNameTag {
	MultibootTag tag;
	char[*] name;
}

enum FramebufferType : const inline char
{
    INDEXED = 0,
    RGB = 1,
    EGA_TEXT = 2,
}

struct FramebufferTag {
	MultibootTag tag;
	ulong addr;
	uint pitch;
  	uint width;
  	uint height;
  	char bpp;
  	FramebufferType type;
  	char reserved;
  	union color_type{
    	struct indexed {
      		uint palette_num_colors;
      		struct rgb {
        		char red;
				char green;
				char blue;
			}
		} 
		struct rgb {
			char red_field_position;
			char red_mask_size;
			char green_field_position;
			char green_mask_size;
			char blue_field_position;
			char blue_mask_size;
		}
	}
}
