      	--getenv--		       
varlist = 
{
		"name",
		"icon",
		"setupiso",
		"setupwim",
		"command",
		"autounattend",
		"httptimeout",
		"checkwim",
		"p2p",
		"serverip",
		"formatmbr",
		"formatgpt",
		"silent",
		"smb",
		"smbpath",
		"smbuser",
		"smbpass",
		"index"
		
}
wimbootlist =
{
--bios 12346;7 8 10 11 12 13 14 15 16 17 18 19 20
--efi  12345;9 10 11 12 13 14 15 16 17 18 19 20
--wimbootbios 12346;7 8 10 11 20
--wimbootefi 12345;9 10 11 20
        "set lang=en_US; set gfxmode=1920x1080,1366x768,1024x768,800x600,auto; terminal_output gfxterm",--1
		"set enable_progress_indicator=1; echo loading......",--2
	    "loopback wimboot ${prefix}/ms/wimboot.gz",--3
	    "loopback netiso (http)/$setupiso", --4
		"wimboot", --5
		"linux16 (wimboot)/wimboot",--6
        "initrd16 newc:bootmgr:(wimboot)/bootmgr",--7
		"$initrd:bootmgr.exe:(wimboot)/bootmgr.exe",--8
		"$initrd:bootmgfw.efi:(wimboot)/bootmgfw.efi",--9
		"$initrd:BCD:(wimboot)/bcd",--10
		"$initrd:boot.sdi:(wimboot)/boot.sdi",--11
		"$initrd:winpeshl.ini:${prefix}/ms/winpeshl.ini",--12
		"$initrd:startup.bat:${prefix}/ms/startup.bat",--13
		"$initrd:null.cfg:${prefix}/ms/null.cfg",--14
    	"$initrd:7zx64.exe:$prefix/ms/7zx64.exe",--15
		"$initrd:7zx64.dll:$prefix/ms/7zx64.dll",--16
		"$initrd:7zx86.exe:$prefix/ms/7zx86.exe",--17
		"$initrd:7zx86.dll:$prefix/ms/7zx86.dll",--18
		"$initrd:tool.7z:${prefix}/ms/tool.7z",--19
		"$initrd:boot.wim:$bootpath$setupwim",--20
		"$initrd:autounattend.xml:(http)/$autounattend" --21
}
function wimboot(num)
   
   print(wimbootlist[num])
   for i=1,21 do   
        if platform == "efi" then
           grub.exportenv ("initrd", "@")
        else 
           grub.exportenv ("initrd", "newc")
   end	
        grub.script ("export wimboot" .. (i) .."=\"" .. wimbootlist[i] .. "\"")
    end
end


function getini(num)
    i=1
    i=i+1
    for i,myvar in ipairs(varlist) do
            getvar = (ini.get (ini, num, myvar))
        if getvar == nil then
            getvar = ""
        else
          --print(myvar .. "=" .. getvar)
		    grub.script ("unset " .. myvar .. "")
            grub.script ("export " .. myvar .. "=\"" .. getvar .. "\"; save_env -f ${prefix}/ms/null.cfg " .. myvar .. "")
        
        end
		
    end
	--ini.free(ini)
end

function getbootfile()
		 j = grub.getenv ("j")
		 getini(j)
end
	 
function previous()            
		--add go-previous menu--   
        icon = ("go-previous")
        name = grub.gettext ("┇返回➯[主页]┇选择要安装的系统")
        command = "configfile $prefix/main.sh;"
        grub.add_icon_menu (icon, command, name)
end            
        --view bootmenu
function bootmenu()
    for j=1,10 do
	    name= (ini.get (ini, j, "name"))
	    icon= (ini.get (ini, j, "icon"))
	    setupiso = (ini.get (ini, j, "setupiso"))
	    setupwim = (ini.get (ini, j, "setupwim"))
        	            
		if name == nil then
            name = (j) .. ".[空]"
		else 
            name = (j).. "." .. (name)
        end		
		if icon == nil then
            icon = "iso"
	    end
		if setupiso == nil and setupwim ~=nil then
            command = "export func=wimboot; j=" .. j .. "; lua $prefix/open.lua;"   
            grub.add_icon_menu (icon,command, name)
        elseif setupwim == nil and setupiso ~=nil then
            command = "export func=mapiso; j=" .. j .. "; lua $prefix/open.lua;"   
            grub.add_icon_menu (icon,command, name)
        elseif setupwim ~= nil and setupiso ~=nil then
            command = "export func=netsetup; j=" .. j .. "; lua $prefix/open.lua;" 
            grub.add_icon_menu (icon,command, name)
        end
	end	
