@echo off
setlocal enabledelayedexpansion

:: select file path using fzf and save temp file
fd --hidden --type file %* . | fzf --layout=reverse --border > %TEMP%\fzff.txt

:: change utf-8 to cp949
iconv -f utf-8 -t cp949 %TEMP%\fzff.txt > %TEMP%\fzff_cp949.txt

:: process of file path
:: open file if it is text file, or open using default app
for /f "delims=" %%i in (%TEMP%\fzff_cp949.txt) do (
	set "FILE_PATH=%%i"
	for /f "usebackq tokens=*" %%m in (`file --mime-type -b "!FILE_PATH!"`) do (
		set "MIME_TYPE=%%m"
	)

	if "!MIME_TYPE:~0,5!" == "text/" (
		nvim "!FILE_PATH!"
	) else (
		start "" "!FILE_PATH!"
	)
)

endlocal
:end
