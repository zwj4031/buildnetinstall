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

function getini(num)
    i=1
    i=i+1
    for i,myvar in ipairs(varlist) do
             getvar = (ini.get (netini, num, myvar))
        if getvar == nil then
            getvar = ""
        else
        --  print(myvar .. "=" .. getvar)
		    grub.script ("unset " .. myvar .. "")
            grub.script ("export " .. myvar .. "=\"" .. getvar .. "\"; save_env -f ${prefix}/ms/null.cfg " .. myvar .. "")
        
        end
		
    end
	--grub.ini_free(ini)
end

function getbootfile()
		 j = grub.getenv ("j")
		 getini(j)
end
function freemem()            
	ini.free (netini)
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
	    name= (ini.get (netini, j, "name"))
	    icon= (ini.get (netini, j, "icon"))
	    setupiso = (ini.get (netini, j, "setupiso"))
	    setupwim = (ini.get (netini, j, "setupwim"))
        	            
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
        netini = ini.load ("(http)/app/winsetup/netinstall.ini")
	   
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
		getbootfile()
		freemem()  
		grub.script ("set lang=en_US; terminal_output console; set enable_progress_indicator=1; loopback wimboot ${prefix}/wimboot.xz; " ..
		"wimboot --rawwim --testmode=no @:bootmgfw.efi:(wimboot)/bootmgfw.efi @:boot.wim:$bootpath$setupwim")
		
	elseif func == "wimboot" and platform == "pc" then
		getbootfile()
		freemem()  
		grub.script ("set lang=en_US; terminal_output console; set enable_progress_indicator=1; loopback wimboot ${prefix}/wimboot.xz; " .. 
		"wimboot --rawwim --testmode=no @:bootmgfw.efi:(wimboot)/bootmgfw.efi @:boot.wim:$bootpath$setupwim")
		--netsetup	
	elseif func == "netsetup" and platform == "pc" and autounattend == nil then
	    getbootfile()
		freemem()  
    	grub.script ("set lang=en_US; " ..
		"set enable_progress_indicator=1; echo loading...... $bootpath$setupwim; " ..
	    "loopback wimboot ${prefix}/wimboot.xz; " ..
		"loopback netiso (http)/$setupiso; " ..
		"wimboot --rawwim --testmode=no " ..
		"@:bootmgfw.efi:(wimboot)/bootmgfw.efi " ..
		"@:winpeshl.ini:${prefix}/ms/winpeshl.ini " ..
		"@:startup.bat:${prefix}/ms/startup.bat " ..
		"@:null.cfg:${prefix}/ms/null.cfg " ..
		"@:7zx64.exe:$prefix/ms/7zx64.exe " ..
		"@:7zx64.dll:$prefix/ms/7zx64.dll " ..
		"@:7zx86.exe:$prefix/ms/7zx86.exe " ..
		"@:7zx86.dll:$prefix/ms/7zx86.dll " ..
		"@:tool.7z:${prefix}/ms/tool.7z " ..
    	"@:boot.wim:$bootpath$setupwim;")
	
	elseif func == "netsetup" and platform == "pc" and autounattend ~= nil then
	    getbootfile()
		freemem()  
		grub.script ("set lang=en_US; " ..
		"set enable_progress_indicator=1; echo loading...... $bootpath$setupwim; " ..
	    "loopback wimboot ${prefix}/wimboot.xz; " ..
		"loopback netiso (http)/$setupiso; " ..
		"wimboot --rawwim --testmode=no " ..
		"@:bootmgfw.efi:(wimboot)/bootmgfw.efi " ..
		"@:winpeshl.ini:${prefix}/ms/winpeshl.ini " ..
		"@:startup.bat:${prefix}/ms/startup.bat " ..
		"@:null.cfg:${prefix}/ms/null.cfg " ..
		"@:7zx64.exe:$prefix/ms/7zx64.exe " ..
		"@:7zx64.dll:$prefix/ms/7zx64.dll " ..
		"@:7zx86.exe:$prefix/ms/7zx86.exe " ..
		"@:7zx86.dll:$prefix/ms/7zx86.dll " ..
		"@:tool.7z:${prefix}/ms/tool.7z " ..
		"@:autounattend.xml:(http)/$autounattend " ..
		"@:boot.wim:$bootpath$setupwim;")
		
		--efinetsetup	
	elseif func == "netsetup" and platform == "efi" and autounattend == nil then
	    getbootfile()
		freemem()  
		grub.script ("set lang=en_US; " ..
		"set enable_progress_indicator=1; echo loading...... $bootpath$setupwim; " ..
	    "loopback wimboot ${prefix}/wimboot.xz; " ..
		"loopback netiso (http)/$setupiso; " ..
		"wimboot --rawwim --testmode=no " ..
		"@:bootmgfw.efi:(wimboot)/bootmgfw.efi " ..
		"@:winpeshl.ini:${prefix}/ms/winpeshl.ini " ..
		"@:startup.bat:${prefix}/ms/startup.bat " ..
		"@:null.cfg:${prefix}/ms/null.cfg " ..
		"@:7zx64.exe:$prefix/ms/7zx64.exe " ..
		"@:7zx64.dll:$prefix/ms/7zx64.dll " ..
		"@:7zx86.exe:$prefix/ms/7zx86.exe " ..
		"@:7zx86.dll:$prefix/ms/7zx86.dll " ..
		"@:tool.7z:${prefix}/ms/tool.7z " ..
    	"@:boot.wim:$bootpath$setupwim;")
		
	elseif func == "netsetup" and platform == "efi" and autounattend ~= nil then
	    getbootfile()
		freemem()  
		grub.script ("set lang=en_US; " ..
		"set enable_progress_indicator=1; echo loading...... $bootpath$setupwim; " ..
	    "loopback wimboot ${prefix}/wimboot.xz; " ..
		"loopback netiso (http)/$setupiso; " ..
		"wimboot --rawwim --testmode=no " ..
		"@:bootmgfw.efi:(wimboot)/bootmgfw.efi " ..
		"@:winpeshl.ini:${prefix}/ms/winpeshl.ini " ..
		"@:startup.bat:${prefix}/ms/startup.bat " ..
		"@:null.cfg:${prefix}/ms/null.cfg " ..
		"@:7zx64.exe:$prefix/ms/7zx64.exe " ..
		"@:7zx64.dll:$prefix/ms/7zx64.dll " ..
		"@:7zx86.exe:$prefix/ms/7zx86.exe " ..
		"@:7zx86.dll:$prefix/ms/7zx86.dll " ..
		"@:tool.7z:${prefix}/ms/tool.7z " ..
		"@:autounattend.xml:(http)/$autounattend " ..
		"@:boot.wim:$bootpath$setupwim;")
		
		--map iso
	elseif func == "mapiso" and platform == "efi" then
		getbootfile()
		freemem()  
		print ("正在启动，请稍候……")
		grub.script ("set lang=en_US; set enable_progress_indicator=1; echo loading iso....; map --mem (http)$setupiso")
		
	elseif func == "mapiso" and platform == "pc" then
		getbootfile()
		freemem()  
		grub.script ("export grubfm_path=$setupiso; grubfm_file=$setupiso; configfile $prefix/rules/net/netloop_test.sh;")
			
		--efiboot.sh
	elseif func == "efiboot" then
    	freemem()  
		grub.script ("configfile $prefix/efiboot.sh")
		
		--legacyboot.sh
	elseif func == "legacyboot" then
	    freemem()  
		grub.script ("configfile $prefix/legacyboot.sh")
		end

