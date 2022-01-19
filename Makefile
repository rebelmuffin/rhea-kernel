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
	    $(addprefix $(BUILDDIR)/,$(KERNEL_ARCH_OBJS)) \
	    $(BUILDDIR)/kernel/kernel.o

OBJS=\
     $(KERNEL_OBJS)

SOURCES=\
	$(KERNEL_SOURCES)

LINK_LIST=\
	  $(LDFLAGS) \
	  $(KERNEL_OBJS) \
	  $(LIBS)

.PHONY: all asm clean
.SUFFIXES: .o .c .s

all: $(BUILDDIR)/kernel.bin

asm: $(OBJS:.o=.s)

$(BUILDDIR)/kernel.bin: $(OBJS) $(ARCHDIR)/linker.ld
	@mkdir -p $(@D)
	$(COMPILER) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot $@

$(BUILDDIR)/%.o: %.s
	@mkdir -p $(@D)
	$(COMPILER) -c $< -o $@ $(CFLAGS)
	
$(BUILDDIR)/%.o: %.c
	@mkdir -p $(@D)
	$(COMPILER) -c $< -o $@ -std=gnu11 $(CFLAGS) $(CPPFLAGS)

$(BUILDDIR)/%.s: %.c
	@mkdir -p $(@D)
	$(COMPILER) -c $< -o $@ -std=gnu11 -S $(CFLAGS) $(CPPFLAGS)

$(BUILDDIR)/%.s: %.s
	@mkdir -p $(@D)
	@cp $< $@

clean:
	rm -rf $(BUILDDIR)

-include $(OBJS:.o=.d)
