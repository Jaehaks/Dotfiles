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

echo Removing... "%target%"

:: make empty directory temporarily
fastcopy /cmd=delete /no_confirm_del /auto_close "%target%"

echo Remove completed


