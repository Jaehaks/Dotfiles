@echo off
:: use ~ to remove "" in argument
set "target=%~1"
:: remove last slash if it exists to avoid error when robocopy is executed
if "%target:~-1%"=="\" set "target=%target:~0,-1%"


:: check argument is valid
if "%target%"=="" (
	echo [Error] Insert directory path to delete
	exit /b
)

if not exist "%target%" (
	echo [Error] %target% doesn't exist
	exit /b
)

echo Remove "%target%"

:: make empty directory temporarily
if not exist "%temp%\empty_dir" mkdir "%temp%\empty_dir"
:: if you use /MT,  no log flags like /NFL, /NDL doesn't work
robocopy "%temp%\empty_dir" "%target%" /MIR /MT:8 > nul

:: remove temp dir
rmdir "%temp%\empty_dir"
:: remove target dir
rmdir /s /q "%target%"

echo Remove completed


