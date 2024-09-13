@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Please provide a file type ^(excel or ppt^)
    exit /b 1
)

if /i "%~1"=="excel" (
	copy /y %HOME%\.config\Dotfiles\clink\NewExcelFile.xlsx .\NewFile.xlsx >nul 2>&1
) else if /i "%~1"=="ppt" (
	copy /y %HOME%\.config\Dotfiles\clink\NewPptFile.pptx .\NewFile.pptx >nul 2>&1
) else (
    echo Invalid file type. Please use 'excel' or 'ppt'.
    exit /b 1
)

endlocal
