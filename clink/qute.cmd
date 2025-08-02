@echo off

REM To make a shortcut for this file,
REM 1) right click to this file
REM 2) open shortcut tab
REM 3) modify "target(대상)" [from C:/~/qute.cmd] to [cmd /c "C:/~/qute.cmd"]
REM 4) change icon as what you want
REM 5) right click and register to taskbar(작업표시줄)
start "" "qutebrowser" --basedir %HOME%\.config\Dotfiles\qutebrowser %*
