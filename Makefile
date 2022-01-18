HOST?=i686-elf
HOSTARCH?=i386
COMPILER?=$(HOST)-gcc

CFLAGS?=-ffreestanding
CPPFLAGS?=-D__is_kernel -Iinclude
LDFLAGS?=
LIBS?=-nostdlib

BUILDDIR?=build
INCLUDEDIR?=include

ARCHDIR=arch/$(HOSTARCH)

include $(ARCHDIR)/make.config

CFLAGS:=$(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CPPFLAGS:=$(CPPFLAGS) $(KERNEL_ARCH_CPPFLAGS)
LDFLAGS:=$(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS:=$(LIBS) $(KERNEL_ARCH_LIBS)

KERNEL_OBJS=\
	    $(BUILDDIR)/$(KERNEL_ARCH_OBJS) \
	    $(BUILDDIR)/kernel/kernel.o

OBJS=\
     $(KERNEL_OBJS)

LINK_LIST=\
	  $(LDFLAGS) \
	  $(KERNEL_OBJS) \
	  $(LIBS)

.PHONY: all clean
.SUFFIXES: .o .c .s

all: kernel.bin

kernel.bin: $(OBJS) $(ARCHDIR)/linker.ld
	@mkdir -p $(BUILDDIR)/$(@D)
	$(COMPILER) -T $(ARCHDIR)/linker.ld -o $(BUILDDIR)/$@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot $(BUILDDIR)/$@

$(BUILDDIR)/%.o: %.s
	@mkdir -p $(@D)
	$(COMPILER) -c $< -o $@ $(CFLAGS)

$(BUILDDIR)/%.o: %.c
	@mkdir -p $(@D)
	$(COMPILER) -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

clean:
	rm -rf $(BUILDDIR)

-include $(OBJS:.o=.d)
