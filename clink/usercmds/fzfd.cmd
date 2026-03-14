:: you can give a path as argument
@echo off

:: get previous chcp value
for /f "tokens=*" %%a in ('chcp') do (
    for %%b in (%%a) do set "PREV_CP=%%b"
)

:: set chcp to "65001" to avoid encoding proble when using fd and fzf
chcp 65001 > nul

:: show result of fd using fzf. and move to selected folder
for /f "delims=" %%i in ('fd --hidden --type directory . %1 ^| fzf --layout^=reverse --border') do (
	cd /d "%%i"
)

:: restore chcp
chcp %PREV_CP% > nul
