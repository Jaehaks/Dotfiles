@echo off
if "%~1"=="" goto usage
if "%~2"=="" goto usage

:: remove last backslash
set "src=%~1"
set "dst=%~2"
if "%src:~-1%"=="\" set src=%src:~0,-1%
if "%dst:~-1%"=="\" set dst=%dst:~0,-1%

:: "%%~1" means remove "" from arguments and "" is set manually in this file
:: "%%~n1" means filename without extension from path (desktop/a.txt -> a)
:: "%%~x1" means extension of file (desktop/a.txt -> .txt)
:: "%%~nx1" means filename with extension (desktop/a.txt -> a.txt)
:: "%%~d1" means drive character (C:/desktop/a.txt -> C:)
:: "%%~p1" means parent directory without drive char (C:/desktop/a.txt -> /desktop/)
:: "%%~dp1" means absolute parent directory from cwd (C:/desktop/a.txt -> c:/desktop/)
::          It always return with \ at the end of line. you must remove it
:: "%%~f1" means absolute path
:: "%%~dp2" means "%%~dp" for second argument

:: It check that source is directory of file, and change the command structure
for %%A in ("%src%") do set "attrs=%%~aA"
for %%A in ("%src%") do set "srcname=%%~nxA"
for %%A in ("%src%") do set "srcparent=%%~dpA"
for %%A in ("%dst%") do set "dstabs=%%~fA"
:: remove backslash at the end of variable
if "%srcparent:~-1%"=="\" (
    if not "%srcparent:~-2%"==":\" (
        set "srcparent=%srcparent:~0,-1%"
    )
)

:: copy with separating case file vs folder
if "%attrs:~0,1%"=="d" (
	robocopy "%src%" "%dstabs%\%srcname%" /E /MT:16 /NFL /NDL /NJH /NJS
) else (
	robocopy "%srcparent%" "%dstabs%" "%srcname%" /MT:16 /NFL /NDL /NJH /NJS
)
echo Done.
goto end

:usage
:: If some file is already exists, it will be jump out while robocopy
echo Usage: rcopy [source dir or file] [destination dir]
echo        rcopy c:\Desktop\a c:\Desktop\test  =^> copied to c:\Desktop\test\a
echo        rcopy c:\Desktop\a.txt c:\Desktop\test  =^> copied to c:\Desktop\test\a.txt
echo It doesn't need to check '\' is added to end of line.

:end
