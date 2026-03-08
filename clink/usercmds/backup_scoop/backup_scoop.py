"""
backup_scoop.py
===============
A script that copies the Scoop app to another path which is wanted.
It copies the apps/persist/shims folder.

Required external tool: rg, robocopy (built-in to Windows)
Required Python packages: rich
Run:
    open cmd prompt with administer mode to make symbolic link
    edit SRC_DIR / DEST_DIR / APPS
    1) executes `uv run backup_scoop.py backup --new-user <username>` : To copy APPS directories only to backup
    2) executes `uv run backup_scoop.py create_symlink` : To create symbolic links for each apps in destination PC
"""

import argparse
import concurrent.futures
import subprocess
import time
from pathlib import Path
from typing import TypedDict, cast

from rich.console import Console

from utils.modifyUser import modify_username

console = Console()  # for pretty console regardless of multi threading


# ══ settings ════════════════════════════════════════════════════════════
SRC_DIR = Path.home() / "scoop"    # source path
DST_DIR  = Path.home() / "Desktop" / "scoop" # destination path
# use r"" to use '\' literally

# Recommend (PY_THREADS × ROBO_THREADS ≤ 32)
PY_THREADS   = 16  # the number of python multi threading
ROBO_THREADS = 2   # the number of thread of Robocopy

APPS = [
    "7zip",
    "bat",
    "biber",
    "cacert",
    "clink",
    "clipboard",
    "curl",
    "deno",
    "eza",
    "fd",
    "ffmpeg",
    "fzf",
    "gawk",
    "ghostscript",
    "grep",
    "gzip",
    "imagemagick",
    "innounp",
    "irfanview",
    "jid",
    "jq",
    "lua",
    "mingw-winlibs",
    "mpv",
    "neovim",
    "neovim-qt",
    "poppler",
    "ripgrep",
    "sed",
    "tar",
    "tree-sitter",
    "unar",
    "unzip",
    "uutils-coreutils",
    "uv",
    "vcredist2022",
    "wget",
    "windows-terminal",
    "yazi",
    "zip",
    "zoxide",
]

def copy_dir(src: Path, dest: Path) -> bool:
    """
    Copy directories with multithreaded Robocopy.
    It will use for apps/persists directory copy

    Parameters
     ---------
    - src : Path Source directory
    - dst : Path Destination directory (automatically created if not present)

    Returns
     ------
    - bool Whether copying was successful (success if Robocopy exit code < 8)

    Robocopy options
        /E: Copy all subfolders including empty folders
        /MT:{N}: Copy files in parallel with N threads
        /R:1 /W:1: Retry once in case of failure, wait 1 second
                ( default is 1000 times/30 seconds each, which is very slow)
        /NFL /NDL /NJH /NJS: Omit log output → Improve speed
        /XD current : Copy except of this name of directory
    """

    if not src.exists():
        return False

    dest.mkdir(parents=True, exist_ok=True)

    result = subprocess.run(
        ["robocopy", str(src), str(dest),
         "/E", f"/MT:{ROBO_THREADS}", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS",
         "/XD", "current"],
        capture_output=True,  # stdout/stderr 캡처 (Progress 표시와 충돌 방지)
    )
    return result.returncode < 8


