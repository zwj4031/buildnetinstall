load_env -f (http)/app/winsetup/netinstall.env;
#set netini=(http)/app/winsetup/netinstall.ini
#loopback -m ini $prefix/ms/mem; mount (ini) 1; cp (http)/app/winsetup/netinstall.ini 1:/netinstall.ini; umount 1;
#export getini=(ini)/netinstall.ini;
if [ "$grub_platform" = "efi" ]; then
	 
export bootmenu=efiboot.sh;
else 

export bootmenu=legacyboot.sh;
fi;
set func=bootmenu; lua $prefix/getini.lua;