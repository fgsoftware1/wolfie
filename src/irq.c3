module wolfie;

enum Irq : const inline int
{
    PIT = 0,
    KEYBOARD = 1,
    CASCADE = 2,
    COM2 = 3,
    COM1 = 4,
    LPT2 = 5,
    FLOPPY = 6,
    LPT1_SPURIOUS = 7,
    RTC = 8,
    PERIPHERAL_1 = 9,
    PERIPHERAL_2 = 10,
    PERIPHERAL_3 = 11,
    MOUSE = 12,
    FPU = 13,
    ATA_PRIMARY = 14,
    ATA_SECONDARY = 15,
}


