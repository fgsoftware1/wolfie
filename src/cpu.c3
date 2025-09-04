module wolfie;

extern fn void cpu_get_msr(uint msr, uint* low, uint* high);
extern fn void cpu_set_msr(uint msr, uint low, uint high);
extern fn uint read_cr2();
