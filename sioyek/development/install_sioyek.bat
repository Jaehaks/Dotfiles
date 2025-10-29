:: 1) change %install_path% to your destination
:: 2) open terminal as administrator
:: 3) run this file in directory where sioyek release .7z file and config files.

@echo off

:: make sioyek folder link
set "install_path=%USERPROFILE%\user_installed"
set "Dotfiles=%USERPROFILE%\.config\Dotfiles\sioyek\development"

:: save cwd
pushd .

:: find 7z file in cwd
set "cnt=0"
for %%f in (*.7z) do (
	set "Found7z=%%f"
	set /a cnt+=1
)

:: check count 7z file, If not 1, make error
if %cnt% equ 0 (
	echo Error: no *.7z files found
	popd
	exit /b 1
) else if %cnt% gtr 1 (
	echo Error: multiple .7z files found
	popd
	exit /b 1
)

:: get 7z filename and path
for %%a in (%Found7z%) do (
	set "sioyek_filename=%%~na"
	set exe_path=.\%%a
)


:: unzip 7z file to install path
if not exist "%install_path%\%sioyek_filename%" (
	7z x "%exe_path%" -o"%install_path%\%sioyek_filename%"
)

:: make directory symbolic link in install_path
cd /d "%install_path%"
if exist ".\sioyek_current" (
	rmdir ".\sioyek_current"
)
mklink /D ".\sioyek_current" ".\%sioyek_filename%"

:: delete existing config file
cd "%install_path%\sioyek_current"
del /f /q ".\keys_user.config"
del /f /q ".\prefs_user.config"
del /f /q ".\keys.config"
del /f /q ".\prefs.config"

mklink /H ".\keys_user.config" "%Dotfiles%\keys_user.config"
mklink /H ".\prefs_user.config" "%Dotfiles%\prefs_user.config"

mklink /H ".\keys.config" "%Dotfiles%\keys.config"
mklink /H ".\prefs.config" "%Dotfiles%\prefs.config"

:: move to first saved cwd
popd


