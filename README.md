# What is Rhea?
**Rhea** is an operating system that is designed to work with any computer architecture. This repository contains the code for the kernel and architecture specific code.

It is created purely for the educational value and is very experimental. You *can* install it on bare metal at your own risk but I do not recommend. I will be providing support in my own time but I cannot guarantee that I will be able to help with everything.

# Building (ix86)
To build the kernel, you are going to need the following dependencies:
- An i686-elf cross compiler: I recommend using a self-compiled version of GCC. (instructions for linux below)
- [GRUB](https://www.gnu.org/software/grub/) command line tools (optional): This is useful for checking to make sure the created kernel binary is multiboot compatible.
- [QEMU](https://www.qemu.org) (optional): You can *technically* build the kernel without QEMU but you are not going to be able to run and see if it actually works without some VM to run it on.

## Linux Setup
Coming soon, a little convoluted.

## MacOS Setup
You can use [homebrew](https://brew.sh) to install i686-elf-gcc (GCC with i686-elf as target) and QEMU:

    brew install i686-elf-gcc
    brew install qemu

Unlike the compiler and QEMU, installing GRUB command line tools is trickier. You are going to have to clone and compile it yourself from the the [development git repository](https://savannah.gnu.org/projects/grub). 

To compile GRUB, you are going to need [objconv](https://github.com/vertis/objconv) (follow the instructions in repository readme to install) and automake (can be installed using homebrew).

After you are done installing objconv, you can install GRUB with the following commands:

    brew install automake
    git clone git://git.savannah.gnu.org/grub.git
    cd grub
    ./bootstrap
    cd ..
    mkdir build
    cd build
    ../grub/configure --disable-werror TARGET_CC=i686-elf-gcc TARGET_OBJCOPY=i686-elf-objcopy TARGET_STRIP=i686-elf-strip TARGET_NM=i686-elf-nm TARGET_RANLIB=i686-elf-ranlib --target=i686-elf
    make
    sudo make install

## Windows Setup
No setup for windows, I don't want Windows users contributing to this repository anyway

## Building and Testing The Kernel
You can easily build the kernel with GNU make using the command `make` in project root.

You can also run the kernel directly with QEMU using `runkernel.sh`.
