@echo off

setlocal enabledelayedexpansion

set "temp_count=%TMP%\komorebic_count.tmp"

:: check komorebic is loaded in task manager
tasklist | findstr /i "komorebic.exe" >nul
if %errorlevel%==0 (
	if exist !temp_count! (
		set /p count=<!temp_count!
	) else (
		set count=0
	)
	set /a count=!count!+1

	if !count! gtr 0 (
		wmic process where name="komorebic.exe" call terminate >nul 2>&1
		set count=0
	)
) else (
	set count=0
)

:: save the updated count to the file
echo !count! > !temp_count!

endlocal

:: Problem
:: while I am using komorebi, it stuck often when some komorebic command is executed
:: even though komorebi is nightly version that it solve the problem.

:: Temporary solution
:: Registry this file in windows task manager with new scheduler .
:: you make the scheduler execute every 5 seconds
:: it detect komorebic is loaded in task manager every 5 seconds, and if it is stucked,
:: terminate the wrong process
