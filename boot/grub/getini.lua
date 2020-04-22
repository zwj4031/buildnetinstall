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
		"formatgpt"
		
}

function getini(num)
    i=1
    i=i+1
    for i,myvar in ipairs(varlist) do
             getvar = (grub.ini_get (ini, num, myvar))
        if getvar == nil then
            getvar = ""
        else
            print(myvar .. "=" .. getvar)
            grub.script ("export " .. myvar .. "=" .. getvar .. "; save_env -f ${prefix}/ms/null.cfg " .. myvar .. "")
            
        end
		
    end
	--grub.ini_free(ini)
end

function wimbootpc(file)
            j = grub.getenv ("j")
            getini(j)
            grub.script ("set lang=en_US; terminal_output console; enable_progress_indicator=1; loopback wimboot /ms/wimboot.gz; linux16 (wimboot)/wimboot; initrd16 newc:bootmgr:(wimboot)/bootmgr newc:bootmgr.exe:(wimboot)/bootmgr.exe newc:bcd:(wimboot)/bcd newc:boot.sdi:(wimboot)/boot.sdi newc:boot.wim:(http)" .. file)

end

function wimbootefi()
            j = grub.getenv ("j")
            getini(j)
            grub.script ("set lang=en_US; terminal_output console; loopback wimboot ${prefix}/ms/wimboot.gz; wimboot @:bootmgfw.efi:(wimboot)/bootmgfw.efi @:bcd:(wimboot)/bcd @:boot.sdi:(wimboot)/boot.sdi @:boot.wim:(http)$setupwim")
end

function mapiso()
            j = grub.getenv ("j")
            getini(j)
            grub.script ("set lang=en_US; terminal_output console; echo loading iso....; map --mem (http)$setupiso")
end


function getname(num)
            name = (grub.ini_get (ini, num, "name"))
            print (name)
end

function geticon(num)
            icon = (grub.ini_get (ini, num, "icon"))
            print (icon)
end

function getsetupwim(num)
            setupwim = (grub.ini_get (ini, num, "setupwim"))
            print (setupwim)
end
function getsetupiso(num)
            setupiso = (grub.ini_get (ini, num, "setupiso"))
            print (setupiso)
end
		
function boot()		
            --if j ~= nil then
            j = grub.getenv ("j")
            getini(j)
            grub.script ("configfile $prefix/$bootmenu")
end
		 
function previous()            
		--add go-previous menu--   
            icon = ("go-previous")
            name = grub.gettext ("┇返回➯[主页]┇选择要安装的系统")
            command = "configfile $prefix/$bootmode;"
            grub.add_icon_menu (icon, command, name)
end            

function bootmenu()
    for j=1,10 do       
            getname(j)
            geticon(j)
            getsetupiso(j)
            getsetupwim(j)		  	            
		if name == nil then
            name = (j) .. ".[空]"
		else 
            name = (j).. "." .. (name)
        end		
		if icon == nil then
            icon = "iso"
	    end
		if setupiso == nil and setupwim ~=nil then
            command = "export func=wimbootefi; j=" .. j .. "; lua $prefix/getini.lua;"   
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
        func = grub.getenv ("func")
		platform = grub.getenv ("grub_platform")
        ini = grub.ini_load ("(http)/app/winsetup/netinstall.ini") 
		
        if func == nil then
        print("no command!!")
		elseif func == "bootmenu" then
		previous()		 
		bootmenu()
		elseif func == "boot" then
		print("boot")
		boot()
		elseif func == "default" then
		getini(0)
	    elseif func == "wimbootefi" then
		wimbootefi()
		elseif func == "mapiso" then
		mapiso()
		elseif func == "wimbootpc" then
		wimbootpc(netwim)
		end

