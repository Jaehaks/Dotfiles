-- INFO: caution!!
-- config location : %HOME%/.wezterm.lua
-- it is hard link of %HOME%/.config/Dotfiles/wezterm/.wezterm.lua



-- INFO: initialized variable
-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act     = wezterm.action
local config  = wezterm.config_builder()


-- INFO: main configuration
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = 'Disabled'
config.default_prog = {'cmd.exe', '/k', wezterm.home_dir .. '\\.config\\Dotfiles\\clink\\aliase.cmd'}
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 110
config.initial_rows = 30

-- check $HOME/.local/share/wezterm/wezterm-gui.exe-log    for variable check like this
-- wezterm.log_error('home' .. wezterm.home_dir)



-- INFO: font
-- config.bold_brightens_ansi_color = false -- not works?
config.font_size = 12.0 -- default is 12
config.harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'} -- disable ligatures
config.font = wezterm.font_with_fallback {
	{
		family = 'FiraCode Nerd Font Mono', -- korean name font doesn't work
		weight = 'Bold',
	},
	{
		family = 'Consolas',
		weight = 'Regular',
	}
}
config.command_palette_font_size = 12.0


-- INFO: colors
local default_color = wezterm.color.get_default_colors()
default_color.split = '#FF00FF' -- split pane line color
default_color.cursor_fg = '#333333'
default_color.cursor_bg = '#00FF00'
default_color.cursor_border = '#00FF00'

config.inactive_pane_hsb = { -- color for inactive pane
	saturation = 1.0,        -- color changed
	brightness = 0.1,        -- brightness changed
}

config.colors = default_color



-- INFO: keys
-- clink define key binding first, but western will override the bindings
-- it disables default key of wezterm terminal 
config.disable_default_key_bindings = true
config.keys = {
	{ key = 'l'  , mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },   -- should be remained
                                                                           -- pane
	{ key = 's'  , mods = 'ALT'       , action = act.SplitVertical },
	{ key = 'd'  , mods = 'ALT'       , action = act.SplitHorizontal },
	{ key = 'F3' , mods = 'NONE'      , action = act.ActivatePaneDirection 'Next' },
	{ key = 'F4' , mods = 'NONE'      , action = act.PaneSelect},          -- select pane with alphabet
	{ key = 'F11', mods = 'NONE'      , action = act.ToggleFullScreen},    -- make terminal full screen
	{ key = 'F2' , mods = 'NONE'      , action = act.TogglePaneZoomState}, -- make specific pane maximize toggle
                                                                           -- move
	{ key = 'j'  , mods = 'ALT'       , action = act.ScrollByLine(-2)},
	{ key = 'k'  , mods = 'ALT'       , action = act.ScrollByLine(2)},
	{ key = 'j'  , mods = 'ALT|SHIFT' , action = act.ScrollByPage(-0.5)},
	{ key = 'k'  , mods = 'ALT|SHIFT' , action = act.ScrollByPage(0.5)},
                                                                           -- activate mode
	{ key = 's'  , mods = 'ALT|SHIFT' , action = act.CloseCurrentPane{confirm = false} },
	{ key = 'p'  , mods = 'ALT|SHIFT' , action = act.ActivateCommandPalette},
	{ key = 'y'  , mods = 'ALT|SHIFT' , action = act.ActivateCopyMode},    -- goto copy mode
	{ key = '/'  , mods = 'CTRL'      , action = act.Search{CaseInSensitiveString = ''}}, -- goto search mode


	-- INFO: other palette options
	-- Character selection mode : select emoji or symbols, it works in nvim insert mode
}

