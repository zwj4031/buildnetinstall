#!/usr/bin/env sh
cd wimboot
find .| cpio -o -H newc | gzip -9 > ../wimboot.gz