import argparse
import subprocess
from pathlib import Path
from typing import cast

from rich.console import Console

console = Console()

def modify_username(dest: Path, new_user: str):
    """
    modify user name of path in file contents

    Parameters
    ----------
    app      : str       The name of app

    """

    console.print("\n==== Start modifying path ====\n")

    # if you want to use f"", use \\\\ instead of \\
    # rg is slow at first try, because there is no OS cache.
    result = subprocess.run(
        ["rg", '-l', r"[Cc]:[\\/]+Users[\\/]+USER[\\/]+", str(dest)],
        capture_output=True,
        text=True,
        encoding="utf-8",
    )

    # make list using splitlines()
    files = [Path(line.strip()) for line in result.stdout.splitlines() if line.strip()]

    if not files:
        console.print("There are no result to modify path contents")
        return False

    console.print(result.stdout)
    console.print(f"Detected {len(files)} files whose paths were modified in file contents")

    # separate files by chunk for windows
    # maximum length of path = 260
    # maximum length of command in subprocess = 32,767
    # maximum number of path in subprocess = 32,767 / 260 = about 120
    batch_size = 120
    console.print(f"chunk size : {batch_size}")

    total_chunks = (len(files) + batch_size - 1) // batch_size
    for i in range(0, len(files), batch_size):
        # make chunk
        chunk = files[i:i+batch_size]

        # catch () as \1, \2, \3 to remain these slash
        # use * to unpack list
        subprocess.run(
            ["sd",
             r"([Cc]):([\\/]+)Users([\\/]+)USER([\\/])",
             f"${{1}}:${{2}}Users${{3}}{new_user}${{4}}",
             *[str(file) for file in chunk]]
        )
        console.print(f"completed for chunk {i//batch_size+1}/{total_chunks}")

    return True

# To independent operation of modify_username
def main_modify_username():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dest', required=True, type=str, help='destination directory to change username of path in file contents')
    parser.add_argument('--new-user', required=True, type=str, help='target user name to be changed')
    args = parser.parse_args()

    dest  = Path(cast(str, args.dest)).resolve() # destination path
    new_user = cast(str, args.new_user)

    modify_username(dest, new_user)


if __name__ == "__main__":
    main_modify_username()
