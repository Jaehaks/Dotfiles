--- @since 26.8.15
--- requirements : mupdf

local M = {}

function M:peek(job)
	-- don't do peek() until preview window is opened
	-- peek() is periodically called when preview window is opened, so it doesn't need to call it explicitly in keymap file
	if job.area.w < 1 or job.area.h < 1 then
		return
	end

	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err, bound = self:preload(job)
	if bound and bound > 0 then
		return ya.emit("peek", { bound - 1, only_if = job.file.url, upper_bound = true })
	elseif not ok or err then
		return ya.preview_widget(job, err)
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, job.units, 1)
		ya.emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	local cache_path = tostring(cache) .. ".png"

	-- stylua: ignore
	local output, err = Command("mutool")
		:arg({
			"draw",
			"-q",                                     -- don't show progress message
			"-A", tostring(0), 						  -- disable anti-aliasing to increase performance
			"-F", "png",                              -- output file is .png
			"-r", tostring(rt.preview.image_quality), -- image quality of pdf preview
			"-w", tostring(rt.preview.max_width),     -- max width
			"-o", cache_path,                         -- output image file path
			tostring(job.file.path),                  -- file path to preview
			tostring(job.skip + 1),                   -- preview page
		})
		:output()

	if not output then
		return true, Err("Failed to start `mutool`, error: %s", err)
	elseif not output.status.success then
		os.remove(cache_path) -- if mutool is failed, remove imperfect png file
		local pages = job.skip > 0 and tonumber(output.stderr:match("(%d+) pages"))
		return true, Err("Failed to convert PDF to image, stderr: %s", output.stderr), pages
	end

	return ya.image_precache(Url(cache_path), cache)
end

return M
