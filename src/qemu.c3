module wolfie;

fn void e9(char c) {
    outportb(0xE9, c);
}

fn void e9_puts(char* s) {
    while (*s != 0) { e9(*s); s++; }
}

fn void e9_puthex(uint v) {
    e9_puts("0x");
    for (int i = 28; i >= 0; i -= 4) {
        char n = (char)((v >> (uint)i) & 0xF);
        e9(n < 10 ? '0' + n : 'A' + n - 10);
    }
}