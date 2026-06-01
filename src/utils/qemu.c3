module wolfie::utils;

import wolfie::drivers;

fn void e9(char c) {
    drivers::outportb(0xE9, c);
}
