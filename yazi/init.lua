-- ////////////////////////////////////////////////////////////////////////////
-- ////////// init file to set functions to use in configuration //////////////
-- ////////////////////////////////////////////////////////////////////////////


-- [manager] - linemode
-- show size and mtime together
function Linemode:size_and_mtime()
	local time = (self._file.cha.mtime or 0) // 1 -- get file date
	time = time and os.date("%Y/%m/%d %H:%M:%S", time) or "" -- show date only when it has

	local size = self._file:size() -- get file size

	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or '-', time))
end

-- [manager] - Statusmode
-- show original path of symbolic link in the status line (for 'show_symlink' = false)
function Status:name()
	local h = self._tab.current.hovered
	local linked = ""
	if h.link_to ~= nil then
		linked = " 󰜴 " .. tostring(h.link_to)
		return ui.Line("  " .. h.name .. linked)
	else
		return ui.Line(" " .. h.name)
	end
end

-- [plugins] - smart-enter
require('smart-enter'):setup {
	open_multi = false
}

-- [plugins] - zoxide (builtin)
require("zoxide"):setup {
	update_db = true, -- update db.zo automatically whenever move directories
}

-- [plugins] - yamb.yazi
require("yamb"):setup {
  -- Optional, the cli of fzf.
  cli = "fzf",
  -- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
  keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
  -- Optional, the path of bookmark file
  path = os.getenv("HOME") .. "\\.config\\Dotfiles\\yazi\\bookmark",
  -- Optional, disable notify message when jump
  jump_notify = false,
}


-- [plugins] - toggle-pane.yazi
-- preview is hidden by default
require('toggle-pane'):entry('min-preview')



-- [plugins] - githead.yazi
-- show git branch and stochastics right after heading
require('githead'):setup()



-- [plugins] - yazi-rs/git.yazi
-- show git status right after directory
th.git = th.git or {}
th.git.modified_sign  = "M"
th.git.deleted_sign   = "D"
th.git.added_sign     = "A"
th.git.untracked_sign = "?"
th.git.ignored_sign   = "-"
th.git.updated_sign   = "U"
require('git'):setup({
	order = 500 -- order to show directory list. if 1500, gitsign go to rightmost
})


-- [plugins] - yazi-rs/mime-ext.yazi
-- prefetech file's mime using file extension
require('mime-ext'):setup({
	-- by filename database
	with_files = {

	},
	-- by extension database
	with_exts = {
		-- for matlab
		m      = "text/matlab",
		mat    = "application/x-matlab-data",
		mlx    = "application/matlab",
		mdl    = "application/matlab",
		tlc    = "text/x-c",
		slx    = "application/matlab",
		slxc   = "application/matlab",
		mexw64 = "application/vnd.microsoft.portable-executable",

		-- for inca
		dat   = "application/inca",
		mf4   = "application/inca",
		dxl   = "text/inca",
		ascii = "text/inca",

		-- for code
		a2l  = "text/plain",
		hex  = "text/plain",
		temp = "text/plain",
		cmm  = "text/plain",
		bak  = "text/plain",
		cmd  = "text/plain",
		bat  = "text/plain",
		reg  = "text/x-ms-regedit",

		-- for can
		dbc = "text/plain",

		-- for email
		pst = "application/outlook",

		-- for archive
		["7z"] = "application/x-7z-compressed",
	},
	fallback_file1 = false,
})


-- [plugins] - dedukun/relative-motions.yazi
-- show relative number and move cursor with relative number
-- now this plugins version is downloaded and modified for yazi v0.3.3 branch
-- for later, it will be modified
require('relative-motions'):setup({
	show_numbers = "relative_absolute", -- show relative number rendering
	show_motion = false, -- what does it do?
	only_motions = true, -- relative motion works in only motion key, not yank, delete etc...
})
