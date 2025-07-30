@echo off

REM it cannot recognize where this code starts
set "USERSCRIPT_DIR=%HOME%\.config\Dotfiles\qutebrowser\config\userscripts"
python "%USERSCRIPT_DIR%\download_and_open.py" %*
