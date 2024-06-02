:: you can give a path as argument
@echo off
fd --hidden --type directory . %1 | fzf --layout=reverse --border --bind=ctrl-j:up,ctrl-k:down > %TMP%\fzfd.txt
iconv -f utf-8 -t cp949 %TMP%\fzfd.txt > %TMP%\fzfd_cp949.txt
for /f "delims=" %%i in (%TMP%\fzfd_cp949.txt) do cd /d %%i
