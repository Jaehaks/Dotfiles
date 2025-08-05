@echo off

REM it cannot recognize where this code starts
set "USERSCRIPT_DIR=%HOME%\.config\Dotfiles\qutebrowser\config\userscripts"
python "%USERSCRIPT_DIR%\ime_change.py" %*
