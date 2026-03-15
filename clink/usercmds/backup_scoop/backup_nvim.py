"""
backup_nvim.py
===============
A script that copies the nvim/nvim-data directories to another path
It copies necessary directories

Required external tool: rg, robocopy (built-in to Windows)
Required Python packages: rich
Run:
    If you want to move nvim dir from PC1 to PC2.

    * from PC1
    open cmd prompt
    edit SRC_DIR / DST_DIR
    executes `uv run backup_nvim.py backup --new-user <username>` : To copy nvim/nvim-data only to backup
    send these backup dirs in DST_DIR to PC2

    * from PC2
    open cmd prompt with administer mode to make symbolic link
    paste the backup dirs to SRC_DIR like home()/.config/
    executes `uv run backup_nvim.py create_symlink` : To create symbolic links for each treesitter parser in PC2
"""

import argparse
import concurrent.futures
import os
import shutil
import subprocess
import time
from pathlib import Path
from typing import cast

from rich.console import Console

from utils.modifyUser import modify_username

console = Console()  # for pretty console regardless of multi threading


# ══ settings ════════════════════════════════════════════════════════════
TEST_MODE = 0 # if 1, it is test mode, the target directory of create_symlink is destination folder

# move SRC_DIR/nvim, nvim-data to DST_DIR/nvim, nvim-data
SRC_DIR = Path.home() / ".config"
DST_DIR = Path.home() / "Desktop"
# use r"" to use '\' literally

# Recommend (PY_THREADS × ROBO_THREADS ≤ 32)
PY_THREADS   = 8  # the number of python multi threading
ROBO_THREADS = 4   # the number of thread of Robocopy

