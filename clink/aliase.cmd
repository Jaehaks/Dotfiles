@echo off
REM change code page to view git status message properly
chcp 65001 > nul 2>&1

REM set luarocks config for install library from luarocks
REM 1) for luautf8
luarocks config variables.LUA_INCDIR %USERPROFILE%\scoop\apps\lua\current\include > nul
REM 2) for lua-iconv
luarocks config external_deps_dirs[2] %USERPROFILE%\scoop\apps\mingw\current\x86_64-w64-mingw32 > nul
set LUA_CPATH=%USERPROFILE%\scoop\persist\luarocks\rocks\lib\lua\5.4\?.dll;%LUA_CPATH%
REM 3) for fugit2.nvim
REM luarocks --lua-version=5.1 --local config variables.LUA



REM set komorebi environment variable
set KOMOREBI_CONFIG_HOME=%HOME%\.config\Dotfiles\komorebi
set WHKD_CONFIG_HOME=%HOME%\.config\Dotfiles\komorebi
:: if you want to use autohotkey for komorebi, don't install by scoop
set KOMOREBI_AHK_EXE=%HOME%\Program Files\AutoHotkey\v2\AutoHotkey64.exe

REM set EZA_COLOR for date(da)  [you must don't use double quotes]
set EZA_COLORS=da=38;2;90;241;188:*.pdf=38;2;255;100;100:*.pptx=38;2;255;150;100:*.PPTX=38;2;255;150;100:*.PPT=38;2;255;150;100:*.ppt=38;2;255;150;100:*.xlsx=38;2;200;255;200:*.xls=38;2;200;255;200:*.csv=38;2;200;255;200:*.lnk=38;2;255;255;150:

REM set lf environment variables
set LF_CONFIG_HOME=%HOME%\.config\Dotfiles

REM set yazi environment variables
set "YAZI_FILE_ONE=C:\Program Files\Git\usr\bin\file.exe"
set "YAZI_CONFIG_HOME=%HOME%\.config\Dotfiles\yazi"

REM set environment variables for z.lua
set _ZL_ADD_ONCE=1
set _ZL_MATCH_MODE=1
set _ZL_NO_CHECK=1

REM set environment variable for fzf
set FZF_DEFAULT_OPTS=^
--layout=reverse ^
--border ^
--color=hl:#FF0000,hl+:#00FF00 ^
--preview="bat --color=always {}" ^
--preview-window "down,50%%,hidden" ^
--bind=ctrl-j:up,^
ctrl-k:down,^
ctrl-d:half-page-down,^
ctrl-u:half-page-up,^
ctrl-l:forward-char,^
ctrl-h:backward-char,^
ctrl-a:beginning-of-line,^
ctrl-e:end-of-line,^
ctrl-i:toggle-preview,^
alt-k:preview-half-page-down,^
alt-j:preview-half-page-up

set "BAT_CONFIG_DIR=%HOME%\.config\Dotfiles\bat"
set "BAT_CONFIG_PATH=%HOME%\.config\Dotfiles\bat\config"

REM set environment variables for zoxide
set _ZO_DATA_DIR=%HOME%
doskey zl=zoxide query -ls $*
doskey z=z $*
doskey zi=zi $*


REM qutebrowser (QUTE_CONFIG_DIR / XDG_CONFIG_DIR cannot be recognized. it only is supported on linux)
doskey qutebrowser=qutebrowser --basedir %HOME%\.config\Dotfiles\qutebrowser

doskey ls=ls --color=always $*
doskey ll=eza --git --git-repos-no-status -al --icons=auto --sort=extension --time-style "+%%Y-%%m-%%d %%H:%%M:%%S" $*
doskey grep=grep -i --color=auto $*
doskey lf=lfcd $*


:: check package installed
call check_package_installed.cmd

@echo on
