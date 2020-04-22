      	
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

function getname(num)
           name = (grub.ini_get (ini, num, "name"))
           print (name)
end

function geticon(num)
           icon = (grub.ini_get (ini, num, "icon"))
           print (icon)
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
		if name == nil then
		   name = (j) .. ".[空]"
		else 
		   name = (j).. "." .. (name)
        end		
		if icon == nil then
		   icon = "iso"
        end
		   command = "export func=boot; j=" .. j .. "; lua $prefix/getini.lua;" 
		   grub.add_icon_menu (icon,command, name)
    end


end    
--getenv--
		
        func = grub.getenv ("func")
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
		end
