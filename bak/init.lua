      --getenv j--
		j = grub.getenv ("j")
		ini = grub.ini_load ("(http)/app/winsetup/netinstall.ini") 
		
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
           grub.script ("export " .. myvar .. "=" .. getvar .. "; save_env -f ${prefix}/ms/null.cfg " .. myvar .. "")
        end
    end
end

function getname(num)
    name = (grub.ini_get (ini, num, "name"))
    print (name)
end

function geticon(num)
    icon = (grub.ini_get (ini, num, "icon"))
    print (icon)
end
		--check j--
		

		
        if j ~= nil then
		   getini(j)
		   grub.script ("configfile $prefix/$bootmenu")
		   else
		end
		
		--reset j--
          j = nil
		 
		   
		--add go-previous menu--   
           icon = ("go-previous")
		   name = grub.gettext ("┇返回➯[主页]┇选择要安装的系统")
           command = "configfile $prefix/$bootmode;"
           grub.add_icon_menu (icon, command, name)
		   
		--build menu--   
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
		   command = "export j=" .. j .. "; lua $prefix/getini.lua;" 
		   grub.add_icon_menu (icon,command, name)
    end




