module wolfie;

const uint DMSG_SIZE = 4096;

constdef ConsoleMode : inline char
{
    DEBUG_ONLY = 0,
    FRAMEBUFFER = 1,
    VGA = 2,
}

char[DMSG_SIZE] dmsg_buf;
uint dmsg_head = 0;
uint dmsg_len  = 0;
ConsoleMode console_mode = ConsoleMode.DEBUG_ONLY;

fn void console_init_framebuffer() {
    console_mode = ConsoleMode.FRAMEBUFFER;
}

fn void console_init_vga() {
    vga_clear(WHITE, BLACK);
    console_mode = ConsoleMode.VGA;
}

fn void console_init_debug_only() {
    console_mode = ConsoleMode.DEBUG_ONLY;
}

fn void dmsg_write(char* s) {
    while (s[0] != '\0') {
        dmsg_buf[dmsg_head % DMSG_SIZE] = s[0];
        dmsg_head++;
        if (dmsg_len < DMSG_SIZE) dmsg_len++;
        s++;
    }
}

fn void dmsg_dump() {
    uint start = dmsg_head >= DMSG_SIZE ? dmsg_head % DMSG_SIZE : 0;
    for (uint i = 0; i < dmsg_len; i++) {
        console_putc(dmsg_buf[(start + i) % DMSG_SIZE]);
    }
}

fn void console_putc(char c) {
    e9(c);

    if (console_mode == ConsoleMode.FRAMEBUFFER) {
        g_tty.putChar(c);
        return;
    }

    if (console_mode == ConsoleMode.VGA) {
        vga_putc(c);
        return;
    }
}

fn void console_puts(char* s) {
    while (s[0] != '\0') {
        console_putc(s[0]);
        s++;
    }
}

fn void klog(char* s) {
    dmsg_write(s);
    console_puts(s);
}

fn void klog_hex_raw(uint v, int digits) {
    char[9] buf;
    for (int i = digits - 1; i >= 0; i--) {
        char n = (char)(v & 0xF);
        buf[i] = n < 10 ? '0' + n : 'a' + n - 10;
        v >>= 4;
    }
    buf[digits] = '\0';
    klog(&buf);
}

fn void klog_hex(uint v) {
    klog("0x");
    klog_hex_raw(v, 8);
}

fn void klog_hex8(char v) {
    klog("0x");
    klog_hex_raw((uint)v, 2);
}

fn void klog_hex64(ulong v) {
    klog("0x");
    klog_hex_raw((uint)(v >> 32), 8);
    klog_hex_raw((uint)(v & 0xFFFFFFFF), 8);
}
