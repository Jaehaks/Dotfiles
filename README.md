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



## plugins
----
### 1. [Clink](https://github.com/alacritty/alacritty?tab=readme-ov-file)

- **Description**
    - bash's powerful command line editing in cmd.exe on Windows
    - It supports colored command completion, autosuggestion, prompt Customization, lua plugins

<br>

- **Installation**
    1. Download clink from release page Assets : `clink.1.6.14.93b83f.zip`
    2. Unzip the zip file to wanted location
    3. Register the installed location to system path
    4. Register system variables to recognize configuration path : (`clink info` to confirm inputrc path is right)
        - `CLINK_INPUTRC` : `<Dotfile path>\Dotfiles\clink`  
        - `CLINK_SETTINGS` : `<Dotfile path>\Dotfiles\clink`
    5. Make symbolic link to use `prompt.lua` :
        - `cd <clink installed location>`
        - `mklink prompt.lua <Dotfile path>\Dotfiles\clink\prompt.lua`
    6. open `cmd.exe` and do `clink autorun install`

<br>

- **Related file list**
    - `clink\.inputrc` : configuration file
    - `clink_settings` : setting file
    - `clink\prompt.lua` : prompt customization file

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