config.key_tables = {
	copy_mode = { -- keymap for `ActivateCopyMode`
		-- move
		{ key = 'h'         , mods = 'NONE'      , action = act.CopyMode 'MoveLeft' },
		{ key = 'j'         , mods = 'NONE'      , action = act.CopyMode 'MoveUp' },
		{ key = 'k'         , mods = 'NONE'      , action = act.CopyMode 'MoveDown' },
		{ key = 'l'         , mods = 'NONE'      , action = act.CopyMode 'MoveRight' },
		{ key = 'G'         , mods = 'NONE'      , action = act.CopyMode 'MoveToScrollbackBottom', },
		{ key = 'g'         , mods = 'NONE'      , action = act.CopyMode 'MoveToScrollbackTop', },
		{ key = '0'         , mods = 'NONE'      , action = act.CopyMode 'MoveToStartOfLine' },
		{ key = '^'         , mods = 'SHIFT'     , action = act.CopyMode 'MoveToStartOfLineContent', },
		{ key = '$'         , mods = 'SHIFT'     , action = act.CopyMode 'MoveToEndOfLineContent', },
		{ key = 'b'         , mods = 'NONE'      , action = act.CopyMode 'MoveBackwardWord' },
		{ key = 'w'         , mods = 'NONE'      , action = act.CopyMode 'MoveForwardWord' },
		{ key = 'e'         , mods = 'NONE'      , action = act.CopyMode 'MoveForwardWordEnd', },
		{ key = 'H'         , mods = 'NONE'      , action = act.CopyMode 'MoveToViewportTop' },
		{ key = 'L'         , mods = 'NONE'      , action = act.CopyMode 'MoveToViewportBottom', },
		{ key = 'M'         , mods = 'NONE'      , action = act.CopyMode 'MoveToViewportMiddle', },
		{ key = 'o'         , mods = 'NONE'      , action = act.CopyMode 'MoveToSelectionOtherEnd', },
		{ key = 'O'         , mods = 'NONE'      , action = act.CopyMode 'MoveToSelectionOtherEndHoriz', },
		{ key = 'd'         , mods = 'CTRL'      , action = act.CopyMode { MoveByPage = 0.5 }, },
		{ key = 'u'         , mods = 'CTRL'      , action = act.CopyMode { MoveByPage = -0.5 }, },
		{ key = 'f'         , mods = 'NONE'      , action = act.CopyMode { JumpForward = { prev_char = false } }, },
		{ key = 't'         , mods = 'NONE'      , action = act.CopyMode { JumpForward = { prev_char = true } }, },
		{ key = 'v'         , mods = 'NONE'      , action = act.CopyMode { SetSelectionMode = 'Cell' }, },
		{ key = 'v'         , mods = 'CTRL'      , action = act.CopyMode { SetSelectionMode = 'Block' }, },
		{ key = 'V'         , mods = 'NONE'      , action = act.CopyMode { SetSelectionMode = 'Line' }, },
		-- close
		{ key = 'Escape'    , mods = 'NONE'      , action = act.Multiple { act.CopyMode 'ClearSelectionMode'}},
		{ key = 'q'         , mods = 'NONE'      , action = act.Multiple { act.CopyMode 'ClearSelectionMode', act.CopyMode 'MoveToScrollbackBottom', act.CopyMode 'Close', }},
		{ key = 'c'         , mods = 'CTRL'      , action = act.Multiple { act.CopyMode 'ClearSelectionMode', act.CopyMode 'MoveToScrollbackBottom', act.CopyMode 'Close', }},
		{ key = 'y'         , mods = 'NONE'      , action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'ClearSelectionMode', act.CopyMode 'MoveToScrollbackBottom', act.CopyMode 'Close', }},
		-- move with special key
		{ key = 'PageUp'    , mods = 'NONE'      , action = act.CopyMode 'PageUp' },
		{ key = 'PageDown'  , mods = 'NONE'      , action = act.CopyMode 'PageDown' },
		{ key = 'End'       , mods = 'NONE'      , action = act.CopyMode 'MoveToEndOfLineContent', },
		{ key = 'Home'      , mods = 'NONE'      , action = act.CopyMode 'MoveToStartOfLine', },
		{ key = 'LeftArrow' , mods = 'NONE'      , action = act.CopyMode 'MoveLeft' },
		{ key = 'LeftArrow' , mods = 'ALT'       , action = act.CopyMode 'MoveBackwardWord', },
		{ key = 'RightArrow', mods = 'NONE'      , action = act.CopyMode 'MoveRight', },
		{ key = 'RightArrow', mods = 'ALT'       , action = act.CopyMode 'MoveForwardWord', },
		{ key = 'UpArrow'   , mods = 'NONE'      , action = act.CopyMode 'MoveUp' },
		{ key = 'DownArrow' , mods = 'NONE'      , action = act.CopyMode 'MoveDown' },
		-- search mode
		{ key = '/'         , mods = 'NONE'      , action = act.CopyMode 'EditPattern'}, -- go to search mode
		{ key = 'n'         , mods = 'NONE'      , action = act.Multiple {act.CopyMode 'NextMatch', act.CopyMode 'ClearSelectionMode'}},
		{ key = 'N'         , mods = 'SHIFT'     , action = act.Multiple {act.CopyMode 'PriorMatch', act.CopyMode 'ClearSelectionMode'}},
	}                       ,
	search_mode = {
		{ key = '/'         , mods = 'NONE'      , action = act.CopyMode 'EditPattern'},
		{ key = 'u'         , mods = 'CTRL'      , action = act.CopyMode 'ClearPattern'},
		{ key = 'n'         , mods = 'CTRL'      , action = act.Multiple {act.CopyMode 'NextMatch', act.CopyMode 'ClearSelectionMode'}},
		{ key = 'N'         , mods = 'CTRL|SHIFT', action = act.Multiple {act.CopyMode 'PriorMatch', act.CopyMode 'ClearSelectionMode'}},
		{ key = 'Enter'     , mods = 'NONE'      , action = act.Multiple {act.CopyMode 'AcceptPattern', act.CopyMode 'ClearSelectionMode'}}, -- visual select the pattern goto copy mode
		{ key = 'Escape'    , mods = 'NONE'      , action = act.Multiple {act.CopyMode 'ClearPattern', act.CopyMode 'AcceptPattern', act.CopyMode 'ClearSelectionMode'}},
	}
}




-- and finally, return the configuration to wezterm
return config
