## comment

Vim like pdf file viewer like zathura of linux
It is guide for usage of sioyek from building development branch.

`In Windows`

```powershell
# step1 - make symbolic link from directory which has executable program
# open terminal in admin mode
# If the executable path is %HOME%\user_installed\sioyek-release-windows-xxxxxxx\
# cd to the parent directory of the path. Then make link like this.
mklink /D .\sioyek_current .\sioyek-release-windows-xxxxxxx

# step2 - copy config file
# cd to the sioyek_current\ link directory which is created
mklink /H .\keys_user.config %HOME%\.config\Dotfiles\sioyek\development\keys_user.config
mklink /H .\prefs_user.config %HOME%\.config\Dotfiles\sioyek\development\prefs_user.config
# it needs to change default key config to remove some keys also.
# like `goto_toc t`
mklink /H .\keys.config %HOME%\.config\Dotfiles\sioyek\development\keys.config
mklink /H .\prefs.config %HOME%\.config\Dotfiles\sioyek\development\prefs.config
```


> [!CAUTION] Caution: link with persist folder
> `apps/sioyek/current/keys_user.config` file is hard linked `persist/sioyek/keys_user.config`.
> Modifying the file like removing file in `persist/` breaks the link between these two files.
> The possible way to edit is two method.
> 1) **Concatenate the contents** of file in `persist/` without file manipulating.
>    but it break the synchronization between two files.
> 2) Make **symbolic link** in `persist/` and reconnect with `apps/` using `scoop reset sioyek`
> 3) Make **hard link** in `persist/` and reconnect with `apps/` using `scoop reset sioyek`
> **I choose 3)**
>
> Sioyek reloads config files in `apps/sioyek/current/` automatically immediately whenever the *_user.config file is edited.
> But if config file in `persist/sioyek/` is edited, this hard link is little weird.
> Synchronization doesn't execute immediately. Changes of files in `apps/` occurs when the file in `apps/`
> is opened or sioyek instance is restarted.
>
> Method 2) has a disadvantage. Config doesn't reload automatically even though I edit the config file in `apps/`
> It must be applied after sioyek restart.
> Method 3) is similar like 2). Editing file in `persist/` or `Dotfiles/` will be not applied immediately
> until the config file in `apps/` is opened or sioyek restarts.
> But method 3) can apply immediate change if we edit the config file in `apps/` directly and this change will be
> applied to file in `persist/` or `Dotfiles/`


> [!CAUTION] Caution: check this file after editing other location
> hard link cannot means synchronous relationship. The changes are applied when I open the file.
> **so if you edit file in `apps/` to show immediate change in sioyek, you must open config file in `Dotfiles`
> before git commit.**

## remove default key binding

- There are no way to remove default keybindings without modifying `keys.config`, refer to [issue #296](https://github.com/ahrm/sioyek/issues/296)
- You need to remove some keybindings from `keys.config` to expect proper operation of `keys_user.config`
  below line must be commented
	- `goto_toc t`
		- if this code exists, every command started with 't' doesn't work except of `goto_toc`
- `keys.config` will be updated whenever sioyek is upgraded. So you need to re-edit this.



## build from source

> [!IMPORTANT] Important:
> 1) You need to install visual studio build tools with MSVC v142 for VS2019 because `mupdf` needs it to compile.
> 2) You need to install Qt with MSVC 2022 or 2019 64bit compiler to use MSVC for `qmake`.
> 3) You need to change

### Windows

