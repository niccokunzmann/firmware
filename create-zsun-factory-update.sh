#!/bin/bash
#
# Read more about it here: https://github.com/niccokunzmann/zsun-fw-tools
#

cd "`dirname \"$0\"`"

echo Dependencies
echo ============
echo

if ! which tar >/dev/null
then
  echo "tar is required, please install it."
fi

if ! which md5sum >/dev/null
then
  echo "md5sum is required, please install it."
fi

if ! which git >/dev/null
then
  echo "git is required, please install it."
fi

if [ -e zsun-fw-tools ]
then
  (
    cd zsun-fw-tools
    git pull
  )
else
  git clone https://github.com/niccokunzmann/zsun-fw-tools.git
fi

echo Build
echo =====

firmwares=firmwares/ar71xx/default

kernel_bin_out=zsun-fw-tools/data/openwrt-ar71xx-generic-zsun-sdreader-kernel.bin
root_fs_out=zsun-fw-tools/data/openwrt-ar71xx-generic-zsun-sdreader-rootfs-squash.bin

kernel_bin_in="`ls \"$firmwares/\"*zsun-sdreader-kernel.bin`"
root_fs_in="`ls \"$firmwares/\"*zsun-sdreader-rootfs-squashfs.bin`"

if ! [ -e "$root_fs_in" ] || ! [ -e "$kernel_bin_in" ]
then
  echo "Run make to build the zsun OpenWRT files."
  exit 1
fi

rm -f "$kernel_bin_out" "$root_fs_out"
cp "$kernel_bin_in" "$kernel_bin_out"
cp "$root_fs_in" "$root_fs_out"

output="zsun-fw-tools/SD100-update.tar.gz"
(
  cd zsun-fw-tools
  ./makefirmware
)

if [ -f "$output" ]
then
  echo "Your file is available at \"$output\"."
else
  echo "Error"
  exit 1
fi





