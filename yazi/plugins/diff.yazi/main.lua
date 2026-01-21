--- show error information
local function info(content)
	return ya.notify {
		title = "Diff",
		content = content,
		timeout = 2,
		level = 'error',
	}
end

--- get selected file lists
---@return paths table file list includes selected file
local selected_url = ya.sync(function()
	local tabs = cx.tabs
	local hovered = tostring(cx.active.current.hovered.url)

	local raw_paths = {}
	local paths = {}

	-- get selected file list in all tabs
	for _, tab in ipairs(tabs) do -- cx.tabs can be used with ipairs(), not pairs()
		for _, path in pairs(tab.selected) do
			raw_paths[#raw_paths + 1] = tostring(path)
		end
	end

	-- remove duplicated items
	local seen = {}
	for _, path in ipairs(raw_paths) do
		if not seen[path] then
			seen[path] = true
			table.insert(paths, path)
		end
	end
	local len_path = #paths

	-- if only one path is selected, add hovered files to the list
	if len_path == 1 then
		if paths[1] ~= hovered then
			table.insert(paths, hovered)
		end
	end

	return paths
end)

return {
	entry = function()
		local paths = selected_url()
		local len_paths = #paths

		if not len_paths or len_paths ~= 2 then
			info('Diff Error : ' .. len_paths .. ' file(s) are selected, choose only 2 files')
			return
		end

		local _permit = ui.hide()
		-- use INHERIT as stdin/stdout/stderr for interactive app like nvim
		local status, err = Command("nvim"):arg("-d")
						 	:arg(paths[1]):arg(paths[2])
							:stdin(Command.INHERIT)
							:stdout(Command.INHERIT)
							:stderr(Command.INHERIT)
							:spawn():wait()
		if not status then
			return info("Diff Error : Failed to run diff (code : " .. err .. ")")
		end
		_permit:drop()
		ya.emit('escape', {visual = true, select = true})
	end,
}
