@echo off
setlocal

rem get pdf file path as argument
set "PDF=%~1"
if "%PDF%"=="" (
	echo Usage: %~nx0 "file.pdf" 1>&2
	exit /b 2
)

rem If the file is AIP encrypted, open specific viewer
pdfinfo.exe -meta "%PDF%" 2>nul | findstr /i /c:"MSIP_Label" >nul
if "%ERRORLEVEL%"=="0" (
	start "" "msip.viewer" "%PDF%"
	exit /b 0
)

rem If it is normal file, use default viewer
start "" "sumatrapdf" "%PDF%"
exit /b 0
