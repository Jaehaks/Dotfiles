@echo off
setlocal enabledelayedexpansion


set "filename=%1"
set /a hl=%~2
set /a ls=%~3
set /a le=%~4

if !ls! lss 0 (
	set "ls=1"
)

bat !filename! ^
--color=always ^
--line-range !ls!:!le! ^
--highlight-line=!hl! ^
--style=numbers,header ^
--theme=Catppuccin-Mocha-Modi

endlocal
