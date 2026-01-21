--- @since 25.5.31

---@param items string|string[]
local function info(items)
	if type(items) == 'string' then
		items = {items}
	end

	ya.notify({
		title = 'test',
		content = table.concat(items, '\n'),
		timeout = 3,
	})
end

---@param path string file path to manipulate
---@param format string category
---@return string manipulated path
local path_fnamemodify = function (path, format)
	if format == 'name_only' then -- show filename without extension or directory name only
		return string.match(path, '.*[\\/]([^\\/.]+)[%.]?.*$')
	elseif format == 'name' then -- show filename with extension or directory name only
		return string.match(path, '([^\\/]+)$')
	else
		return ''
	end
end

-- get selected files list with ' ' separator
---@return string[]
local get_selected = ya.sync(function ()
	local select = cx.active.selected
	local paths_tb = {}
	if #select > 0 then
		for _, path in pairs(select) do
			paths_tb[#paths_tb+1] = tostring(path)
		end
	else
		paths_tb = {tostring(cx.active.current.hovered.url)}
	end
	return paths_tb
end)

-- get cwd directory name
---@return string
local get_cwd = ya.sync(function ()
	return tostring(cx.active.current.cwd.name)
end)

-- get filename list in cwd. only filename not directory
---@return string[]
local get_cwd_files = ya.sync(function ()
	local files = cx.active.current.files
	local filename_list = {}
	for _, file in ipairs(files) do
		if not file.cha.is_dir then
			filename_list[#filename_list+1] = file.url.name -- get filename only using string format
		end
	end
	return filename_list
end)

---@param filenames string[]
---@param target string
---@return boolean
local check_duplicated_file = function (filenames, target)
	for _, filename in ipairs(filenames) do
		if filename == target then
			return true
		end
	end
	return false
end

-- return proper name to use as default zip file name of input box.
---@param files string[] file path list
---@return string file name candidate
local get_name = function (files)
	local name = ''

	-- create name depends on this rule
	if #files == 1 then
		name = path_fnamemodify(files[1], 'name_only')
	else
		name = get_cwd()
	end

	-- check the result name is duplicated in cwd
	-- If duplicated name is existed, add count like '_1' format
	local cnt = 0
	local ext = '.7z'
	local filename = name .. ext -- initial name
	local cwd_filenames = get_cwd_files()
	while check_duplicated_file(cwd_filenames, filename) do
		cnt = cnt + 1
		filename = string.format('%s_%d%s', name, cnt, ext)
	end

	return (cnt == 0) and name or name .. '_' .. cnt
end

-- append list of table to string
-- local dump_table = ya.sync(function (state, tb)
-- 	local dump_tb = ''
-- 	for key, value in ipairs(tb) do
-- 		dump_tb = value .. '\n' .. dump_tb
-- 	end
-- 	return dump_tb
-- end)


return {
	entry = function ()
		local plugin_name = 'Zip with 7z'
		local files = get_selected() -- get selected file path list
		local name = get_name(files) -- get default zip file name

		-- input for archive file name
		local archive_name, event = ya.input({
			title = plugin_name,
			value = name,
			pos = {'top-center', w = 50},
		})
		if 		event == 0 then ya.notify({ title = plugin_name, content = 'Faile to zip', timeout = 1, })
		elseif 	event == 2 then return
		end

		-- archive file using 7z
		local output, err = Command('7z')
							:arg('a')         -- compression operation
							:arg('-t7z')      -- for .7z
							:arg('-m0=lzma2') -- compress algorithm is LZMA2 (recent)
							:arg('-mx=5')     -- compression level = 5(typical) : it's preset of other size option
							:arg('-ms=on')    -- set solid mode (improve compression ratio)
							:arg('-mmt=on')   -- set multi thread mode
							:arg('-bsp0')     -- don't show process
							:arg('-bso0')     -- don't show output
							:arg('--')
							:arg(archive_name .. '.7z')
							:arg(files)
							:spawn():wait()

		if err then
			ya.notify({
				title = 'compress',
				content = 'Failed to run explorer, error.No : ' .. err,
				timeout = 2,
			})
		end

		-- clear selection
		ya.emit('escape', {visual = true, select = true})
	end
}
