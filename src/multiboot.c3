module wolfie;

enum TagType : const inline int
{
    END = 0,
    BOOTLOADER_NAME = 2,
}

struct MultibootTag
{
    TagType type;
    uint size;
}

struct BootloaderNameTag
{
    MultibootTag tag;
    char[*] name;
}
