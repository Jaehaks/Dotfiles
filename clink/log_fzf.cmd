@echo off
setlocal enabledelayedexpansion

REM Define the git log command
set git_log_cmd=git log --all --color=always --format="%%C(auto)%%h%%d %%s %%C(black)%%C(bold)%%cr"

REM Define the fzf command
set fzf_cmd=^
fzf ^
--ansi ^
--no-sort ^
--reverse ^
--bind "ctrl-s:toggle-sort" ^
--tiebreak=index ^
--preview "git show -p {1} | bat --color=always --style=header,grid --language=diff" ^
--preview-window=bottom,60%%

:: Combine the commands
%git_log_cmd% | %fzf_cmd%

endlocal
