# clipboard.yazi

## Features
---

- copy files/folders to system clipboard
- paste files/folders to yazi
- copy file names


## Requirements

- Windows OS (`clip` command to copy to system clipboard)
- [clipboard](https://github.com/Slackadays/Clipboard)


## Usage
---

### Options

- `copy`              : copy selected files to system clipboard
- `paste`             : paste selected files from system clipboard
- `copy_fullpath`     : copy absolute path of hovered file to system clipboard
- `copy_dirpath`      : copy directory path of hovered file to system clipboard
- `copy_filename`     : copy filename with extension of hovered file to system clipboard
- `copy_filenameonly` : copy filename without extension of hovered file to system clipboard


### select files which is the same with hovered file

```toml
[[manager.prepend_keymap]]
on   = 'Y'
run  = "plugin clipboard --args=copy"
desc = "copy selected files to system clipboard"
```

