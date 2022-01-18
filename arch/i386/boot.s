/* Declare constants for the multiboot header */
.set ALIGN,	1<<0			# Align loaded modules on page boundaries
.set MEMINFO,	1<<1			# Provide memory map
.set FLAGS,	ALIGN | MEMINFO		# Multiboot "flag" field
.set MAGIC,	0x1BADB002		# Magic number that is used for identifying the header
.set CHECKSUM,	-(MAGIC + FLAGS)	# Checksum of above, to prove that we are multiboot.

/*
Declare the multiboot header that marks this program as a kernel.
These are basically magic values that are documented in the multiboot standard
and the bootloader will be searching for this signature in the first
8KiB of the kernel file, aligned at 32-bit boundary.
*/
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/*
Multiboot standard does not define the value of ESP and it is
up to us to provide a stack. This allocated room for a small stack by
creating a symbol at the bottom of it, then allocating 16384 bytes for it,
and finally creating a symbol at the top.
*/
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/*
The linker sctip specifies _start as the entry point to the kernel and
the bootloader will jump to this position once the kernel has been loaded.
There is no point in returning from this function as the bootloader is gone.
*/
.section .text
.global _start
.type _start, @function
_start:
	/*
	The bootloader has loaded us into 32-bit protected mode on a x86
	machine. Interrupts are disabled. Paging is disabled. The processor
	state is as defined in the multiboot standard. The kernel has full
	control of the CPU. The kernel can only make use of hardware features
	and any code it provides as part of itself. There is no printf
	function, unless the kernel provides its own <stdio.h> header and a
	printf implementation.

	Tl;dr, We have absolute and complete control over the hardware.
	(this also means writing our own drivers :S)
	*/
	
	mov $stack_top, %esp		# Set up ESP register for stack

	/*
	Good place to initialise crucial processor state before the high-level
	kernel is entered. It's best to minimise the early environment where
	crucial features are offline. Note that the processor is not fully
	initialised yet: Features such as floating point instructions and
	instruction set extensions are not initialised yet. The GDT should be
	loaded here. Paging should be enabled here. C++ features such as
	global constructors and exceptions will require runtime support
	to work as well.
	*/

	call kernel_main		# Enter the high-level kernel!!!

	/*
	If there is nothing to do and kernel is finished, just
	disable the interrupts and put the computer into an infinite loop.
	*/
	cli
1:	hlt
	jmp 1b

# Set the size of the _start symbol to the current location minus it's start.
.size _start, . - _start

