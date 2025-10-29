@echo off
setlocal

:: check pwsh is installed
where pwsh >nul 2>&1
if %errorlevel% neq 0 (
    echo pwsh.exe is needed
    echo https://github.com/PowerShell/PowerShell
    pause
    exit /b 1
)

:: Set the path to the PowerShell script file
:: Since this .cmd file and .ps1 file are always in the same folder, we use %~dp0.
set "PS_SCRIPT_PATH=%~dp0check_package_installed.ps1"

:: execute powershell script
pwsh -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT_PATH%"
if %errorlevel% neq 0 (
    echo.
    echo An error occurred while running the PowerShell script.
)

endlocal
