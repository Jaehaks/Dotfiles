:: You must register ms_office and Acrobat in %PATH%
@echo off
fd --hidden --type file %* . | fzf --layout=reverse --border > %TMP%\fzff.txt
iconv -f utf-8 -t cp949 %TMP%\fzff.txt > %TMP%\fzff_cp949.txt
for /f "delims=" %%i in (%TMP%\fzff_cp949.txt) do (
	for %%e in (.xlsx;.xls;.csv;.xlsm) do (
		if "%%~xi" == "%%~e" (
			start excel ^"%%i^"
			goto :end
		)
	)
	for %%e in (.pptx;.ppt) do (
		if "%%~xi" == "%%~e" (
			start powerpnt ^"%%i^"
			goto :end
		)
	)
	for %%e in (.pdf) do (
		if "%%~xi" == "%%~e" (
			start Acrobat ^"%%i^"
			goto :end
		)
	)
	nvim-qt ^"%%~i^"
)
:end
