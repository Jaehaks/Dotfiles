@echo off
setlocal enabledelayedexpansion

REM get parameters as rg options
set "rg_options="
:loop
if "%~1"=="" goto endloop
set "rg_options=!rg_options! %~1"
shift
goto loop
:endloop

REM set default rg_options (if you use pipe, --sort option makes broken character with non-english)
set "RG_PREFIX=rg --column --line-number --no-heading --color=always --smart-case !rg_options!"

REM do fzf using rg
for /f "tokens=*" %%a in ('!RG_PREFIX! "" ^| fzf --ansi ^
--delimiter ":" ^
--preview "bat_range {1} {2} {2}-5 {2}+5" ^
--preview-window "down,12" ^
') do (
	set "result=%%a"
)

if defined result (
	echo !result!
)

endlocal
