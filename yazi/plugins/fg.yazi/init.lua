-- get cwd
local state = ya.sync(function()
	return cx.active.current.cwd
end)

-- fail message
local function fail(s, ...)
	ya.notify { title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" }
end

-- get first string before 'sep'
local function split_and_get_first(input, sep)
	if sep == nil then
		sep = "%s"
	end
	local start, _ = string.find(input, sep)
	if start then
		return string.sub(input, 1, start - 1)
	end
	return input
end

-- main function
local entry = function(_, args)

	-- read additional rg option
	local value, event = ya.input({
		title = "rg options",
		value = '-t md -t txt',
		position = {"top-center", y = 3, w = 40},
	})
	if event ~= 1 then
		return
	end

	-- hide yazi
	local _permit = ya.hide()
	local cwd = tostring(state())
	local cmd = ''

	-- fg.cmd must be in system path
	if args[1] == 'fzf' then
		cmd = 'fg_fzf.cmd'
	else
		cmd = 'fg.cmd'
	end

	local child, err = Command(cmd)
					   :args({value})
					   :cwd(cwd)
					   :stdin(Command.INHERIT)
					   :stdout(Command.PIPED)
					   :stderr(Command.INHERIT)
					   :spawn()
	if not child then
	   return fail("Spawn command failed with error code %s.", err)
	end

	-- get fg output
	local output, err = child:wait_with_output()
	if not output then
	   return fail("Cannot read `fzf` output, error code %s", err)
	elseif not output.status.success and output.status.code ~= 130 then
	   return fail("`fzf` exited with error code %s", output.status.code)
	end

	-- get file url
	local target = output.stdout:gsub("\n$", "")
	local file_url = split_and_get_first(target, ":")

	-- cd to file location
	if file_url ~= "" then
	   ya.manager_emit(file_url:match("[/\\]$") and "cd" or "reveal", { file_url })
	end
end

return {entry = entry}
