local get_cwd = ya.sync(function (state) --  to make async function
	local h = cx.active.current.cwd
	return tostring(h)
end)

local function tbl_contains(T, value)
	for _, ext in ipairs(T) do
		if value == ext then
			return true
		end
	end
	return false
end

local entry = function ()
	local value, event = ya.input({
		title = "Enter one of xlsx/pptx/pptm",
		position = {"top-center", y = 3, w = 40},
	})
	if event ~= 1 then
		return
	end

	local ext = ''
	if value then
		ext = value
	end
	if tbl_contains({'xlsx', 'pptx', 'pptm'}, ext) then
		Command('NewFile.cmd'):arg(ext):spawn():wait()
	else
		ya.notify({
			title = 'NewFile',
			content = 'Extension must be input as xlsx/pptx/pptm',
			timeout = 1,
			level = 'warn',
		})
	end
end


return {entry = entry}
