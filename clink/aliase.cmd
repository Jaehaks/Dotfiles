@echo off
REM set luarocks config for install library from luarocks
REM 1) for luautf8
luarocks config variables.LUA_INCDIR %USERPROFILE%\scoop\apps\lua\current\include > nul
REM 2) for lua-iconv
luarocks config external_deps_dirs[2] %USERPROFILE%\scoop\apps\mingw\current\x86_64-w64-mingw32 > nul
set LUA_CPATH=%USERPROFILE%\scoop\persist\luarocks\rocks\lib\lua\5.4\?.dll;%LUA_CPATH%


REM set EZA_COLOR for date(da)  [you must don't use double quotes]
set EZA_COLORS=da=38;2;90;241;188:*.pdf=38;2;255;100;100:*.pptx=38;2;255;150;100:*.PPTX=38;2;255;150;100:*.PPT=38;2;255;150;100:*.ppt=38;2;255;150;100:*.xlsx=38;2;200;255;200:*.xls=38;2;200;255;200:*.csv=38;2;200;255;200:*.lnk=38;2;255;255;150:

REM set environment variables for z.lua
set _ZL_ADD_ONCE=1
set _ZL_MATCH_MODE=1
set _ZL_NO_CHECK=1

REM set environment variables for zoxide
set _ZO_DATA_DIR=%HOME%
doskey zl=zoxide query -ls $*


doskey ls=ls --color=always $*
doskey ll=eza -al --icons=auto --sort=extension --time-style "+%%Y-%%m-%%d %%H:%%M:%%S" $*
doskey grep=grep -i --color=auto $*
REM doskey zi=z -I $*
REM doskey zl=z -l $*
REM doskey zt=z -t $*
doskey lf=lfcd $*
@echo on
