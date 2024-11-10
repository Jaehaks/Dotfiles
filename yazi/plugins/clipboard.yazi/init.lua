-- get select files
---@return table paths selected items or a hovered item
local selected_or_hovered = ya.sync(function()
	local paths = {}

	-- get selected files
	for _, u in pairs(cx.active.selected) do
		paths[#paths + 1] = tostring(u)
	end

	-- if anything is selected, select hovered file
	if #paths == 0 and cx.active.current.hovered then
		paths[1] = tostring(cx.active.current.hovered.url)
	end
	return paths
end)


local info = function (content, level)
	content = content or ''
	level = level or 'info'
	ya.notify({
		title = "System Clipboard",
		content = content,
		level = level,
		timeout = 1,
	})
end


return {
	entry = function(_, args)
		local action = args[1]
		ya.manager_emit("escape", { visual = true })

		local urls = selected_or_hovered()

		-- if there are not files even if hovered, fire error
		if action == "copy" then
			-- get file list table

			-- if selected or hovered files doesn't exist, invoke fails
			if #urls == 0 then
				return info("No file selected", 'warn')
			end

			-- copy command
			local status, err = Command("cb"):arg("copy"):args(urls):spawn():wait()
			if status or status.succes then
				info("Succesfully copied the file(s) to system clipboard", 'info')
			else
				info(string.format( "Could not copy selected file(s) %s", status and status.code or err), 'error')
			end

		elseif action == "paste" then
			-- check clipboard has files or directories not text or image
			local child, err      = Command("cb"):arg("info"):stdin(Command.INHERIT):stdout(Command.PIPED):spawn()
			local output, err2    = child:wait_with_output()
			local num_files       = string.match(output.stdout, 'files":%s*(%d+)')
			local num_directories = string.match(output.stdout, 'directories":%s*(%d+)')
			local num_total       = num_files + num_directories

			if num_total then
				-- overwrite even though there are same named files (by stderr(Command.PIPED))
				-- FIXME: if there are same files, it must pop up menu
				child, err = Command("cb"):arg("paste"):stderr(Command.PIPED):spawn()
				output, err = child:wait()

				if output or output.succes then
					info("Pasted " .. num_total .. " file(s) from Clipboard", 'info')
				else
					info(string.format( "Could not copy selected file(s) %s", status and status.code or err), 'error')
				end

			end
		end

		if action == 'copy' or action == 'paste' then
			-- disable selection and visual
			ya.manager_emit("escape", { visual = true, select = true })
			return
		end

		-- copy filename
		if #urls == 0 then return info("No file selected", 'warn')
		elseif #urls > 1 then return info("Please Select one", 'warn')
		end

		local result = ''

		if action == "copy_fullpath" then
			result = urls[1]
		elseif action == "copy_dirpath" then
			result = string.match(urls[1], '(.*)\\[^\\]*$')
		elseif action == "copy_filename" then
			result = string.match(urls[1], '([^\\]+)$')
		elseif action == "copy_filenameonly" then
			result = string.match(urls[1], '([^\\]+)$'):match('^([^%.]+)$?(.-)%.?[^%.]*$')
		end


		local child1, err1 = Command("echo"):arg(result):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
		local child2, err2 = Command("clip"):stdin(child1:take_stdout()):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
		local output, err = child2:wait_with_output()

		-- disable selection and visual
		ya.manager_emit("escape", { visual = true, select = true })

	end,
}
