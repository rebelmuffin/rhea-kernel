/* Bootloader will look at this image and start execution at the symbol
   designated as the entry point. */
ENTRY(_start)

/* Section locations in the final kernel image */
SECTIONS
{
	/* Put the sections at 1 MiB */
	. = 1M;

	/* First multiboot header and then the code */
	.text BLOCK(4K) : ALIGN (4K)
	{
		*(.multiboot)
		*(.text)
	}

	/* Read-only data */
	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}

	/* Initialised read-write data */
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	/* Finally, the uninitialised read-write data and stack */
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}
}
