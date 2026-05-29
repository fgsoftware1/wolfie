module wolfie;

struct Tty
{
	FrameBuffer* fb;
	PSF2Header* font;
	uint cx, cy;
	uint cols, rows;
	uint fg, bg;
}

fn void Tty.init(&self, FrameBuffer* fb, PSF2Header* font, uint fg, uint bg)
{
	self.fb = fb;
	self.font = font;
	self.fg = fg;
	self.bg = bg;
	self.cols = fb.width / font.width;
	self.rows = fb.height / font.height;
	self.cx = 0;
	self.cy = 0;
}

fn void Tty.scroll(&self)
{
	uint row_bytes = self.fb.pitch * self.font.height;
	char* dst      = (char*)self.fb.pixels;
	char* src      = dst + (usz)row_bytes;
	uint total     = row_bytes * (self.rows - 1);
	for (uint i = 0; i < total; i++) dst[i] = src[i];
	char* last = dst + (usz)(row_bytes * (self.rows - 1));
	for (uint i = 0; i < row_bytes; i++) last[i] = 0;
}

fn void Tty.putChar(&self, char c)
{
	switch (c)
	{
		case '\n':
			self.cx = 0;
			self.cy++;
		case '\r':
			self.cx = 0;
		case '\b':
			if (self.cx > 0) self.cx--;
		default:
			self.fb.putChar(self.font, self.cx, self.cy, c, self.fg, self.bg);
			self.cx++;
			if (self.cx >= self.cols)
			{
				self.cx = 0;
				self.cy++;
			}
	}

	if (self.cy >= self.rows)
	{
		self.scroll();
		self.cy = self.rows - 1;
	}
}

fn void Tty.puts(&self, char* s)
{
	while (s[0] != '\0')
	{
		self.putChar(s[0]);
		s++;
	}
}