- I am Windows 10 user and starts `windowsr-terminal` with `chcp 65001` (I don't know it is related with compile.)

1) Download [visual studio build tools 2022 download](https://aka.ms/vs/17/release/vs_BuildTools.exe)
	- download domain is [download domain](https://visualstudio.microsoft.com/ko/downloads/)
	- or you can download [visual studio 2022 community](https://visualstudio.microsoft.com/ko/thank-you-downloading-visual-studio/?sku=Community&channel=Release&version=VS2022&source=VSLandingPage&cid=2030&passive=false) instead of build tools.
	- Since 2025-08-05, `visual studio build tools 2019` doesn't be supported.
	- `visual studio` is the same with `visual studio build tools` includes IDE.

2) Install `visual studio build tools 2022`
	* _select details_
		- [ ] Desktop development using C++
			- [x] MSVC v143 - VS2022 c++ x64/x86 build tool
			- [x] C++ CMake tools for Windows
			- [x] Test tool main feawture - build tools
			- [x] C++ AddressSanitizer
			- [x] vcpkg package manager
			- [x] Windows 10 SDK (or Windows 11 SDK)
			- [x] MSVC v142 - VS2019 C++ x64/x86 build tool
	- `mupdf` needs `MSVC v142 - VS2019` to compile using msbuild.
	- `mupdf` needs `Windows 10 SDK` to compile. It needs to detect standard library to compile such as `string.h`

3) Download [Qt Online Installer for Windows](https://www.qt.io/download-dev)
	- you need to create account and submit your account data to download it

4) Install `Qt` to your preference directory
	- I installed to `C:\Users\USER\user_installed\Qt`
	- Open `Qt Maintenance Tools` and select components what you want to install.
	- Default setting installs Qt with MinGW compiler. **You need to change this to MSVC**
	- sioyek author recommends Qt version `6.7` or `6.8`.
		- `MSVC 2019 64bit` is supported in Qt `v6.7` only. But it doesn't matter if you use `MSVC 2022 64bit`
	* _Required packages_
		- [ ] Qt
			- [ ] Qt 6.8.3
				- [-] MinGW 13.1.0 64bit (disable)
				- [x] MSVC 2022 64-bit (enable)
				- [x] Additional Libraries (enable)
			- [ ] Build Tools
				- [x] MinGW 13.1.0 64-bit (default)
	- `Additional Libraries` is required to detect library when `qmake` command is executed.
		- For example, you can be in front of `texttospeech` error if you don't have additional libraries when `qmake` executes like this.
		```powershell
			Project ERROR: Unknown module(s) in QT: texttospeech
		```
	- Register `<qt_install_path>\Qt\6.8.3\msvc2022_64\bin` in system `PATH`. (use `sysdm.cpl`)
	- Check `qmake` and check the command is in `msvc2022_64` directory.
	```powershell
		@>> where qmake
		C:\Users\USER\user_installed\Qt\6.8.3\msvc2022_64\bin\qmake.exe
	```



5) Execute git clone `development branch` of sioyek
	- I installed to `C:\Users\USER\user_installed\sioyek_build`
	```powershell
	git clone --recursive -b development https://github.com/ahrm/sioyek.git sioyek_build
	```
	- If you want to update this repo later, you need to do it recursively in `sioyek_build` directory.
	```powershell
	git pull --rebase
	git submodule update --init --recursive
	```
	- If you meet conflict, You need force synchronization with the contents of the remote repository.
	```powershell
	# reset local repository
	git reset --hard HEAD
	git clean -df
	# fetch origin repo
	git fetch origin
	git reset --hard origin/development
	# update git repo submodules
	git submodule update --init --recursive --force
	```


6) Modify `build_windows.bat` in `sioyek_build/` like this.
   I attached modified version of `build_windows.bat` also.
	```powershell
		msbuild -maxcpucount mupdf.sln /m /property:Configuration=Debug /property:MultiProcessorCompilation=true /property:Platform=x64
		msbuild -maxcpucount mupdf.sln /m /property:Configuration=Release /property:MultiProcessorCompilation=true /property:Platform=x64

		# below qmake chunk
		msbuild -maxcpucount sioyek.vcxproj /m /property:Configuration=Release /property:Platform=x64

		# you need to add "" to avoid syntax error
		if "%1" == "portable" (
	```
	 **`/properfy:Platform=x64` must added to `msbuild` command.**
		- Original scripts doesn't declare `Platform` property.
		- If you use `visual studio` instead of `visual studio build tools` to build `sioyek/` or `mupdf/` project,
		  It will set the combination of platform `Release|x64` automatically. You can select them in drop box menu
		- But If you use `visual studio build tools`, you must specify the `Platform` property.
		- If you don't set `Platform` property, the combination of platform is set by `Release|Win32` automatically.
		  It makes the build result is created in `mupdf/platform/win32/{Release,Debug}` instead of `mupdf/platform/win32/x64/{Release,Debug}`
		  Because `LIBS` variable includes `mupdf/platform/win32/x64/{Release,Debug}` in `sioyek/pdf_viewer_build_config.pro`,
		  you need to match the platform type.
	- If you use the default `build_windows.bat` file and build by modifying `<AdditionalDependencies>`
	  from `mupdf\platform\win32\x64\Release\libmupdf.lib` to `mupdf\platform\win32\Release\libmupdf.lib` in `sioyek.vcxproj`
	  It invokes linker error.

7) Open `Developer Command Prompt` in `windows-terminal` and build source
	- `Developer Command Prompt` registers commands to build like `msbuild`, `nmake` etc..
	```powershell
		cd <path>/sioyek_build/

		# if you want to non-portable
		build_windows.bat

		# if you want to portable
		build_windows.bat portable
	```


