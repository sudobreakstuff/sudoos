#!/bin/bash
set -e

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

KERNEL_DIR="$(dirname "$0")/linux"
BOOT_MOUNT="/run/media/sudobreakstuff/BOOT"
ROOTFS_MOUNT="/run/media/sudobreakstuff/ROOTFS1"
KERNEL_VERSION="7.1.0-rc7-SudoOS"

echo "=== Building SudoOS Kernel ==="

cd "$KERNEL_DIR"
cp ../sudoos.config .config

make -j$(nproc) Image modules

echo "=== Kernel built ==="
echo "=== Installing modules ==="
sudo make INSTALL_MOD_PATH="$ROOTFS_MOUNT" modules_install

echo "=== Installing Image ==="
sudo cp arch/arm64/boot/Image "$BOOT_MOUNT/Image"

echo "=== Rebuilding initramfs ==="
sudo mount -t proc /proc "$ROOTFS_MOUNT/proc/"
sudo mount -t sysfs /sys "$ROOTFS_MOUNT/sys/"
sudo mount --bind /dev "$ROOTFS_MOUNT/dev/"
sudo mount --bind /dev/pts "$ROOTFS_MOUNT/dev/pts/"
sudo cp /usr/bin/qemu-aarch64 "$ROOTFS_MOUNT/usr/bin/"
sudo chroot "$ROOTFS_MOUNT" /bin/bash -c "update-initramfs -c -k $KERNEL_VERSION"
sudo rm "$ROOTFS_MOUNT/usr/bin/qemu-aarch64"
sudo umount "$ROOTFS_MOUNT/dev/pts"
sudo umount "$ROOTFS_MOUNT/dev"
sudo umount "$ROOTFS_MOUNT/sys"
sudo umount "$ROOTFS_MOUNT/proc"

echo "=== Creating uInitrd ==="
sudo sh -c "cat '$ROOTFS_MOUNT/boot/initrd.img-$KERNEL_VERSION' | mkimage -A arm64 -O linux -T ramdisk -C none -n uInitrd -d - '$BOOT_MOUNT/uInitrd'"

echo "=== SudoOS Kernel Build Complete ==="
