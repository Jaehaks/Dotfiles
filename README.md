# Dotfiles

Dotfiles besides of nvim_config

## Contents
<!--toc:start-->
- [Contensts](#contensts)
- [Installation requirement](#installation-requirement)
- [For Windows](#for-windows)
	- [pre-required environment variable](#pre-required-environment-variable)
	- [using `scoop`](#using-scoop)
	- [using manual download](#using-manual-download)
- [plugins](#plugins)
- [1. [Clink](https://github.com/alacritty/alacritty?tab=readme-ov-file)](#1-clinkhttpsgithubcomalacrittyalacrittytabreadme-ov-file)
- [2. [FZF](https://github.com/junegunn/fzf)](#2-fzfhttpsgithubcomjunegunnfzf)
- [3. [z.lua](https://github.com/skywind3000/z.lua)](#3-zluahttpsgithubcomskywind3000zlua)
- [4. [Alacritty](https://github.com/alacritty/alacritty?tab=readme-ov-file)](#4-alacrittyhttpsgithubcomalacrittyalacrittytabreadme-ov-file)
- [5.[yazi](https://github.com/sxyazi/yazi)](#5yazihttpsgithubcomsxyaziyazi)
- [6. [komorebi](https://github.com/LGUG2Z/komorebi)](#6-komorebihttpsgithubcomlgug2zkomorebi)
- [7. [win-vind](https://github.com/pit-ray/win-vind)](#7-win-vindhttpsgithubcompit-raywin-vind)
- [8. [sioyek](https://github.com/ahrm/sioyek)](#8-sioyekhttpsgithubcomahrmsioyek)
<!--toc:end-->



## Installation requirement
---

### For Windows

#### pre-required environment variable

1. `HOME` : `%USERPROFILE%`
2. `PATH` : register manually below paths
	- `%USERPROFILE%\.config\Dotfiles\clink\usercmds\`
	- `%USERPROFILE%\scoop\apps\git\current\usr\bin` (use file.exe for yazi)
	- `%USERPROFILE%\scoop\apps\mpv\current` (use mpv.exe to video player)
	- `%USERPROFILE%\scoop\apps\openjdk11\current\bin`
	- `%USERPROFILE%\user_installed\sioyek_current` (pdf viewer)
	- `%USERPROFILE%\user_installed\MikTeX\miktex\bin\x64`
	- `%USERPROFILE%\user_installed\Qt\6.10.0\msvc2022_64\bin` (for building sioyek)
	- `%USERPROFILE%\Vim\vim90`
3. `CC` : `gcc` (for C compiler)
4. `XDG_CONFIG_HOME` : `%USERPROFILE%\.config`
5. `XDG_DATA_HOME` : `%USERPROFILE%\.config`
6. `XDG_STATE_HOME` : `%USERPROFILE%\.config`
7. `XDG_RUNTIME_DIR` : `%TEMP%\nvim.user`
7. `CLINK_SETTINGS` : `%USERPROFILE%\.config\Dotfiles\clink` (for clink setting)
7. `CLINK_INPUTRC` : `%USERPROFILE%\.config\Dotfiles\clink` (for clink inputrc)

#### using `scoop`

1) Install [scoop](https://scoop.sh/) by powershell
2) To add buckets in scoop, put this code in cmd prompt first.
   It will add useful buckets (main / extras / versions / java)
	```powershell
	scoop bucket add main extras versions java
	```
3) run `clink\usercmds\aliase.cmd` in cmd prompt
	- It will install all packages predefined in `check_package_installed.ps1` by scoop
4) open `windows terminal` and add this line in `command` of `cmd prompt`
	- `%SystemRoot%\System32\cmd.exe /k %USERPROFILE%\.config\Dotfiles\clink\usercmds\aliase.cmd`
5) command `clink autorun install` to start clink in terminal
	- All lua scripts in `clink\clink_libs` will be used automatically.


#### using manual download

1. ~~[sumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader)~~ (replaced with `sioyek`)
	- program from `scoop` has some bug
2. [sioyek](https://github.com/ahrm/sioyek)
	- pdf viewer
3. [node.js](https://nodejs.org/ko/download) (for neovim/mason)
	- version v20
	- npm (for neovim/mason)
		- `npm install -g neovim` for `vim.g.loaded_node_provider = 1`
		- `vim.g.loaded_perl_provider = 0` for disable provider warning
4. [MikTeX](https://miktex.org/download)
	- `pdflatex` for `snacks.nvim`
	- `latexmk` for `texflow.nvim`
	- It is more convenient to install packages over than `scoop` package
5. [Obsidian](https://obsidian.md/download)
	- for personal markdown notes





## plugins
----
### 1. [Clink](https://github.com/alacritty/alacritty?tab=readme-ov-file)

- **Description**
    - bash's powerful command line editing in cmd.exe on Windows
    - It supports colored command completion, autosuggestion, prompt Customization, lua plugins

<br>

- **Features**
    - `clink_settings` :
		- customized prompt colors
		- hide autosuggestion hint
	- `.inputrc` :
		- set <S-TAB> as accept autosuggestion or other settings
	- `clink_libs\prompt.lua` :
		- show current git branch name / git status
		- customize prompt and arg colors
		- show virtual environment name
	- `clink_libs\git_checkout.lua` :
		- show completion list when input `TAB` after command {checkout, branch, merge}
	- `clink_libs\highlight_envvars.lua` : from [chrisant996/clink-gizmos](https://github.com/chrisant996/clink-gizmos)
		- change default color of environment variable in cmd prompt
	- `clink_libs\fzf.lua` : from [chrisant996/clink-gizmos](https://github.com/chrisant996/clink-gizmos)
		- use fzf to enter files/folders in command line
	- `clink_libs\zoxide.lua` : from [shunsambongi/clink-zoxide](https://github.com/shunsambongi/clink-zoxide)
		- use zoxide in cmd prompt

<br>

- **Installation**
	1. open `cmd.exe` and do `clink autorun install`
		- Now we use clink from scoop, not manuall

<br>

- **Reference**
    * Detailed configuration : [Clink manual page](https://chrisant996.github.io/clink/clink.html)


---
### 2. [FZF](https://github.com/junegunn/fzf)

- **Description**
    - A command-line fuzzy finder
    - It has some limitation on Windows to use like Linux.
      With these files, you can use fzf for file opening and finding directories

<br>

- **Related file list**
    - `clink\fzff.cmd` : To open selected file (supports excel / powerpoint / acrobat pdf)
    - `clink\fzfd.cmd` : To navigate directories
    - `clink\logfzf.cmd` : To show git logs using fzf in cwd

<br>

- **Installation**
    1. Install fzf : `scoop install fzf`
    2. Install fd : `scoop install fd`
    3. Install iconv : `scoop install iconv`
    4. Install nvim : `scoop install nvim`
    4. Install msoffice / adobe acrobat
    5. Register this `clink\` directory to environment variable PATH
    6. Register installation paths which have `excel.exe`, `powerpnt.exe` and `Acrobat.exe` to system PATH.

<br>

- **Usage**
    - `fzfd <directory>`
        - If \<directory\> is empty, it finds subdirectories in current directories using fzf.
        - If you input path as \<directory\>, it finds subdirectories in \<directory\> using fzf.
    - `fzff`
        - It finds all files in current subdirectories.
        - `Enter` will open the sleeted file along to file extension.
            Files which are not belonged to excel, ppt and pdf will open using `nvim`


---
### 3.[yazi](https://github.com/sxyazi/yazi)

- **Description**
	- TUI file manager

- **Installation**
	1. install `git for windows` :
	2. `scoop install yazi 7zip jq poppler fd ripgrep fzf zoxide imagemagick`
	3. `scoop install jid` : suggest instead of `jq` when install `jq` from scoop
	4. `scoop install ghostscript` : `imagemagick` needs ghostscript
	5. Add environment variable to `aliase.cmd` : `set "YAZI_FILE_ONE=C:\Program Files\Git\usr\bin\file.exe"`
	6. Add environment variable to `aliase.cmd` : `set "YAZI_CONFIG_HOME=%HOME%\.config\Dotfiles\yazi"`
	7. make yazi home directory : `mkdir %HOME%\.config\Dotfiles\yazi`
	8. copy default yazi configuration files to `YAZI_CONFIG_HOME` from [yazi-config/preset](https://github.com/sxyazi/yazi/tree/main/yazi-config/preset)
	11. (optional) add `fg.cmd` path to system environment variables for plugin `fg`
	12. (optional) add `fg_fzf.cmd` path to system environment variables for plugin `fg`
	13. (optional) add `bat_range.cmd` path to system environment variables for plugin `fg`

- **Tips**
	- `file --mime-type <filename>`
		- For checking and using `mime` field in yazi.toml, use this command

- **plugins**
	- [ouch.yazi](https://github.com/ndtoan96/ouch.yazi) => Can I replace it by bandizip? (`bz l <filename>`)
		- Show archive preview even though is has subdirectories,
		  it shows folder tree in preview.
		- ouch cannot show non-english word properly.
		- _pre-required_
			- `scoop install ouch`
	- [yamb.yazi](https://github.com/h-hg/yamb.yazi)
		- using vim-like mark to go to marked folder
	- [what-size.yazi](https://github.com/pirafrank/what-size.yazi)
		- calculate size of current selection or cwd (if there are not selection)
		- _pre-required_
			- `du` : `scoop install uutils-coreutils`
			- changed notify time from 5s to 1s
	- [system-clipboard.yazi](https://github.com/Slackadays/ClipBoard)
		- copy files from yazi and paste to other windows explorer
		- _pre-required_
			- `clipboard` : `scoop install clipboard`
		- key : `Y`
		- test



---
### 6. [komorebi](https://github.com/LGUG2Z/komorebi)

- **Description**
	- tiling manager for windows
	- tiling manager lists
		- `glazewm` :
			- It is very fast and simple. It looks work well with other bug
			- It doesn't support stacking window
			- It use zebar to show where I am in workspace. but it doesn't support independent workspace in multi monitor
		- `FancyWM` :
			- It is very stable to use but it is little slow to response
			- It use virtual desktop of windows instead of workspace



---
### 7. [win-vind](https://github.com/pit-ray/win-vind)

- **Description**
	- GUI control using keyboard
	- if you install `win-vind` using `scoop`, it will be installed as portable executable file.
	- location of config file is `~\scoop\persist\win-vind\config\.vindrc` for scoop install file.
- **Setting**
	- Make symbolic link of `.vindrc` to config directory of scoop
	```powershell
		# open terminal with authorized prompt
		del %HOME%\scoop\persist\win-vind\config\.vindrc
		mklink %HOME%\scoop\persist\win-vind\config\.vindrc %HOME%\.config\Dotfiles\win-vind\.vindrc
	```
	- Then, execute `win-vind` in cmd prompt to start `win-vind`


---
### 8. [sioyek](https://github.com/ahrm/sioyek)

- **Description**
	- vim-like pdf viewer
- **Installation**
	- It supports installing using `scoop`, but It is the main branch which is old.
	- Now we build from `developement` branch and upload them with `.7z` file.

	1) move cwd to `Dotfiles/sioyek/development/`
	2) Edit `install_path` variable  where you want in `install_sioyek.bat`
		```powershell
		set "install_path=<directory path>"
		```
	3) Edit `Dotfiles` variable where you download Dotfiles repo in `install_sioyek.bat`
	4) Executes `./sioyek/development/install_sioyek.bat` to install
		- It unzips the sioyek executable file and make hard link of `{keys,prefs}_user.config` in `Dotfiles/` to config directory of scoop

	- Set `sioyek` as default pdf viewer


