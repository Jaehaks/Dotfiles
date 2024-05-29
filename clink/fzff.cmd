@echo off
fzf --layout=reverse --border --preview="bat {}" --bind=ctrl-j:up,ctrl-k:down> %TMP%\fzff.txt
iconv -f utf-8 -t cp949 %TMP%\fzff.txt > %TMP%\fzff_cp949.txt
for /f "delims=" %%i in (%TMP%\fzff_cp949.txt) do nvim %%i