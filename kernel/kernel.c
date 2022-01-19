#include <stdint.h>

#include <kernel/tty.h>

/* Check if target OS is wrong */
#if defined(__linux__)
#error "You are not using a cross-compiler for ix86, you are going to run into trouble."
#endif

/* Make sure target is ix86 */
#if !defined(__i386__)
#error "This kernel is created to be used with an ix86-elf compiler. You are going to run into trouble."
#endif


void kernel_main(void)
{
	terminal_initialise();
	terminal_setcolour(7, 9);
	terminal_clear();
	terminal_setcolour(10, 9);
	terminal_write("Kernel is Here!\n", 17);
	terminal_setcolour(15, 9);
	terminal_write(" Rhea Lives", 11);
}

