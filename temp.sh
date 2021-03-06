#!/usr/bin/env sh
sudo rm -rf tftpboot
sudo rm -rf netinstall-master
sudo mkdir ./tftpboot
sudo mkdir ./tftpboot/app
sudo mkdir ./tftpboot/Sample
sudo mkdir ./tftpboot/app/winsetup
sudo mkdir ./tftpboot/bin
if [ -d "build" ]
then
    rm -rf build
fi
mkdir build
cp -r boot build/
cp arch/x64-pxe/wimboot.xz build/boot/grubfm/
echo "x86_64-efi"
cd build
find ./boot | cpio -o -H newc > ../build/memdisk.cpio
cd ..
modules=$(cat arch/x64-pxe/builtin.txt)
grub-mkimage -m build/memdisk.cpio -d grub/x86_64-efi -p "(memdisk)/boot/grubfm" -c arch/x64-pxe/config.cfg -o netinstall.efi -O x86_64-efi $modules

if [ -d "build" ]
then
    rm -rf build
fi
mkdir build
cp -r boot build/
mkdir build/boot/grubfm/i386-pc/
cp lang/zh_CN/lang.sh build/boot/grubfm/

echo "i386-pc"
builtin=$(cat arch/legacy-pxe/builtin.lst) 
modlist="$(cat arch/legacy-pxe/insmod.lst) $(cat arch/legacy-pxe/optional.lst)"
for modules in $modlist
do
    echo "copying ${modules}.mod"
    cp grub/i386-pc/${modules}.mod build/boot/grubfm/i386-pc/
done
cp arch/legacy-pxe/insmod.lst build/boot/grubfm/
cp arch/legacy-pxe/wimboot.xz build/boot/grubfm/
cp arch/legacy-pxe/tool.gz build/boot/grubfm/
cp arch/legacy-pxe/grub.exe build/boot/grubfm/
cp arch/legacy-pxe/memdisk build/boot/grubfm/
cd build
find ./boot | cpio -o -H newc > ../netinstallcore
cd ..
modules=$(cat arch/legacy-pxe/builtin.txt)
grub-mkimage -d ./grub/i386-pc -c ./arch/legacy-pxe/pxefm.cfg -o netinstall.pcbios -O i386-pc-pxe -prefix="(pxe)" $modules
cp ipxe.* tftpboot/
cp arch/legacy-pxe/*.bat tftpboot/
cp bin/* tftpboot/bin/
cp *.txt tftpboot/
cp *.exe tftpboot/
cp Sample/* tftpboot/Sample/
mv netinstall.pcbios tftpboot/app/winsetup/
mv netinstall.efi tftpboot//app/winsetup/
mv netinstallcore tftpboot/app/winsetup/
cp netinstall.env tftpboot/app/winsetup/
cp netinstall.ini tftpboot/app/winsetup/netinstall.ini
cp netinstall.ini tftpboot/app/winsetup/netinstall.ini.sample
cp README.md tftpboot/
rm -rf build
sudo cp -r tftpboot/* /mnt/s/netinstall-master/
rm -rf tftpboot

