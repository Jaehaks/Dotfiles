-- ////////////////////////////////////////////////////////////////////////////
-- ////////// init file to set functions to use in configuration //////////////
-- ////////////////////////////////////////////////////////////////////////////


-- [manager] - linemode
function Linemode:size_and_time()
	local time = (self._file.cha.modified or 0) // 1 -- get file date
	time = time and os.date("%Y/%m/%d %H:%M:%S", time) or "" -- show date only when it has

	local size = self._file:size() -- get file size

	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or '-', time))
end

-- [plugins] - bookmarks.yazi
require('bookmarks'):setup({
	save_last_directory = false,
	last_directory = { enable = true, persist = false }, -- save last directory to '
	persist = "all", -- all bookmarks are saved in persistent memory
	desc_format = "parent", -- show bookmark list only parent directory in absolute path
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})
