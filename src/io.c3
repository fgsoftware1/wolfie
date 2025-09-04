module wolfie;

extern void* stack_top;

extern fn void halt();
extern fn void enable_interrupts();
extern fn void disable_interrupts();

extern fn char inportb(ushort);
extern fn void outportb(ushort, char);
