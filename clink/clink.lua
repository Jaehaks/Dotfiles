-- This file is intentionally blank.
--
-- The old clink.lua file is no longer used, and this blank file ensures if a
-- new clink version is copied over an old clink version, it won't accidentally
-- use an obsolete leftover clink.lua file.

-- this file is located in "clink installed directory"
function show_git_branch()
	local branch_list = io.popen("git branch 2>nul"):lines()
	for line in branch_list do
		local m = line:match("%* (.+)$")
		if m then
			-- \x1b[ : start ANSI code 
			-- 38; : set forground color
			-- 5; will set color code with 255 color
			-- 13m ; pink 
			local b = "\x1b[38;5;13m".."("..m..")".."\x1b[38;5;231m"
			clink.prompt.value = clink.prompt.value:gsub(">"," "..b.." >> ")
			break
		else
			clink.prompt.value = clink.prompt.value:gsub(">"," >> ")
		end
	end
	return false
end

clink.prompt.register_filter(show_git_branch, 50)
