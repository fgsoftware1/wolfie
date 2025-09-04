module wolfie;

enum VGAColor : const inline char
{
    BLACK = 0,
    BLUE = 1,
    GREEN = 2,
    CYAN = 3,
    RED = 4,
    MAGENTA = 5,
    BROWN = 6,
    LIGHT_GREY = 7,
    DARK_GREY = 8,
    LIGHT_BLUE = 9,
    LIGHT_GREEN = 10,
    LIGHT_CYAN = 11,
    LIGHT_RED = 12,
    LIGHT_MAGENTA = 13,
    LIGHT_BROWN = 14,
    WHITE = 15,
}

bitstruct VGAEntry : ushort
{
    char ch : 0..7;
    VGAColor fg : 8..11;
    VGAColor bg : 12..15;
}

VGAEntry* video_memory = (VGAEntry*) 0xb8000;

uint vga_width = 80;
uint vga_height = 25;
uint row = 0;
uint col = 0;
ushort cursor_pos_x = 0;
ushort cursor_pos_y = 0;

fn void vga_enable_cursor(char cursor_start, char cursor_end)
{
    if (cursor_start > 15) cursor_start = 15;
    if (cursor_end > 15) cursor_end = 15;
    
	outportb(0x3D4, 0x0A);
	outportb(0x3D5, (inportb(0x3D5) & 0xC0) | cursor_start);

	outportb(0x3D4, 0x0B);
	outportb(0x3D5, (inportb(0x3D5) & 0xE0) | cursor_end);
}

fn void vga_disable_cursor()
{
	outportb(0x3D4, 0x0A);
	outportb(0x3D5, 0x20);
}

fn void vga_set_cursor_pos(ushort x, ushort y){
    ushort pos = (ushort)(y * vga_width + x);
    outportb(0x3D4, 0x0F);
    outportb(0x3D5, (char)(pos & 0xFF));
    outportb(0x3D4, 0x0E);
    outportb(0x3D5, (char)(pos >> 8) & 0xFF);
}

fn void vga_clear(VGAColor fg, VGAColor bg)
{
    cursor_pos_x = 0;
    cursor_pos_y = 0;
    for (ushort y = 0; y < vga_height; y++)
    {
        for (ushort x = 0; x < vga_width; x++)
        {
            video_memory[y * vga_width + x].ch = (char)' ';
            video_memory[y * vga_width + x].fg = fg;
            video_memory[y * vga_width + x].bg = bg;
        }
    }
    vga_enable_cursor(14, 15);
    vga_set_cursor_pos(cursor_pos_x, cursor_pos_y);
}

fn void vga_putc_at(ushort x, ushort y, char ch){
    if (x >= vga_width || y >= vga_height) return;
    video_memory[y * vga_width + x].ch = ch;
}

fn void vga_putc(char ch){
    if (ch == '\n') {
        cursor_pos_x = 0;
        cursor_pos_y++;
        if (cursor_pos_y >= vga_height) cursor_pos_y = 0;
        vga_set_cursor_pos(cursor_pos_x, cursor_pos_y);
        return;
    }

    if (ch == '\r') {
        cursor_pos_x = 0;
        vga_set_cursor_pos(cursor_pos_x, cursor_pos_y);
        return;
    }

    if (ch >= 0x20 && ch <= 0x7E){
        vga_putc_at(cursor_pos_x, cursor_pos_y, ch);
    } else {
        vga_putc_at(cursor_pos_x, cursor_pos_y, ' ');
    }

    cursor_pos_x++;
    if (cursor_pos_x >= vga_width) {
        cursor_pos_x = 0;
        cursor_pos_y++;
        if (cursor_pos_y >= vga_height) {
            cursor_pos_y = 0;
        }
    }
    vga_set_cursor_pos(cursor_pos_x, cursor_pos_y);
}

fn void vga_puts(char* str){
    for (usz i = 0; str[i] != '\0'; i++)
    {
        vga_putc(str[i]);
    }
}

fn void vga_puthex(uint num)
{
    char[9] buf;
    for (int i = 0; i < 8; i++)
    {
        buf[7 - i] = "0123456789ABCDEF"[num & 0xF];
        num >>= 4;
    }
    buf[8] = '\0';
    vga_puts(&buf);
}

fn void panic(char* str){
    vga_clear(RED, BLACK);
    vga_puts("KERNEL PANIC: \n");
    vga_puts(str);
    vga_puts("\n");
    while(true) halt();
}