end    
        --getenv
        func = grub.getenv ("func")
		platform = grub.getenv ("grub_platform")
 		autounattend = grub.getenv ("autounattend")
        ini = ini.load ("(http)/app/winsetup/netinstall.ini")
	   
        if func == nil then
        print("no command!!")
		
	elseif func == "bootmenu" then
		previous()		 
		bootmenu()
		
		--install windows iso
	elseif func == "boot" then
		getbootfile()
		grub.script ("configfile $prefix/$bootmenu")
		
	elseif func == "default" then
		getini(0)
		
		--wimboot
    elseif func == "wimboot" and platform == "efi" then
		--wimbootefi 12345;9 10 11 20
		getbootfile()
		wimboot()
		grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot5; $wimboot9  $wimboot10 $wimboot11 $wimboot20;") 
		
	elseif func == "wimboot" and platform == "pc" then
	    --wimbootbios 12346;7 8 10 11 20
		getbootfile()
		wimboot()
		grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot6; $wimboot7  $wimboot8  $wimboot10 $wimboot11  $wimboot20;") 
		--netsetup	
	elseif func == "netsetup" and platform == "pc" and autounattend == nil then
	    --bios 12346;7 8 10 11 12 13 14 15 16 17 18 19 20
		wimboot()
    	grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot6; $wimboot7  $wimboot8  $wimboot10 $wimboot11 $wimboot12 $wimboot13 " ..
		"$wimboot14 $wimboot15 $wimboot16 $wimboot17 $wimboot18 $wimboot19 $wimboot20;") 
		
	elseif func == "netsetup" and platform == "pc" and autounattend ~= nil then
    	wimboot()
	 	grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot6; $wimboot7  $wimboot8  $wimboot10 $wimboot11 $wimboot12 $wimboot13 " ..
		"$wimboot14 $wimboot15 $wimboot16 $wimboot17 $wimboot18 $wimboot19 $wimboot21 $wimboot20;") 
		--efinetsetup	
	elseif func == "netsetup" and platform == "efi" and autounattend == nil then
    	wimboot()
	    --efi  12345;9 10 11 12 13 14 15 16 17 18 19 20
	grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot5; $wimboo9  $wimboot10 $wimboot11 $wimboot12 $wimboot13 " ..
		"$wimboot14 $wimboot15 $wimboot16 $wimboot17 $wimboot18 $wimboot19 $wimboot20;") 
		
	elseif func == "netsetup" and platform == "efi" and autounattend ~= nil then
    	wimboot()
	    grub.script ("$wimboot1; $wimboot2; $wimboot3;  $wimboot4; $wimboot5; $wimboot9  $wimboot10 $wimboot11 $wimboot12 $wimboot13 " ..
		"$wimboot14 $wimboot15 $wimboot16 $wimboot17 $wimboot18 $wimboot19 $wimboot21 $wimboot20;") 
		--map iso
	elseif func == "mapiso" and platform == "efi" then
		getbootfile()
		print ("正在启动，请稍候……")
		grub.script ("set lang=en_US; set enable_progress_indicator=1; echo loading iso....; map --mem (http)$setupiso")
		
	elseif func == "mapiso" and platform == "pc" then
		getbootfile()
		grub.script ("export grubfm_path=$setupiso; grubfm_file=$setupiso; configfile $prefix/rules/net/iso.sh;")
			
		--efiboot.sh
	elseif func == "efiboot" then
		grub.script ("configfile $prefix/efiboot.sh")
		
		--legacyboot.sh
	elseif func == "legacyboot" then
		grub.script ("configfile $prefix/legacyboot.sh")
		end

