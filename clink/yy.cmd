@echo off
REM to cd when yazi is terminated
setlocal

:: Create a temporary file
set "yazi_tmp=%TMP%\yazi\yazi_cd.tmp"

:: Execute the yazi command with arguments and store the CWD in the temporary file
yazi --cwd-file="%yazi_tmp%"

:: Read the CWD from the temporary file
:: set /p doesn't work with unicode. use for instead
for /f "usebackq delims=" %%a in ("%yazi_tmp%") do (
	set cwd=%%a
)
del "%yazi_tmp%"

:: Check if the CWD is not empty and different from the current directory
if defined cwd (
    if not "%cwd%"=="%CD%" (
        endlocal & cd /d "%cwd%"
    ) else (
		endlocal
	)
) else (
	endlocal
)

