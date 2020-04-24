set lang=en_US;
terminal_output console;
loopback wimboot ${prefix}/ms/wimboot.gz;
if [ "$grub_platform" = "efi" ];
then
   set enable_progress_indicator=1;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  echo                 ;
  linuxefi (wimboot)/wimboot;
  initrdefi newc:bootmgfw.efi:(wimboot)/bootmgfw.efi \
            newc:bcd:(wimboot)/bcd \
            newc:boot.sdi:(wimboot)/boot.sdi \
            newc:boot.wim:"${grubfm_file}";
elif [ "$grub_platform" = "pc" ];
then
  set enable_progress_indicator=1;
  linux16 (wimboot)/wimboot;
  initrd16 newc:bootmgr:(wimboot)/bootmgr \
           newc:bootmgr.exe:(wimboot)/bootmgr.exe \
           newc:bcd:(wimboot)/bcd \
           newc:boot.sdi:(wimboot)/boot.sdi \
           newc:boot.wim:"${grubfm_file}";
fi;

