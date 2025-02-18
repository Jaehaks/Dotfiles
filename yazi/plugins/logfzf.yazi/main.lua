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

	-- hide yazi
	local _permit = ya.hide()
	local cwd = tostring(state())

	local child, err = Command('logfzf.cmd')
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

end

return {entry = entry}
