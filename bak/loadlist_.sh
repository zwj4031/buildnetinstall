# GRUB Environment Block
load_env -f (http)/app/winsetup/netinstall.env;
set netini=(http)/app/winsetup/netinstall.ini
loopback -m ini $prefix/ms/mem; mount (ini) 1; cp (http)/app/winsetup/netinstall.ini 1:/netinstall.ini; umount 1;
export getini=(ini)/netinstall.ini;
lua $prefix/getini.lua;

     if [ "$grub_platform" = "efi" ]; then
export bootmode=efi.sh;	 
export bootmenu=efiboot.sh;
else 
export bootmode=legacybios.sh;	
export bootmenu=legacyboot.sh;
     fi;

menuentry "┇返回➯[主页]┇选择要安装的系统包" --class iso {
configfile $prefix/$bootmode;
}
$no1 menuentry "$name1" --class $icon1 {
$no1 export setupiso=$setupiso1 setupwim=$setupwim1; command=$command1; autounattend=$autounattend1; httptimeout=$httptimeout1; p2p=$p2p1; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no1 }
$no2 menuentry "$name2" --class $icon2 {
$no2 export setupiso=$setupiso2 setupwim=$setupwim2; command=$command2; autounattend=$autounattend2; httptimeout=$httptimeout2; p2p=$p2p2; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no2 }
$no3 menuentry "$name3" --class $icon3 {
$no3 export setupiso=$setupiso3 setupwim=$setupwim3; command=$command3; autounattend=$autounattend3; httptimeout=$httptimeout3; p2p=$p2p3; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no3 }
$no4 menuentry "$name4" --class $icon4 {
$no4 export setupiso=$setupiso4 setupwim=$setupwim4; command=$command4; autounattend=$autounattend4; httptimeout=$httptimeout4; p2p=$p2p4; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no4 }
$no5 menuentry "$name5" --class $icon5 {
$no5 export setupiso=$setupiso5 setupwim=$setupwim5; command=$command5; autounattend=$autounattend5; httptimeout=$httptimeout5; p2p=$p2p5; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no5 }
$no6 menuentry "$name6" --class $icon6 {
$no6 export setupiso=$setupiso6 setupwim=$setupwim6; command=$command6; autounattend=$autounattend6; httptimeout=$httptimeout6; p2p=$p2p6; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no6 }
$no7 menuentry "$name7" --class $icon7 {
$no7 export setupiso=$setupiso7 setupwim=$setupwim7; command=$command7; autounattend=$autounattend7; httptimeout=$httptimeout7; p2p=$p2p7; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no7 }
$no8 menuentry "$name8" --class $icon8 {
$no8 export setupiso=$setupiso8 setupwim=$setupwim8; command=$command8; autounattend=$autounattend8; httptimeout=$httptimeout8; p2p=$p2p8; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no8 }
$no9 menuentry "$name9" --class $icon9 {
$no9 export setupiso=$setupiso9 setupwim=$setupwim9; command=$command9; autounattend=$autounattend9; httptimeout=$httptimeout9; p2p=$p2p9; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no9 }
$no10 menuentry "$name10" --class $icon10 {
$no10 export setupiso=$setupiso10 setupwim=$setupwim10; command=$command10; autounattend=$autounattend10; httptimeout=$httptimeout10; p2p=$p2p10; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no10 }
$no11 menuentry "$name11" --class $icon11 {
$no11 export setupiso=$setupiso11 setupwim=$setupwim11; command=$command11; autounattend=$autounattend11; httptimeout=$httptimeout11; p2p=$p2p11; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no11 }
$no12 menuentry "$name12" --class $icon12 {
$no12 export setupiso=$setupiso12 setupwim=$setupwim12; command=$command12; autounattend=$autounattend12; httptimeout=$httptimeout12; p2p=$p2p12; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no12 }
$no13 menuentry "$name13" --class $icon13 {
$no13 export setupiso=$setupiso13 setupwim=$setupwim13; command=$command13; autounattend=$autounattend13; httptimeout=$httptimeout13; p2p=$p2p13; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no13 }
$no14 menuentry "$name14" --class $icon14 {
$no14 export setupiso=$setupiso14 setupwim=$setupwim14; command=$command14; autounattend=$autounattend14; httptimeout=$httptimeout14; p2p=$p2p14; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no14 }
$no15 menuentry "$name15" --class $icon15 {
$no15 export setupiso=$setupiso15 setupwim=$setupwim15; command=$command15; autounattend=$autounattend15; httptimeout=$httptimeout15; p2p=$p2p15; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no15 }
$no16 menuentry "$name16" --class $icon16 {
$no16 export setupiso=$setupiso16 setupwim=$setupwim16; command=$command16; autounattend=$autounattend16; httptimeout=$httptimeout16; p2p=$p2p16; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no16 }
$no17 menuentry "$name17" --class $icon17 {
$no17 export setupiso=$setupiso17 setupwim=$setupwim17; command=$command17; autounattend=$autounattend17; httptimeout=$httptimeout17; p2p=$p2p17; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no17 }
$no18 menuentry "$name18" --class $icon18 {
$no18 export setupiso=$setupiso18 setupwim=$setupwim18; command=$command18; autounattend=$autounattend18; httptimeout=$httptimeout18; p2p=$p2p18; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no18 }
$no19 menuentry "$name19" --class $icon19 {
$no19 export setupiso=$setupiso19 setupwim=$setupwim19; command=$command19; autounattend=$autounattend19; httptimeout=$httptimeout19; p2p=$p2p19; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no19 }
$no20 menuentry "$name20" --class $icon20 {
$no20 export setupiso=$setupiso20 setupwim=$setupwim20; command=$command20; autounattend=$autounattend20; httptimeout=$httptimeout20; p2p=$p2p20; serverip=${net_default_server}; configfile $prefix/$bootmenu;
$no20 }
#########################################################################################################################################################################################################################################################################################################################