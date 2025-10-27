--- @since 25.5.31

-- get selected files list with ' ' separator
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

local get_cwd = ya.sync(function ()
	return tostring(cx.active.current.cwd.name)
end)

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
		local cwd = get_cwd()

		-- input for archive file name
		local archive_name, event = ya.input({
			title = plugin_name,
			value = cwd,
			position = {'top-center', w = 50},
		})

		if 		event == 0 then ya.notify({ title = plugin_name, content = 'Faile to zip', timeout = 1, })
		elseif 	event == 2 then return
		end

		-- archive file using bandizip
		local files = {}
		files = get_selected()
		-- local output, err = Command('bandizip')
		-- 					:arg('c')
		-- 					:arg('-fmt:7z')
		-- 					:arg(archive_name .. '.7z')
		-- 					:args(files)
		-- 					:output()

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
