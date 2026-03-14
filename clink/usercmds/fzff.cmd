@echo off
setlocal enabledelayedexpansion
:: required : set 'file.exe' to system PATH
:: If you install Git for windows, add "Git/bin" and "Git/usr/bin" to PATH

:: get previous chcp value
for /f "tokens=*" %%a in ('chcp') do (
    for %%b in (%%a) do set "PREV_CP=%%b"
)

:: set chcp to "65001" to avoid encoding proble when using fd and fzf
chcp 65001 > nul

:: show result of fd using fzf. and move to selected folder
set "FILE_PATH="
for /f "delims=" %%i in ('fd --hidden --type file %* . ^| fzf --layout^=reverse --border') do (
    set "FILE_PATH=%%i"
)

:: If cancelled (ESC), exit after chcp recovery
if not defined FILE_PATH (
    chcp !PREV_CP! > nul
    exit /b
)

:: check mime type
for /f "usebackq tokens=*" %%m in (`file --mime-type -b "!FILE_PATH!"`) do (
    set "MIME_TYPE=%%m"
)

:: restore chcp
chcp !PREV_CP! > nul

:: run the file using nvim when it is text
if "!MIME_TYPE:~0,5!" == "text/" (
    nvim "!FILE_PATH!"
) else (
    start "" "!FILE_PATH!"
)

endlocal
