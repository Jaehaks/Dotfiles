@echo off
setlocal enabledelayedexpansion

REM Define the git log command
set git_log_cmd=git log --all --color=always --format="%%C(auto)%%h%%d %%s %%C(brightcyan)%%cs"

REM Define the fzf command
set fzf_cmd=^
fzf ^
--ansi ^
--no-sort ^
--reverse ^
--bind "ctrl-s:toggle-sort" ^
--tiebreak=index ^
--preview "git show -p {1} | bat --color=always --style=header,grid --language=diff --theme=ansi" ^
--preview-window=bottom,50%%,nohidden

:: check git log has error
%git_log_cmd% > git_log_output.tmp 2>&1
if %errorlevel% neq 0 (
	type git_log_output.tmp
	del git_log_output.tmp
	exit /b %errorlevel%
)

:: Combine the commands
type git_log_output.tmp | %fzf_cmd%

:: delete tmp file
del git_log_output.tmp



endlocal
