module wolfie;

const uint DMSG_SIZE = 4096;

char[DMSG_SIZE] dmsg_buf;
uint dmsg_head = 0;
uint dmsg_len  = 0;

fn void dmsg_write(char* s) {
    while (s[0] != '\0') {
        dmsg_buf[dmsg_head % DMSG_SIZE] = s[0];
        dmsg_head++;
        if (dmsg_len < DMSG_SIZE) dmsg_len++;
        s++;
    }
}

fn void dmsg_dump(Tty* tty) {
    uint start = dmsg_head >= DMSG_SIZE ? dmsg_head % DMSG_SIZE : 0;
    for (uint i = 0; i < dmsg_len; i++) {
        tty.putChar(dmsg_buf[(start + i) % DMSG_SIZE]);
    }
}

fn void klog(Tty* tty, char* s) {
    dmsg_write(s);
    tty.puts(s);
}

fn void klog_hex(Tty* tty, uint v) {
    char[11] buf;
    buf[0] = '0'; buf[1] = 'x';
    for (int i = 7; i >= 0; i--) {
        char n = (char)(v & 0xF);
        buf[2 + i] = n < 10 ? '0' + n : 'A' + n - 10;
        v >>= 4;
    }
    buf[10] = '\0';
    klog(tty, &buf);
}