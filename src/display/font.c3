module wolfie::display;

const char[] FONT_DATA = $embed("font.psf");
const uint PSF2_MAGIC = 0x864ab572;

struct PSF2Header {
    uint magic;
    uint version;
    uint header_size;
    uint flags;
    uint num_glyphs;
    uint bytes_per_glyph;
    uint height;
    uint width;
}

fn char* psf2GetGlyph(PSF2Header* header, uint c) {
	if (c >= header.num_glyphs) {
		c = '?';
	}
	char* glyphs = (char*)((uptr)header + (uptr)header.header_size);
	return (glyphs + c * header.bytes_per_glyph);
}
