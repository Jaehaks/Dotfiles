## comment

Vim like pdf file viewer like zathura of linux

`In Windows`

```powershell
	scoop install sioyek
	del %HOME%\scoop\persist\sioyek\keys_user.config
	del %HOME%\scoop\persist\sioyek\prefs_user.config
	mklink /H %HOME%\scoop\persist\sioyek\keys_user.config %HOME%\.config\Dotfiles\sioyek\keys_user.config
	mklink /H %HOME%\scoop\persist\sioyek\prefs_user.config %HOME%\.config\Dotfiles\sioyek\prefs_user.config
	scoop reset sioyek # reconnect config file from persist/
```


> [!CAUTION] Caution: link with persist folder
> `apps/sioyek/current/keys_user.config` file is hard linked `persist/sioyek/keys_user.config`.
> Modifying the file like removing file in `persist/` breaks the link between these two files.
> The possible way to edit is two method.
> 1) **Concatenate the contents** of file in `persist/` without file manipulating.
>    but it break the synchronization between two files.
> 2) Make **symbolic link** in `persist/` and reconnect with `apps/` using `scoop reset sioyek`
> 3) Make **hard link** in `persist/` and reconnect with `apps/` using `scoop reset sioyek`
> I choose 3)
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


