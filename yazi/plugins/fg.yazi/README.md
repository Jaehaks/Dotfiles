# fg.yazi

## Features
---

- integrate fzf and rg in current working directory
- search file contents using input query
- inspired by [lpnh/fg.yazi](https://github.com/lpnh/fg.yazi) but it implemented for only linux OS
  so this plugin is made for windwos user


## Requirements

These tools must be added to system path
- [fzf](https://junegunn.github.io/fzf/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [bat](https://github.com/sharkdp/bat)
- [bat_range.cmd](https://github.com/Jaehaks/Dotfiles/blob/main/clink/bat_range.cmd)
- [fg.cmd](https://github.com/Jaehaks/Dotfiles/blob/main/clink/fg.cmd)
- [fg_fzf.cmd](https://github.com/Jaehaks/Dotfiles/blob/main/clink/fg_fzf.cmd)

## Usage
---

### Search by Content using ripgrep

Default option uses query as search word for rg

```toml
[[manager.prepend_keymap]]
on   = 'S'
run  = "plugin fg"
desc = "find file by content(rg search)"
```

### Search by Content using fzf

`fzf` option show all contents using `rg ""` and fuzzy search in the result

```toml
[[manager.prepend_keymap]]
on   = 'R'
run  = "plugin fg --args='fzf'"
desc = "find file by content(fuzzy search)"
```

