--- @since 26.1.22

local M = {}

--- set ui.Span to filename
---@param filename string
---@param is_dir boolean if true, '/' is added to filename
local function get_span(filename, is_dir)
	local line = is_dir and (filename .. '/') or filename
	local span = ui.Span(line)
	if is_dir then
		span = span:style(ui.Style():fg("#0a43ee"):bold())
	end
	return ui.Line({ span })
end

--- peek cannot save the result globally. so when you executes seek, it rerun peek() also.
--- it makes little input lag when you navigate using seek()
function M:peek(job)
	local path = tostring(job.file.path) -- when .zip file is hovered, get the zip file path

	-- if there is no cache, make new cache item
	local child, err = Command("7z")
		:arg({ "l", "-ba", "-sccUTF-8", path })
		:stdout(Command.PIPED)
		:stderr(Command.NULL)
		:spawn()

	if not child then
		return ya.err("spawn `7z` command failed: " .. tostring(err))
	end

	local limit = job.area.h
	local i, lines = 0, {}

	repeat
		local next_line, event = child:read_line()
		if event ~= 0 then -- if the result is not stdout (err)
			break
		end
		if not next_line then break end

		local file_name = next_line:sub(54):gsub("[\r\n]+", "") -- remove file info data
		local attr = next_line:sub(21,25)                       -- get attributes of files
		local is_dir = attr:sub(1,1) == 'D'                     -- if it has 'D', it is directory

		local is_depth1 = file_name:find('[/\\]') == nil
		if is_depth1 then
			i = i + 1
			if i > job.skip then
				lines[#lines + 1] = get_span(file_name, is_dir)
			end
		end
	until i >= job.skip + limit

	child:start_kill()
	child:wait()

	if job.skip > 0 and #lines < limit then
		ya.emit("peek", { math.max(0, i - limit), only_if = job.file.url, upper_bound = true })
	else
		ya.preview_widget(job, ui.Text(lines):area(job.area))
	end
end

function M:seek(job) require("code"):seek(job) end

return M
