
# What is Rhea?
**Rhea** is an operating system that is designed to be extensible to work with any computer architecture. This repository contains the code for the kernel and architecture specific code.

It is created purely for the educational value and is very experimental. You *can* install it on bare metal at your own risk but I do not recommend. I will be providing support in my own time but I cannot guarantee that I will be able to help with everything.

# Building (ix86)
To build the kernel, you are going to need the following dependencies:
- An i686-elf cross compiler: I recommend using a self-compiled version of GCC. (instructions for linux below)
- [GRUB](https://www.gnu.org/software/grub/) command line tools (optional): This is useful for checking to make sure the created kernel binary is multiboot compatible.
- [QEMU](https://www.qemu.org) (optional): You can *technically* build the kernel without QEMU but you are not going to be able to run and see if it actually works without some VM to run it on.

## Linux Setup
To build on linux, you are going to need to compile GCC yourself. Commands to install the build dependencies are given below.

### Debian Based Distros (Ubuntu, Mint etc.)

    sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
    
### Arch Based Distros

    sudo pacman -Syu base-devel gmp libmpc mpfr
    
### Fedora

    sudo dnf install gcc gcc-c++ make bison flex gmp-devel libmpc-devel mpfr-devel texinfo

###
After you install all the dependencies, you need to get the source code of the latest version of [binutils](https://www.gnu.org/software/binutils/) and [GCC](https://gnu.org/software/gcc/). Either on their websites or in [GNU main mirror](https://ftp.gnu.org/gnu/).

After that is done, put extract your downloaded files in separate folders in a directory of your choosing and open a terminal window there.

Since we are going to be compiling with the target i686-elf, the new GCC is not going to be useful for anything other than compiling code for i686 architecture, that also means we cannot use it as out new system compiler so we have to keep it separate from the system compiler, and to do that, we can install it in `$HOME/opt/cross` and it would only be used by the user. You can also install it in `/usr/local`, in which case you would just swap the paths, and it should be fine as long as you have root permissions.

As a preparation, we will define some environment variables:

    mkdir $HOME/opt/cross
    export PREFIX="$HOME/opt/cross"
    export TARGET=i686-elf
    export PATH="$PREFIX/bin:$PATH"
Now that we have our environment variables ready, we are going to create and navigate to a build directory and build binutils. Note, we added our prefix to PATH variable because we need the binutils binaries created after building it while compiling GCC.

    cd directory/above/binutils-src
    mkdir build-binutils && cd build-binutils
    cd ../binutils-src/configure --disable-werror --disable-nls --with-sysroot --target=$TARGET --prefix="$PREFIX"
    make && make install
With this, we have built binutils and ready to compile GCC

    cd directory/above/gcc-src
    mkdir build-gcc && cd build-gcc
    cd ../binutils-src/configure --disable-nls --without-headers --target=$TARGET --prefix="$PREFIX" --enable-languages=c
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
This is going to take a while to build. If your host machine has multiple CPU cores/threads, you should add `-j [number_of_cpu_threads]` at the end of the `make` commands to speed up the compilation process.

After you are done compiling GCC, you can easily install QEMU and GRUB tools as shown below.

### Debian Based Distros 

    sudo apt install qemu-system-x86 grub2-common

### Arch Based Distros

    sudo pacman -Syu grub qemu

### Fedora

    sudo dnf install qemu-system-x86 grub2-common

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
