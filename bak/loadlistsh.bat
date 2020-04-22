echo off
del /q loadlist.sh.bak
ren loadlist.sh loadlist.sh.bak
(
echo # GRUB Environment Block>loadlist.sh
echo load_env -f ^(http^)/app/winsetup/netinstall.env;
echo set netini=^(http^)/app/winsetup/netinstall.ini
echo loopback -m ini $prefix/ms/mem; mount (ini^) 1; cp (http^)/app/winsetup/netinstall.ini 1:/netinstall.ini; umount 1;
echo export getini=(ini^)/netinstall.ini;
echo lua $prefix/getini.lua;
echo if [ "$grub_platform" = "efi" ]; then
echo export bootmode=efi.sh;	 
echo export bootmenu=efiboot.sh;
echo else 
echo export bootmode=legacybios.sh;	
echo export bootmenu=legacyboot.sh;
echo fi;
echo menuentry "┇返回➯[主页]┇选择要安装的系统" --class iso {
echo configfile $prefix/$bootmode;
echo }
)>loadlist.sh	 
for /l %%i in (1,1,20) do (
echo $no%%i menuentry "$name%%i" --class $icon%%i {>>loadlist.sh
echo $no%%i export setupiso=$setupiso%%i setupwim=$setupwim%%i; command=$command%%i; autounattend=$autounattend%%i;>>loadlist.sh
echo $no%%i export httptimeout=$httptimeout%%i; p2p=$p2p%%i; serverip=${net_default_server};>>loadlist.sh 
echo $no%%i export formatmbr=$formatmbr%%i; formatgpt=$formatgpt%%i; checkwim=$checkwim%%i; configfile $prefix/$bootmenu;>>loadlist.sh

echo $no%%i }>>loadlist.sh
)

echo #########################################################################################################################################################################################################################################################################################################################>>loadlist.sh

wfr loadlist.sh -r:"\r\n" -t:"\n"
wfr loadlist.sh -r:"#\n" -t:"#"
copy loadlist.sh ..\boot\grub\. /y
cls
echo config "loadlist.sh" Done..
timeout 1