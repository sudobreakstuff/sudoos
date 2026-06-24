# SudoOS

[![License](https://img.shields.io/badge/license-GPL--2.0-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-ARM64-red)](https://www.kernel.org)
[![Kernel](https://img.shields.io/badge/kernel-7.1.0--rc7-lightgrey)](https://kernel.org)

A custom Linux kernel build system for ARM64, optimized with a tailored kernel configuration and automated build pipeline.

## Features

- Custom ARM64 Linux kernel build for SudoOS
- Automated build script with module installation
- Pre-configured kernel config (`sudoos.config`) with broad platform support
- Automatic initramfs rebuild with QEMU chroot
- uInitrd generation for U-Boot systems
- Supports Raspberry Pi, Rockchip, Allwinner, Qualcomm, and many other ARM platforms

## Tech Stack

- **Linux Kernel** 7.1.0-rc7
- **Cross-compiler**: `aarch64-linux-gnu-gcc`
- **Build system**: Bash + Make

## Setup

Clone the repo with the kernel source:

```bash
git clone https://github.com/sudobreakstuff/sudoos.git
cd sudoos
git submodule init
git submodule update
```

Configure the build script paths in `build-kernel.sh` to match your environment:

```bash
export BOOT_MOUNT="/run/media/sudobreakstuff/BOOT"
export ROOTFS_MOUNT="/run/media/sudobreakstuff/ROOTFS1"
```

## Building

```bash
./build-kernel.sh
```

This will:
1. Copy `sudoos.config` to the kernel source
2. Build the kernel and modules with `make -j$(nproc)`
3. Install modules to the rootfs
4. Copy the kernel Image to the boot partition
5. Rebuild initramfs via QEMU chroot
6. Generate `uInitrd` for U-Boot

## Logo

Custom boot logos (`logo.bmp`) are included for branding.
