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
mkdir build/boot/grub/x86_64-efi/
modules=$(cat arch/x64-pxe/builtin.txt)
modlist="$(cat arch/x64-pxe/optional.lst)"

for modules in $modlist
do
    echo "copying ${modules}.mod"
    #cp grub/x86_64-efi/${modules}.mod build/boot/grub/x86_64-efi/
done
echo "x86_64-efi"
#cp arch/x64-pxe/optional.lst build/boot/grub/insmod.lst
cd build
find ./boot | cpio -o -H newc > ../build/memdisk.cpio
cd ..
grub-mkimage -m build/memdisk.cpio -d grub/x86_64-efi -p "(memdisk)/boot/grub" -c arch/x64-pxe/config.cfg -o netinstall.efi -O x86_64-efi $modules

if [ -d "build" ]
then
    rm -rf build
fi
mkdir build
cp -r boot build/
mkdir build/boot/grub/i386-pc/

echo "i386-pc"
builtin=$(cat arch/legacy-pxe/builtin.lst) 
modlist="$(cat arch/legacy-pxe/insmod.lst) $(cat arch/legacy-pxe/optional.lst)"
for modules in $modlist
do
    echo "copying ${modules}.mod"
    cp grub/i386-pc/${modules}.mod build/boot/grub/i386-pc/
done
cp arch/legacy-pxe/insmod.lst build/boot/grub/
cd build
find ./boot | cpio -o -H newc > ../netinstallcore
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
cp tftpboot/app/winsetup/netinstallcore /mnt/s/netinstall-master/app/winsetup/
cp tftpboot/netinstall.efi /mnt/s/netinstall-master/
