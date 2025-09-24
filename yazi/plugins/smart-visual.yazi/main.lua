--- @since 25.5.31
--- @sync entry


-- -- cx can be called once
-- local get_ext = ya.sync(function()
-- 	local folder   = cx.active.current
-- 	local files    = folder.files
-- 	local hovered  = folder.hovered
-- 	local filename = hovered.url:name()
-- 	local ext      = string.match(filename, '%.([^.]+)$') -- check extension from the file name
--
-- 	return files, hovered.cha.is_dir and "directory" or ext
-- end)

-- local get_filelist = ya.sync(function ()
-- 	return cs.active.current.files
-- end)


local info = function (content, level)
	content = content or ''
	level = level or 'info'
	ya.notify({
		title = "Smart Visual",
		content = content,
		level = level,
		timeout = 1,
	})
end

local function get_ext(file)
	return file.cha.is_dir and "dir" or string.match(file.url.name, '%.([^.]+)$') -- check extension from the file name
end

local function entry()
	local folder      = cx.active.current
	local filelist    = folder.files
	local hovered     = folder.hovered
	local hovered_ext = get_ext(hovered)

	local init_pos = folder.cursor

	-- remove existing selected
	ya.emit("escape", { all = true })
	ya.emit("unyank", {})

	-- select files which has same extension with hovered file
	ya.emit("arrow", {'top'})
	for _, file in  ipairs(filelist) do
		local ext = get_ext(file)
		if ext == hovered_ext then
			ya.emit('toggle', {state = 'on'})
		end
		ya.emit('arrow', {1})
	end

	-- restore cursor to initial state
	ya.emit('arrow', {'top'})
	ya.emit('arrow', {init_pos})
end

return {entry = entry}
