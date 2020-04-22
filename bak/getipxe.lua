--local file = grub.getenv ("file")
--local file_type = "wim"

local listtxt = "(pxe)/netinstall.ipxe"
--------------------------------以下是菜单项

--网启菜单加入
if (listtxt== nil) then
        return 1
else
        data = grub.file_open(listtxt)
        while (grub.file_eof(data) == false)
        do
		line = grub.file_getline (data)
		line = gbk.toutf8(line)
		line = string.gsub(line, "\= ", "=");
		print (line)
		grub.run (line)
		
         end
        return 0
	----以下略	
end
