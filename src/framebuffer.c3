module wolfie;

char[*] font = $embed("font.psf");

struct Psf2 @packed {
	uint magic;
	uint version;
	uint header_size;
	uint flags;
	uint num_glyph;
	uint bytes_per_glyph;
	uint width;
	uint height;
}

