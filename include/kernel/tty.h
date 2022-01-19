#ifndef KERNEL_TTY_H
#define KERNEL_TTY_H

#include <stddef.h>
#include <stdint.h>


void terminal_initialise(void);
void terminal_clear();
void terminal_putchar(char character);
void terminal_write(const char* data, size_t size);
void terminal_setcolour(uint8_t fg, uint8_t bg);

#endif