def copy_shims(app: str) -> int:
    """
    check *.shim file whose path in content has "app" name. and copy them to destination directory

    Parameters
     ---------
    - app : App Directory name (e.g. "git")

    Returns
     ------
    - int Number of shim sets copied

    How it works:
        Example inside a .shim file: path = "C:\\Users\\user\\scoop\\apps\\git\\current\\bin\\git.exe"
        Search for .shim files containing the pattern "\\apps\\{app}\\" with rg
        and copy the entire set of .exe / .shim / .cmd files with the same name.

    rg options:
        -l: Print only the matched file path (do not print the contents)
        -i: Ignore case
        -g "*.shim": glob for .shim files only
    """
    src_shim  = SRC_DIR / "shims"
    dest_shim = DST_DIR / "shims"

    # get shim file list with unit string format which is matched with app name
    result = subprocess.run(
        ["rg", "-l", "-i", "-g", "*.shim", f"\\\\apps\\\\{app}\\\\", str(src_shim)],
        capture_output=True,
        text=True,
        encoding="utf-8",
    )

    # make list constitute of .shim file Path from string "result.stdout" using splitlines()
    # if the line has empty line, it filtered by "if l.strip()"
    matches = [Path(line.strip()) for line in result.stdout.splitlines() if line.strip()]

    # for tools which has apps name in contents
    for file_shim in matches:
        filename_only = file_shim.stem  # get only file name in path without extension
        result = subprocess.run(
            ["robocopy", str(src_shim), str(dest_shim), f"{filename_only}.*",
             "/E", f"/MT:{ROBO_THREADS}", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS"],
            capture_output=True,
        )

    return len(matches)

# declare dictionary type like @class in lua
class CopyResult(TypedDict):
    app_name: str
    ok_apps: bool
    ok_persist: bool
    count_shims: int

def copy_app(app: str) -> CopyResult:
    """
    Copies all apps/persist/shims directories related with the name "app"
    It will called by parallel threading

    Parameters
    ----------
    app      : str       The name of app

    Returns
    -------
    dict
    """

    apps_ok = copy_dir(SRC_DIR / "apps" / app, DST_DIR / "apps" / app)
    persist_ok = copy_dir(SRC_DIR / "persist" / app, DST_DIR / "persist" / app)
    shim_count = copy_shims(app)

    return {
        "app_name": app,
        "ok_apps": apps_ok,
        "ok_persist": persist_ok,
        "count_shims": shim_count
    }


def create_symlink():
    console.print("\n==== Create symbolic links for each apps ====\n")
    apps_dir = DEST_DIR / "apps"

    for cur_dir in apps_dir.iterdir():
        if not apps_dir.is_dir():
            continue

        target_link = cur_dir / "current" # target symbolic link

        # check "current" directory exists, remove if it is yes.
        if target_link.exists():
            target_link.unlink()

        # check all version directory and select the latest one
        # versions : absolute directories list in cur_dir
        versions = [d for d in cur_dir.iterdir() if d.is_dir() and d.name != "current"]
        if not versions:
            continue

        latest_version = sorted(versions)[-1]

        try:
            # make symbolic directory link "current" for latest version
            # symbolic is relative path from target_link when argument is given as relative path
            target_link.symlink_to(latest_version.name, target_is_directory=True)
            console.print(f"Linked for [green]{cur_dir.name}[/] : {latest_version.name} -> {target_link}")
        except OSError as e:
            console.print(f"[red]Failed[/]: {cur_dir.name} {e}")
            return

# ══════════════════════════════════════════════════════════════
#  main loop
# ══════════════════════════════════════════════════════════════

def backup(new_user: str):

    # make subdirectory under destination
    # parents : if DEST_DIR is not existed, make it.
    # exist_ok : If target sub_dir is existed, don't occur error.
    (DST_DIR / "apps").mkdir(parents=True, exist_ok=True)
    (DST_DIR / "shims").mkdir(parents=True, exist_ok=True)
    (DST_DIR / "persist").mkdir(parents=True, exist_ok=True)

    # colored : [colorname] ~ [/]
    console.print(
        f"[bold cyan]Source:[/]         {SRC_DIR}\n" +
        f"[bold cyan]Destination:[/]    {DST_DIR}\n" +
        f"[bold cyan]Apps:[/]           {len(APPS)}\n" +
        f"[bold cyan]Threads:[/]        {PY_THREADS}\n" +
        f"[bold cyan]Robocopy /MT:[/]   {ROBO_THREADS}\n"
    )

    start = time.perf_counter()

    completed_apps = 0 # Counter of completed apps (for description updates)
    results = []       # Collect final results

    with concurrent.futures.ThreadPoolExecutor(max_workers=PY_THREADS) as ex:
        # dictionary comprehension
        # dict : {future obj : app name}
        # futures must be iterative structure : list / dict{key} / tuple for as_completed
        futures = { ex.submit(copy_app, app): app for app in APPS }

        # if each jobs are completed
        for future in concurrent.futures.as_completed(futures):
            r = future.result()
            results.append(r)
            completed_apps += 1

            console.print(f"[yellow]{completed_apps}/{len(APPS)}[/] : {futures[future]} is completly copied")

    # edit username of path in file contents
    modify_username(DST_DIR, new_user)

    # result
    elapsed = time.perf_counter() - start
    console.print(f"[bold green]completed:[/] {elapsed:.1f}s")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    # add sub parser to distinguish command mode
    subparsers = parser.add_subparsers(dest="command", required=True)

    # 1) command = 'backup' mode,   add arguments for this mode
    parser_backup = subparsers.add_parser('backup', help="copy specific scoop apps for backup and modify username")
    parser_backup.add_argument('--new-user', required=True, type=str, help='target user name to be changed')

    # 2) command = 'create_symlink' mode, without argument
    _ = subparsers.add_parser('create_symlink', help="create symbolic link to each apps")

    # get arguments
    args = parser.parse_args()

    # branching by command
    command:str = cast(str, args.command)
    if command == 'backup':
        new_user:str = cast(str, args.new_user)
        backup(new_user)
    elif command == 'create_symlink':
        create_symlink()