def copy_dir(src: Path, dst: Path) -> bool:
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
        robocopy <src_dir> <dst_dir> <options> : for directories
        robocopy <src_dir> <dst_dir> <filename> <options> : for files

        /E: Copy all subfolders including empty folders
        /MT:{N}: Copy files in parallel with N threads
        /R:1 /W:1: Retry once in case of failure, wait 1 second
                ( default is 1000 times/30 seconds each, which is very slow)
        /NFL /NDL /NJH /NJS: Omit log output → Improve speed
        /XD current : Copy except of this name of directory
    """

    if not src.exists():
        return False

    dst.mkdir(parents=True, exist_ok=True)

    # copy, except __pycache__ / log files
    result = subprocess.run(
        ["robocopy", str(src), str(dst),
         "/E", f"/MT:{ROBO_THREADS}", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS",
         "/XD", "__pycache__",
         "/XF", "*.log", "*.tmp"],
        capture_output=True,  # stdout/stderr capture, don't show result to terminal
    )
    return result.returncode < 8

def create_datadir_list() -> dict[Path, Path]|None:
    """
    create list to copy from nvim-data as dictionary form.
    To use multithreading, we need to slice this whole folder to sub directories

    Parameters
     ---------

    Returns
     ------
    - dict[source path, dest path] wh
    """
    tasks: dict[Path, Path] = {} # (source, destination)

    src = SRC_DIR / "nvim-data"
    dst = DST_DIR / "nvim-data"
    DEPTH1_LIST = [
        "blink",
        "blink-cmp-dat-word",
        "oklch-color-picker"
    ]
    FILES_LIST = [
        "cache/nvim/sqlite3.dll",
    ]

    if not src.exists():
        console.print("[red]Failed[/] : Could not find original path.")
        return

    # copy specific files in FILES_LIST
    console.print("\n==== Copy specific files ====\n")
    for item in FILES_LIST:
        dst_file = dst / item
        dst_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src / item, dst_file)
        console.print(f"[green]{dst_file.name}[/] is copied")

    for item in src.iterdir():
        # except files, because the most of files in nvim-data are logs
        if not item.is_dir():
            continue

        if item.name in DEPTH1_LIST: # for depth 1
            tasks[item] = dst / item.name

        elif item.name == "lazy": # for plugins
            for lazy_plugin in item.iterdir():
                if lazy_plugin.is_dir(): # except pkg-cache.lua
                    tasks[lazy_plugin] = dst / "lazy" / lazy_plugin.name

        elif item.name == "mason": # for mason packages
            for subdir in item.iterdir():
                if subdir.name == "packages": # for packages directory
                    for package in subdir.iterdir():
                        tasks[package] = dst / "mason" / subdir.name / package.name
                else: # for others
                    tasks[subdir] = dst / "mason" / subdir.name

        elif item.name == "site": # for treesitter
            for subdir in item.iterdir():
                if subdir.name == "queries": # it will be made by symbolic link
                    continue
                else: # for others
                    tasks[subdir] = dst / "site" / subdir.name
    return tasks

def backup(new_user: str):
    """
    copy nvim-data / nvim directories to DST_DIR with necessary directories
    """

    # add nvim-data/ to task list
    LIST_DATA = create_datadir_list()
    if not LIST_DATA:
        return

    # add nvim/ to task list
    nvim_dir = { SRC_DIR / "nvim" : DST_DIR / "nvim" }
    LIST = LIST_DATA | nvim_dir

    console.print(
        f"[bold cyan]Source:[/]         {SRC_DIR}\n" +
        f"[bold cyan]Destination:[/]    {DST_DIR}\n" +
        f"[bold cyan]Target Dirs:[/]    {len(LIST)}\n" +
        f"[bold cyan]Threads:[/]        {PY_THREADS}\n" +
        f"[bold cyan]Robocopy /MT:[/]   {ROBO_THREADS}\n"
    )

    start = time.perf_counter()

    completed = 0 # Counter of completed apps (for description updates)
    results = []       # Collect final results

    with concurrent.futures.ThreadPoolExecutor(max_workers=PY_THREADS) as ex:
        futures = { ex.submit(copy_dir, src, dst): src.name for src, dst in LIST.items() }

        # if each jobs are completed
        for future in concurrent.futures.as_completed(futures):
            r = future.result()
            results.append(r)
            completed += 1

            console.print(f"[yellow]{completed}/{len(LIST)}[/] : [green]{futures[future]}[/] is completly copied")

    # edit username of path in file contents
    modify_username(DST_DIR / "nvim-data", new_user)

    # result
    elapsed = time.perf_counter() - start
    console.print(f"[bold green]completed:[/] {elapsed:.1f}s")

def Reinstall_venv(dst_dir: Path) -> bool:
    # -- reinstall specific mason packages
    # because python packages have their venv and .exe file, the exe file include their python path which
    # is called by command to install.
    python_packages = [
        'basedpyright',
        'debugpy',
        'pyrefly',
        'ruff',
    ]

    mason_dir = dst_dir / "nvim-data/mason/packages"
    for package in python_packages:
        package_dir = mason_dir / package

        # remove previous venv
        if package_dir.exists():
            try:
                console.print(f"[green]{package}[/] venv is being removed ...")
                shutil.rmtree(package_dir / "venv")
            except Exception as e:
                console.print(f"Error while venv of [green]{package}[/] is removed: {e}")
                return False

        # install venv using python of current system version
        # it includes all global packages
        console.print("venv is being installed ...")
        subprocess.run(
            ["python", "-m", "venv", "--system-site-packages", "venv"],
            check=True,
            cwd=package_dir,
            stdout=subprocess.DEVNULL, # prevent stdout
        )

        # upgrade pip
        # WARN: command doesn't be affected by cwd, if you use "pip" using cwd, the "pip" of system is used instead of one of cwd.
        console.print("pip is being upgraded ...")
        venv_py_dir = package_dir / "venv" / ("Scripts/" if os.name == "nt" else "bin/")
        subprocess.run(
            [ str(venv_py_dir / "python"), "-m", "pip", "install", "--upgrade", "pip"],
            check=True,
            stdout=subprocess.DEVNULL, # prevent stdout
        )

        # install package
        console.print(f"{package} is being installed ...")
        subprocess.run(
            [ str(venv_py_dir / "python"), "-m", "pip", "install", "--ignore-installed", package],
            check=True,
            stdout=subprocess.DEVNULL, # prevent stdout
        )

    return True


def create_symlinks():
    """
    make symlinks for installed treesitter parsers
    """
    console.print("\n==== Create symbolic links for each treesitter parsers ====\n")
    data_dir = SRC_DIR if TEST_MODE == 0 else DST_DIR
    parser_dir = data_dir / "nvim-data/site/parser"

    def make_symlink(parser: Path) -> bool:
        """
        make symlink for given parser
        """
        treesitter_dir = data_dir / "nvim-data/lazy/nvim-treesitter/runtime/queries" / parser.stem
        target_link = data_dir / "nvim-data/site/queries" / parser.stem # target symbolic link

        # create parent directory of link,  if not, error invokes
        target_link.parent.mkdir(parents=True, exist_ok=True)

        # check link exists, remove if it is yes.
        if target_link.exists():
            target_link.unlink()

        try:
            # make symbolic directory link from treesitter runtime
            target_link.symlink_to(treesitter_dir, target_is_directory=True)
            console.print(f"Linked for [green]{parser.stem}[/] : {treesitter_dir.name} -> {target_link}")
            return True
        except OSError as e:
            console.print(f"[red]Failed[/]: {parser.stem} {e}")
            return False

    # for parsers
    for parser in parser_dir.iterdir():
        ok = make_symlink(parser)
        if not ok:
            return False

    # other parsers which is mismatched with site/queries
    other_parser_names = ['html_tags']
    other_dir = [Path(parser_dir / parser_name) for parser_name in other_parser_names]
    for parser in other_dir:
        ok = make_symlink(parser)
        if not ok:
            return False

    # reinstall venv of python lsp
    ok = Reinstall_venv(data_dir)
    if not ok:
        return False

    return True

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
        create_symlinks()




