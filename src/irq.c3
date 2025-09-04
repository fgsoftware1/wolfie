module wolfie;

enum Irq : const inline int
{
    PIT = 32,
    KEYBOARD = 33,
    CASCADE = 34,
    COM2 = 35,
    COM1 = 36,
    LPT2 = 37,
    FLOPPY = 38,
    LPT1_SPURIOUS = 39,
    RTC = 40,
    PERIPHERAL_1 = 41,
    PERIPHERAL_2 = 42,
    PERIPHERAL_3 = 43,
    MOUSE = 44,
    FPU = 45,
    ATA_PRIMARY = 46,
    ATA_SECONDARY = 47,
}


