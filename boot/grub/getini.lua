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
             getvar = (grub.ini_get (ini, num, myvar))
        if getvar == nil then
            getvar = ""
        else
          --print(myvar .. "=" .. getvar)
            grub.script ("export " .. myvar .. "=\"" .. getvar .. "\"; save_env -f ${prefix}/ms/null.cfg " .. myvar .. "")
        
        end
		
    end
	--grub.ini_free(ini)
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
	        name= (grub.ini_get (ini, j, "name"))
			icon= (grub.ini_get (ini, j, "icon"))
			
            --getname(j)
            --geticon(j)
			setupiso = (grub.ini_get (ini, j, "setupiso"))
			setupwim = (grub.ini_get (ini, j, "setupwim"))
          --  getsetupiso(j)
          --  getsetupwim(j)		  	            
		if name == nil then
            name = (j) .. ".[空]"
		else 
            name = (j).. "." .. (name)
        end		
		if icon == nil then
            icon = "iso"
	    end
		if setupiso == nil and setupwim ~=nil then
            command = "export func=wimboot; j=" .. j .. "; lua $prefix/getini.lua;"   
            grub.add_icon_menu (icon,command, name)
        elseif setupwim == nil and setupiso ~=nil then
            command = "export func=mapiso; j=" .. j .. "; lua $prefix/getini.lua;"   
            grub.add_icon_menu (icon,command, name)
        elseif setupwim ~= nil and setupiso ~=nil then
            command = "export func=boot; j=" .. j .. "; lua $prefix/getini.lua;" 
            grub.add_icon_menu (icon,command, name)
        end
	end	
end    
        --getenv
        func = grub.getenv ("func")
		platform = grub.getenv ("grub_platform")
        ini = grub.ini_load ("(http)/app/winsetup/netinstall.ini") 
		
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
		grub.script ("set lang=en_US; terminal_output console; set enable_progress_indicator=1; loopback wimboot ${prefix}/ms/wimboot.gz; " ..
		"wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi @:bcd:(wimboot)/bcd @:boot.sdi:(wimboot)/boot.sdi @:boot.wim:(http)$setupwim")
		
		elseif func == "wimboot" and platform == "pc" then
		getbootfile()
		grub.script ("set lang=en_US; terminal_output console; set enable_progress_indicator=1; loopback wimboot /ms/wimboot.gz; " .. 
			"linux16 (wimboot)/wimboot; initrd16 newc:bootmgr:(wimboot)/bootmgr newc:bootmgr.exe:(wimboot)/bootmgr.exe newc:bcd:(wimboot)/bcd " ..
			"newc:boot.sdi:(wimboot)/boot.sdi newc:boot.wim:(http)" .. file)
			
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

