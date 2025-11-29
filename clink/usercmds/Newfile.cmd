@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Please provide a file type ^(xlsx, pptx, pptm^)
    exit /b 1
)

set "TEMPLATE_PATH=%HOME%\.config\Dotfiles\clink\Template"

if /i "%~1"=="xlsx" (
	copy /y "%TEMPLATE_PATH%\NewExcelFile.xlsx" .\NewFile.xlsx >nul 2>&1
) else if /i "%~1"=="pptx" (
	copy /y "%TEMPLATE_PATH%\NewPptFile.pptx" .\NewFile.pptx >nul 2>&1
) else if /i "%~1"=="pptm" (
	copy /y "%TEMPLATE_PATH%\NewPptFile.pptm" .\NewFile.pptm >nul 2>&1
) else (
    echo Invalid file type. Please use 'xlsx' or 'pptx' or 'pptm'.
    exit /b 1
)

endlocal
