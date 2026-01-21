--- @since 25.5.31

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

local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

return {
	entry = function(_, job)
		local action = job.args[1]
		ya.emit("escape", { visual = true })

		-- get selected files
		local urls = selected_or_hovered()

		-- if there are not files even if hovered, fire error
		if action == "copy" then
			-- get file list table

			-- if selected or hovered files doesn't exist, invoke fails
			if #urls == 0 then
				return info("No file selected", 'warn')
			end

			-- copy command
			local status, err = Command("cb"):arg("copy"):arg(urls):spawn():wait()
			if status or status.succes then
				info("Succesfully copied " .. #urls .. " file(s) to system clipboard", 'info')
			else
				info(string.format( "Could not copy selected file(s) %s", status and status.code or err), 'error')
			end

		elseif action == "paste" then
			-- check clipboard has files or directories
			local child, err      = Command("cb"):arg("info"):stdin(Command.INHERIT):stdout(Command.PIPED):spawn()
			local output, err2    = child:wait_with_output()
			local num_files       = string.match(output.stdout, 'files":%s*(%d+)') or 0
			local num_directories = string.match(output.stdout, 'directories":%s*(%d+)') or 0
			local num_total       = num_files + num_directories

			-- check contents type in clipboard
			-- 'cb' command is related with files/folders only.
			-- It cannot update the contents when clipboard includes text/image.
			-- We cannot recognize what type is using 'cb' only.
			-- I made a function to check clipboard contents type to avoid using powershell
			child, err = Command("checkclipboard.exe")
						 :stdin(Command.INHERIT):stdout(Command.PIPED):spawn()
			output, err2 = child:wait_with_output()
			local cbtype = string.gsub(output.stdout, "%s", "")

			if cbtype == 'Files' then -- if there are files in clipboard
				-- overwrite even though there are same named files (by stderr(Command.PIPED))
				-- FIXME: if there are same files, it must pop up menu
				child, err = Command("cb"):arg("paste"):stderr(Command.PIPED):spawn()
				output, err = child:wait()

				if output or output.succes then
					info("Pasted " .. num_total .. " file(s) from Clipboard", 'info')
				else
					info(string.format( "Could not copy selected file(s) %s", output and output.code or err), 'error')
				end
			else
				local text = ya.clipboard() -- check system clipboard
				if not text then
					info("Clipboard is empty!")
					return
				end

				-- set filename
				local filename, event = ya.input({
					title = 'Input filename only' .. ' (' .. cbtype .. ')',
					value = '',
					position = {"top-center", y = 3, w = 50},
				})
				if event ~= 1 then
					return
				end
				if not filename or filename == "" then
					info("Filename is empty", 'error')
					return
				end

				-- get path
				local sep = (ya.target_family() == 'windows') and '\\' or '/'
				local filepath = get_cwd() .. sep .. filename

				-- save file
				if cbtype == 'Image' then -- if there are image in clipboard
					filepath = filepath .. '.png'
					-- make image file from clipboard
					child, err = Command("irfanview"):arg("/clippaste"):arg("/convert=" .. filepath):stderr(Command.PIPED):spawn()
					output, err = child:wait()
					if not (output or output.succes) then
						info(string.format( "Could not paste %s", output and output.code or err), 'error')
					end
				else -- if there are text in clipboard
					filepath = Url(filepath .. '.txt')
					fs.write(filepath, text)
				end
			end
		end

		if action == 'copy' or action == 'paste' then
			-- disable selection and visual
			ya.emit("escape", { visual = true, select = true })
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
		ya.emit("escape", { visual = true, select = true })

	end,
}
