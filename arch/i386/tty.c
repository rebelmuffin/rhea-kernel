#include <stddef.h>
#include <stdint.h>

#include <kernel/tty.h>

#include "vga.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static uint16_t* const VGA_MEMORY = (uint16_t*) 0xB8000;

static size_t cursor_column;
static size_t cursor_row;
static uint16_t* terminal_buffer;
static uint8_t terminal_colour;

void terminal_initialise(void)
{
	cursor_row = 0;
	cursor_column = 0;
	terminal_buffer = VGA_MEMORY;
	terminal_setcolour(VGA_COLOUR_WHITE, VGA_COLOUR_BLACK);
	terminal_clear();
}

void terminal_clear()
{
	for (uint16_t i = 0; i < VGA_WIDTH*VGA_WIDTH; i++)
	{
		terminal_buffer[i] = vga_entry(' ', terminal_colour);
	}
}

void terminal_putentryat(unsigned char uchar, uint8_t colour, uint16_t x, uint16_t y)
{
	terminal_buffer[y*VGA_WIDTH+x] = vga_entry(uchar, colour);
}

void terminal_putchar(char character)
{
	unsigned char uchar = character;
	
	// Little hack to skip line if character is newline
	if (character == '\n')
	{
		cursor_row++;
		cursor_column = 0;
		return;
	}

	terminal_putentryat(uchar, terminal_colour, cursor_column, cursor_row);
	if (cursor_column >= VGA_WIDTH)
	{
		cursor_column = 0;
		cursor_row++;
	} else
	{
		cursor_column++;
	}
}

void terminal_write(const char* string, size_t size)
{
	for (uint16_t i = 0; i < size; i++)
	{
		terminal_putchar(string[i]);
	}
}

void terminal_setcolour(uint8_t fg, uint8_t bg)
{
	terminal_colour = vga_entry_colour(fg, bg);
}
