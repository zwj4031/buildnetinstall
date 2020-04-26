#!/usr/bin/env sh
cd ../buildnetinstall/boot/grub/ms/tool
find .| cpio -o -H newc | gzip -9 > ../tool.gz