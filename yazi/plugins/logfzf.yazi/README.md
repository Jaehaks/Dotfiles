# logfzf.yazi

## Features
---

- search git logs by title with fzf
- preview the detailed log using `git show`


## Requirements

These tools must be added to system path
- git
- fzf
- logfzf.cmd

## Usage
---

### Search by title using fzf

- keymaps
	- `ctrl-s` : on/off fzf's sorting
	- `alt-k` : preview half page down
	- `alt-j` : preview half page up
	- `ctrl-k` : down
	- `ctrl-j` : up

```toml
[[manager.prepend_keymap]]
on   = ['z', 'l']
run  = "plugin logfzf"
desc = "find git log by title using fzf"
```

