@echo off

setlocal enabledelayedexpansion
chcp 65001 > nul 2>&1
for /F "usebackq tokens=*" %%a in (`zoxide query -i --exclude %cd% %*`) do (
	set z_dir=%%a
	set "z_dir=!z_dir:\=\\!"
	lf -remote "send %id% cd '!z_dir!'"
)
endlocal

REM when you are inside 'for' loop or block of code, you need to use `delayed variable expansion`
REM to correctly access and modify variables
REM because %variable% syntax si evaluated when the line is parsed, not when it is executed
REM so use !variable! instaed of %variable% to access variable expansion in loop
REM
REM Remove extra spaces when you declare variable, not `set z_dir = %%a`, use `set z_dir=%%a`
REM
REM to substitute character of string, use also ! instead of %
REM so change %z_dir:\=\\% => !z_dir:\=\\!
REM to use `lf -remote`, you must replace \ to \\ of dir
