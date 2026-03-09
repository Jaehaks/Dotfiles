# backup-scoop

Python script for backup some files (scoop / nvim)

## Contents


---
## User guide - backup_scoop.py

A script that copies the Scoop app to another path which is wanted.
It copies the apps/persist/shims folder.

Required external tool: rg, robocopy (built-in to Windows)
Required Python packages: rich
Run:
If you want to move scoop dir from PC1 to PC2.

* from PC1
open cmd prompt
edit SRC_DIR / DST_DIR / APPS
executes `uv run backup_scoop.py backup --new-user <username>` : To copy APPS directories only to backup
send these backup dirs in DST_DIR to PC2

* from PC2
open cmd prompt with administer mode to make symbolic link
paste the backup dirs to SRC_DIR like home()/scoop/
executes `uv run backup_scoop.py create_symlink` : To create symbolic links for each apps in destination PC
