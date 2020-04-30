#!/usr/bin/env sh
sudo rm -rf tftpboot
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
cp arch/x64-pxe/wimboot.gz build/boot/grubfm/ms/
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

echo "i386-pc"
builtin=$(cat arch/legacy-pxe/builtin.lst) 
modlist="$(cat arch/legacy-pxe/insmod.lst) $(cat arch/legacy-pxe/optional.lst)"
for modules in $modlist
do
    echo "copying ${modules}.mod"
    cp grub/i386-pc/${modules}.mod build/boot/grubfm/i386-pc/
done
cp arch/legacy-pxe/insmod.lst build/boot/grubfm/
cp arch/legacy-pxe/wimboot.gz build/boot/grubfm/ms/
cp arch/legacy-pxe/grub.exe build/boot/grubfm/
cp arch/legacy-pxe/memdisk build/boot/grubfm/
cd build
echo gzip .... wait...
find ./boot | cpio -o -H newc | gzip -9 > ../netinstallcore
cd ..
modules=$(cat arch/legacy-pxe/builtin.txt)
grub-mkimage -d ./grub/i386-pc -c ./arch/legacy-pxe/pxefm.cfg -o netinstall.pcbios -O i386-pc-pxe -prefix="(pxe)" $modules
cp ipxe-undionly.* tftpboot/
cp bin/* tftpboot/bin/
cp *.txt tftpboot/
cp *.bat tftpboot/
cp *.exe tftpboot/
cp Sample/* tftpboot/Sample/
mv netinstall.pcbios tftpboot/
mv netinstall.efi tftpboot/
mv netinstallcore tftpboot/app/winsetup/
cp netinstall.env tftpboot/app/winsetup/
cp netinstall.ini tftpboot/app/winsetup/
rm -rf build
cp tftpboot/netinstall.pcbios /mnt/s/netinstall-master/
cp tftpboot/app/winsetup/netinstallcore /mnt/s/netinstall-master/app/winsetup/
cp tftpboot/app/winsetup/netinstallcore /mnt/d/netinstall-master/app/winsetup/
cp tftpboot/netinstall.efi /mnt/s/netinstall-master/
cp tftpboot/netinstall.efi /mnt/d/netinstall-master/
sudo rm -rf tftpboot