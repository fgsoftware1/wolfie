module wolfie;

fn void* memset(void* ptr, int value, usz size) @export("memset") {
    char* p = (char*)ptr;
    for (usz i = 0; i < size; i++) p[i] = (char)value;
    return ptr;
}

fn void* memcpy(void* dst, void* src, usz size) @export("memcpy") {
    char* d = (char*)dst;
    char* s = (char*)src;
    for (usz i = 0; i < size; i++) d[i] = s[i];
    return dst;
}