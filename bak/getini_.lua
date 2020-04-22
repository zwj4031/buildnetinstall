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
		
function getvar()
for i= 1, 12 do
for j=1,10 do 
grub.run ("ini_get --set=" .. (varlist[i]) .. (j) .. " $getini " .. (j) .. ":" .. (varlist[i]))
end
end
end
        icon = ("go-previous")
        command = "configfile $prefix/$bootmode;"
		name = grub.gettext ("┇返回➯[主页]┇选择要安装的系统")
        grub.add_icon_menu (icon, command, name)
for j=1,10 do 
getvar()
        icon = grub.getenv ("icon" .. (j))
		name = grub.getenv ("name" .. (j))
		serverip = grub.getenv ("serverip" .. (j))
		if name == nil then
		name = (j) .. ".[空]"
		else 
		name = (j).. "." .. (name)
		end		
		if icon == nil then
		icon = "iso"
		end
		if serverip == nil then
		serverip = grub.getenv ("net_default_server")
		grub.exportenv ("serverip" .. (j), serverip)
		end
		command = "export setupiso=$setupiso".. (j) .. "; setupwim=$setupwim" .. (j) .. "; command=$command" .. (j) .. "; "  ..
		"autounattend=$autounattend;" .. (j) .. "; httptimeout=$httptimeout" .. (j) .. "; checkwim=$checkwim" .. (j) .. "; " ..
        "p2p=$p2p" .. (j) .. "; serverip=$serverip" .. (j) .. "; formatmbr=$formatmbr" .. (j) .. "; formatgpt=$formatgpt" .. (j) .. "; " ..		
		"configfile $prefix/$bootmenu;"
		grub.add_icon_menu (icon,command, name)

end







