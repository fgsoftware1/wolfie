module wolfie;

struct FrameBuffer { 
	uint* pixels; 
	uint pitch; 
	uint width; 
	uint height; 
	char bpp;
}

fn void FrameBuffer.putPixel(&self, uint x, uint y, uint rgb) {
	if(x >= self.width || y >= self.height) return;
	char* row = (char*)(self.pixels) + (usz)y * self.pitch;

	row[x * (self.bpp / 8) + 0] = (char)((rgb >>  0) & 0xFF); // B
    row[x * (self.bpp / 8) + 1] = (char)((rgb >>  8) & 0xFF); // G
    row[x * (self.bpp / 8) + 2] = (char)((rgb >> 16) & 0xFF); // R
}

fn void FrameBuffer.fill(&self, uint rgb) {
	for(uint y = 0; y < self.height; y++){
		for(uint x = 0; x < self.width; x++){
			self.putPixel(x, y, rgb);
		}
	}
}

fn void FrameBuffer.putChar(&self, PSF2Header* hdr, uint cx, uint cy, char c, uint fg, uint bg){
	char* glyph = psf2GetGlyph(hdr, (char)c);
	uint pw = hdr.width;
	uint ph = hdr.height;
	uint bpr = (pw + 7) / 8; // bytes per glyph row

	for(uint row = 0; row < ph; row++){
		for(uint col = 0; col < pw; col++){
			uint byte = (uint)((char)(glyph[row * bpr + col / 8]));
			bool set  = ((byte >> (7 - col % 8)) & 1u) != 0;
			self.putPixel(cx * pw + col, cy * ph + row, set ? fg : bg);
		}
	}
}

fn void FrameBuffer.putStr(&self, PSF2Header* hdr, uint cx, uint cy, char* s, uint fg = 0xFFFFFF, uint bg = 0x00008B){
	while(s[0] != '\0'){
		self.putChar(hdr, cx, cy, s[0], fg, bg);
		cx++;
		s++;
	}
}

fn void FrameBuffer.debug(&self) {
	for (uint x = 0; x < self.width; x++) {
        self.putPixel(x, 0, 0xFF0000);  // row 0: red
        self.putPixel(x, 1, 0x00FF00);  // row 1: green
        self.putPixel(x, 2, 0x0000FF);  // row 2: blue
        self.putPixel(x, 3, 0xFFFFFF);  // row 3: white
    }
}
