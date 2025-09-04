module wolfie;

const ushort PIT_CMD = 0x43;
const ushort PIT_CHANNEL0 = 0x40;
const ushort PIT_FREQUENCY = 1000;  // 1 kHz

int timer_ticks = 0;

fn void init_pit() {
    // Calculate the divisor for the PIT frequency
    uint divisor = 1193180 / PIT_FREQUENCY;
    
    // Send the command byte (channel 0, lobyte/highbyte, mode 2, binary)
    outportb(PIT_CMD, 0x36);
    
    // Set the frequency divisor (low byte, then high byte)
    outportb(PIT_CHANNEL0, (char)(divisor & 0xFF));
    outportb(PIT_CHANNEL0, (char)((divisor >> 8) & 0xFF));
}

fn void pit_handler(CPURegs* regs) {
    timer_ticks++;
}
