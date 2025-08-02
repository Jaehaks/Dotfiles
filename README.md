# Dotfiles

Dotfiles besides of nvim_config


## Contensts
- [Dotfiles](#dotfiles)
  - [Contensts](#contensts)
  - [plugins](#plugins)
    - [1. [Clink](https://github.com/alacritty/alacritty?tab=readme-ov-file)](#1-clinkhttpsgithubcomalacrittyalacrittytabreadme-ov-file)
    - [2. [FZF](https://github.com/junegunn/fzf)](#2-fzfhttpsgithubcomjunegunnfzf)
    - [3. [z.lua](https://github.com/skywind3000/z.lua)](#3-zluahttpsgithubcomskywind3000zlua)
    - [3. [Alacritty](https://github.com/alacritty/alacritty?tab=readme-ov-file)](#3-alacrittyhttpsgithubcomalacrittyalacrittytabreadme-ov-file)


## Installation requirement
---

### For Windows

#### pre-required environment variable


1. `HOME` : `%USERPROFILE%`
2. `PATH` :
	- `%USERPROFILE%\.config\Dotfiles\clink`
	- `%USERPROFILE%\user_installed\SumatraPDF`
	- `%USERPROFILE%\user_installed\<clinkpath>`
	- `%USERPROFILE%\user_installed\MikTeX\miktex\bin\x64`
	- `%USERPROFILE%\scoop\apps\openjdk11\current\bin`
	- `%USERPROFILE%\Vim\vim90`
3. `CC` : `gcc`
4. `XDG_CONFIG_HOME` : `%USERPROFILE%\.config`
5. `XDG_DATA_HOME` : `%USERPROFILE%\.config`
6. `XDG__HOME` : `%USERPROFILE%\.config`
7. `XDG_RUNTIME_DIR` : `C:\WINDOWS\TEMP\nvim.user`

#### using `scoop`

> [!NOTE]
> To add buckets put this code in cmd prompt
> `scoop bucket add main extras versions java`

```powershell
	scoop install ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bat clipboard unar wget curl unzip gzip tar pwsh openjdk11 go rustup python tree-sitter git gh
	scoop install lua luarocks mingw neovim neovim-qt iconv uutils-coreutils less sed grep obs-studio scoop-search ghostscript windows-terminal yazi zip eza gawk uv
	scoop install win-vind yt-dlp mpv sioyek
```

1. [ffmpeg](https://github.com/FFmpeg/FFmpeg) (for yazi)
2. [7zip](https://7-zip.org/) (for yazi, neovim/mason)
3. [jq](https://github.com/jqlang/jq) (for yazi)
4. [poppler](https://github.com/davidben/poppler) (for yazi)
5. [fd](https://github.com/sharkdp/fd) (for yazi, neovim/snacks)
6. [ripgrep](https://github.com/BurntSushi/ripgrep) (for yazi, neovim/snacks)
7. [fzf](https://github.com/junegunn/fzf) (for yazi)
8. [zoxide](https://github.com/ajeetdsouza/zoxide) (for yazi, clink)
9. [resvg](https://github.com/linebender/resvg) (for yazi)
10. [imagemagick](https://github.com/ImageMagick/ImageMagick) (for yazi)
11. [bat](https://github.com/sharkdp/bat) (for yazi)
12. [clipboard](https://github.com/Slackadays/Clipboard) (for yazi)
13. [unar](https://theunarchiver.com/command-line) (for yazi/lsar.yazi)
14. [wget](https://github.com/mirror/wget) (for neovim/mason)
15. [curl](https://github.com/curl/curl) (for neovim/mason)
16. [unzip](https://infozip.sourceforge.net/) (for neovim/mason)
17. [gzip](https://www.mingw-w64.org/) (for neovim/mason)
18. [tar](https://www.mingw-w64.org/) (for neovim/mason)
19. [pwsh](https://github.com/PowerShell/PowerShell) (for neovim/mason)
	- or [download link](https://github.com/PowerShell/PowerShell/releases)
20. [openjdk11](https://github.com/openjdk/jdk11u) (for neovim/mason)
21. [go](https://github.com/golang/go) (for neovim/go)
22. [rustup](https://github.com/rust-lang/rustup) (for neovim/mason)
23. [python](https://www.python.org/) (for neovim/mason, neovim provider)
24. [tree-sitter](https://tree-sitter.github.io/tree-sitter/) (for neovim/nvim-treesitter)
25. [git](https://github.com/git/git) (for neovim/lazy.nvim, neovim/snacks)
26. [gh](https://cli.github.com/) (for neovim/blink-cmp-git)
27. [lua](https://github.com/LuaLS/lua-language-server) (for neovim)
28. [luarocks](https://luarocks.org/) (for neovim)
29. [mingw](https://www.mingw-w64.org/) (for neovim)
	- gcc (for neovim/nvim-treesitter)
30. [neovim](https://github.com/neovim/neovim) (for neovim)
31. [neovim-qt](https://github.com/equalsraf/neovim-qt) (for neovim)
32. [iconv](https://github.com/processone/iconv) (for `clink/fzff.cmd` and `clink/fzfd.cmd`)
33. [uutils-coreutils](https://github.com/uutils/coreutils) (for linux command)
34. [less](https://www.greenwoodsoftware.com/less/) (for linux command)
35. [sed](https://www.gnu.org/software/sed) (for linux command)
36. [grep](https://www.gnu.org/software/grep) (for linux command)
37. [obs-studio](https://obsproject.com/) (for recording screen)
38. [scoop-search](https://github.com/shilangyu/scoop-search) (for search scoop package)
39. [ghostscript](https://www.ghostscript.com/)
40. [windows-terminal](https://github.com/microsoft/terminal)
41. [yazi](https://github.com/sxyazi/yazi)
42. [zip](https://infozip.sourceforge.net/)
43. [eza](https://github.com/eza-community/eza)
44. [gawk](https://sourceforge.net/projects/ezwinports/)
45. [uv](https://github.com/astral-sh/uv) (for neovim, uv.nvim)
45. [win-vind](https://github.com/pit-ray/win-vind) (vim like control on windows)
46. [yt-dlp](https://github.com/yt-dlp/yt-dlp) (for qutebrowser to view youtube)
47. [mpv](https://mpv.io/) (for qutebrowser to view youtube)
48. [sioyek](https://github.com/ahrm/sioyek) (pdf viewer)

#### using manual download

1. [sumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader)
	- program from `scoop` has some bug
2. [clink](https://github.com/chrisant996/clink/releases)
	- it needs to copy or link files from `dotfiles` to the install path of clink
3. [node.js](https://nodejs.org/ko/download) (for neovim/mason)
	- version v20
	- npm (for neovim/mason)
		- `npm install -g neovim` for `vim.g.loaded_node_provider = 1`
		- `vim.g.loaded_perl_provider = 0` for disable provider warning
4. [MikTeX](https://miktex.org/download)
	- `pdflatex` for `snacks`
	- `latexmk` for `vimtex`
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
		- set <S-TAB> as accept autosuggestion
	- `prompt.lua` :
		- show current git branch name / git status
		- customize prompt and arg colors
		- show virtual environment name
	- `git_checkout.lua` :
		- show completion list when input `TAB` after command {checkout, branch, merge}

<br>

- **Installation**
    1. Download clink from release page Assets : `clink.1.6.14.93b83f.zip`
    2. Unzip the zip file to wanted location
    3. Register the installed location to system path
    4. Register system variables to recognize configuration path : (`clink info` to confirm inputrc path is right)
        - `CLINK_INPUTRC` : `<Dotfile path>\Dotfiles\clink`
        - `CLINK_SETTINGS` : `<Dotfile path>\Dotfiles\clink`
    5. Make symbolic link to use `prompt.lua` :
        - `mklink <clink install path>\prompt.lua <Dotfiles path>\clink\prompt.lua`
    5. Make symbolic link to use `git_checkout.lua` :
        - `mklink <clink install path>\git_checkout.lua <Dotfiles path>\clink\git_checkout.lua`
    6. open `cmd.exe` and do `clink autorun install`

<br>

- **Related file list**
    - `clink\.inputrc` : configuration file
    - `clink\clink_settings` : setting file
    - `clink\prompt.lua` : prompt customization file
    - `clink\git_checkout.lua` : show completion of branch when checkout

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
### 3. [z.lua](https://github.com/skywind3000/z.lua)

- **Description**
    - A new cd command that helps you navigate faster by learning your habits.
    - It works well to detect non-English paths, If your terminal's chcp is 65001 (utf-8).
    - With FZF, z.lua give very convenient way to navigate.

<br>

- **Related file list**
    - `clink\aliases.cmd` : To make aliases command

<br>

- **Installation**
    1. (pre-required) Install clink
    2. Download z.lua : `git clone https://github.com/skywind3000/z.lua.git`
    3. Copy `z.lua` and `z.cmd` from git repository to clink installation directory
    4. Register clink installation directory to environment variable PATH
    4. use `cmd /k <Dotfile path>\Dotfiles\clink\aliases.cmd`

<br>

- **Usage**
    - `zi <keyword>` : aliase of `z -I $*`
        - show fzf window with path related \<keyword\>
    - `zl <keyword>` : aliase of `z -l $*`
        - show list of path related \<keyword\>
    - `zt <keyword>` : aliase of `z -t %*`
        - Go to the most recent path related \<keyword\>



---
### 4. [Alacritty](https://github.com/alacritty/alacritty?tab=readme-ov-file)

- **Description**
    - Terminal emulator using openGL, Fast response to replace windows-terminal.
    - It would be useful to execute wsl.
    - Customization is rich
    - It supports Vi mode for search (but not edit). I use this instead of clink's vi mode.
    - (cons) It cannot support split window.
    - (cons) It doesn't support preset profiles

<br>

- **Related file list**
    - `alacritty\` : configuration file
    - `clink\ac.cmd` : To call alacritty.exe with shorten name.

<br>

- **Installation**
    1. Install alacritty : `scoop install alacritty`
    2. Make dir for configuration : `mkdir %APPDATA%\alacritty`
    3. Make link with configuration file :
        `mklink %APPDATA%\alacritty\alacritty.toml <path to dotfile>\Dotfiles\alacritty\alacritty.toml`
        (:exclamation::exclamation: Caution : terminal should have administrator privilege)

<br>

- **Reference**
    * Detailed configuration list : [Alacritty configuration page](https://alacritty.org/config-alacritty.html)

---
### 5.[yazi](https://github.com/sxyazi/yazi)

- **Description**
	- TUI file manager

- **Installation**
	1. install `git for windows` :
	2. `scoop install yazi 7zip jq poppler fd ripgrep fzf zoxide imagemagick`
	3. `scoop install jid` : suggest instead of `jq` when install `jq` from scoop
	4. `scoop install jid ghostscript` : `imagemagick` needs ghostscript
	5. Add environment variable to `aliase.cmd` : `set "YAZI_FILE_ONE=C:\Program Files\Git\usr\bin\file.exe"`
	6. Add environment variable to `aliase.cmd` : `set "YAZI_CONFIG_HOME=%HOME%\.config\Dotfiles\yazi"`
	7. make yazi home directory : `mkdir %HOME%\.config\Dotfiles\yazi`
	8. copy default yazi configuration files to `YAZI_CONFIG_HOME` from [yazi-config/preset](https://github.com/sxyazi/yazi/tree/main/yazi-config/preset)
	9. (optional) add `excel.exe` path to system environment variables for opening with excel
	10. (optional) add `sumatraPDF.exe` path to system environment variables for opening with sumatraPDF
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
	- location of config file is `~\scoop\apps\sioyek\current\{keys,prefs}_user.config`
	  These are hard linked to `~\scoop\persist\sioyek\{keys,prefs}_user.config`
- **Setting**
	- Make hard link of `{keys,prefs}_user.config` in `Dotfiles/` to config directory of scoop

	```powershell
		scoop install sioyek
		del %HOME%\scoop\persist\sioyek\keys_user.config
		del %HOME%\scoop\persist\sioyek\prefs_user.config
		mklink /H %HOME%\scoop\persist\sioyek\keys_user.config %HOME%\.config\Dotfiles\sioyek\keys_user.config
		mklink /H %HOME%\scoop\persist\sioyek\prefs_user.config %HOME%\.config\Dotfiles\sioyek\prefs_user.config
		scoop reset sioyek # reconnect config file from persist/
	```

	- Set `sioyek` as default pdf viewer


