# clipboard.yazi

## Features
---

- Copy files/folders to system clipboard
- Paste files/folders to yazi
- Paste image or text from clipboard to make file
- Copy file names


## Requirements

- Windows OS
	- `clip` command : for `copy_fullpath/dirpath/filename/filenameonly` option
	- [clipboard](https://github.com/Slackadays/Clipboard) : to `copy`/`paste` files or directories
	- [irfanview](https://bjansen.github.io/scoop-apps/extras/irfanview/) : To `paste` image or text from clipboard


## Usage
---

### How to Use

* Copy and paste files/directories from windows file explorer
	1) Copy files/directories from windows file explorer using `<C-c>`
	2) Enter `P` in yazi. Copied files will be pasted in current directory
* Copy and paste files/directories from yazi
	1) Copy files/directories from yazi using `Y`
	2) Enter `<C-v>` in windows file manager to paste copied files/directories
* Copy and paste image
	1) Get image to clipboard using `Win + Shift + s`
	2) Enter `P` in yazi. Enter file name without extension. (`.png` will be attached automatically)
	3) Copied image will be pasted as file in current directory
* Copy and paste text
	1) Copy contents using `<C-c>`
	2) Enter `P` in yazi. Enter file name without extension. (`.txt` will be attached automatically)
	3) Copied text will be pasted as file in current directory
* Copy filename
	1) Enter `c,a` to copy full path of file under cursor to clipboard in yazi.
	2) `<C-v>` to paste the copied full path to other gui program.

### Options

- `copy`              : copy selected files to system clipboard
- `paste`             : paste selected files/image/text from system clipboard
- `copy_fullpath`     : copy absolute path of hovered file to system clipboard
- `copy_dirpath`      : copy directory path of hovered file to system clipboard
- `copy_filename`     : copy filename with extension of hovered file to system clipboard
- `copy_filenameonly` : copy filename without extension of hovered file to system clipboard


### select files which is the same with hovered file

```toml

prepend_keymap = [
	{ on = "Y", 		 run = "plugin clipboard 'copy'",      	       desc = "Yank selected files to system clipboard" },
	{ on = "P", 		 run = "plugin clipboard 'paste'",     	       desc = "Paste files or contents from system clipboard" },
	{ on = [ "c", "a" ], run = "plugin clipboard 'copy_fullpath'"    , desc = "Copy the entire path include filename" },
	{ on = [ "c", "d" ], run = "plugin clipboard 'copy_dirpath'"     , desc = "Copy the directory path" },
	{ on = [ "c", "f" ], run = "plugin clipboard 'copy_filename'"    , desc = "Copy the filename" },
	{ on = [ "c", "n" ], run = "plugin clipboard 'copy_filenameonly'", desc = "Copy the filename without extension" },
]
```

