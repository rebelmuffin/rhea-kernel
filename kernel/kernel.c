#include <stdint.h>

/* Check if target OS is wrong */
#if defined(__linux__)
#error "You are not using a cross-compiler for ix86, you are going to run into trouble."
#endif

/* Make sure target is ix86 */
#if !defined(__i386__)
#error "This kernel is created to be used with an ix86-elf compiler. You are going to run into trouble."
#endif

uint16_t* terminal_buffer;

static inline uint16_t vga_entry(unsigned char character, uint8_t colour)
{
	return (uint16_t) character | (uint16_t) colour << 8;
}

/* Clears the terminal buffer completely */
void clear(uint16_t* tb)
{
	for (uint16_t i = 0; i < 2000; i++)
	{
		terminal_buffer[i] = 0;
	}

}

void putchar(char character, uint8_t colour, uint16_t x, uint16_t y)
{
	uint16_t loc = y*80 + x;
	terminal_buffer[loc] = vga_entry(character, colour);
}

void kernel_main(void)
{
	terminal_buffer = (uint16_t*) 0xB8000;
	
	// Clear the terminal buffer
	clear(terminal_buffer);

	// Print out some jazzy text
	putchar('K', 2, 33, 11);
	putchar('E', 3, 34, 11);
	putchar('R', 4, 35, 11);
	putchar('N', 5, 36, 11);
	putchar('E', 6, 37, 11);
	putchar('L', 8, 38, 11);

	putchar('T', 9, 40, 11);
	putchar('I', 10, 41, 11);
	putchar('M', 11, 42, 11);
	putchar('E', 12, 43, 11);
	putchar('!', 14, 44, 11);
	putchar('!', 14, 45, 11);
	putchar('!', 14, 46, 11);

	putchar('R', 7, 35, 12);
	putchar('h', 7, 36, 12);
	putchar('e', 7, 37, 12);
	putchar('a', 7, 38, 12);

	putchar('L', 7, 40, 12);
	putchar('i', 7, 41, 12);
	putchar('v', 7, 42, 12);
	putchar('e', 7, 43, 12);
	putchar('s', 7, 44, 12);
}

