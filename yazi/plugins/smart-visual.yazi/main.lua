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

local entry = function ()
	local folder      = cx.active.current
	info(folder)
	local filelist    = folder.files
	local hovered     = folder.hovered
	local ext         = string.match(hovered.url:name(), '%.([^.]+)$') -- check extension from the file name
	local hovered_ext = hovered.cha.is_dir and "directory" or ext

	info('test', 'error')
	local init_pos = folder.cursor
	ya.emit("arrow", {'top'})
	if hovered_ext == 'directory' then
		for _, file in ipairs(filelist) do
			if file.cha.is_dir then
				ya.emit("toggle", {state = 'on'})
			end
			ya.emit("arrow", {1})
		end
	else
		for _, file in ipairs(filelist) do
			ext = string.match(file.url:name(), '%.([^.]+)$') -- check extension from the file name
			if ext == hovered_ext then
				ya.emit("toggle", {state = 'on'})
			end
			ya.emit("arrow", {1})
		end
	end
	ya.emit("arrow", {'top'})
	ya.emit("arrow", {init_pos})
end

return {entry = entry}
