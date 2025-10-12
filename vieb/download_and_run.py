""" Summary
take web link which indicates file like *.pdf.
Some high-class pdf viewer like okular can open this web link file inherently but much of viewer don't.
So Download the file temporally and show the file.
"""

import os
import subprocess
import sys
import tempfile  # get temp directory

import requests  # file download using http request

""" User guide
1) set 'download_path' as your vieb download path
2) set 'cmd_map' as what you want to connect (extension - execution tool) pairs
3) set shortcut in viebrc

- It downloads current page if this page's filename ends with file extension.
- At first, it find the filename in download path. If it exists, open it.
- Secondly, it downloads the page to file in system temp directory by OS
- and opens the file using related viewer from cmd_map.
- After closing the file, the file in temp folder is removed.
- If the file extension is not included in cmd_map, error occurs without download.
"""

""" About dealing errors
There are 2 way to notice error to vieb.
1) print(msg, file=sys.stderr)
2) _ = sys.stderr.write(msg)
General print() function doesn't show message in vieb.

case 1) shows the error message with big floating window. You needs to close the window using 'q'
case 2) shows the error message with small notice on the bottom right. It is gone after timeout.
Because print() add '\n' automatically. if you add '\n' in sys.stderr.write(), it makes big floating window.
"""

# set download_path
download_path:str = os.path.join(os.path.expanduser('~'), 'Desktop')
# set executable program responds to file extension
cmd_map = {
    '.pdf' : 'sioyek',
}

#####################################################
# set command argument
#####################################################
class Args:
    def __init__(self, file_url:str):
        self.file_url:str = file_url
        self.filename:str = self.get_filename()
        self.command:str = self.get_command()
        self.temp_path:str = self.get_temppath()
        self.download_path:str = self.get_downloadpath()

    def get_filename(self) -> str:
        """ Extract the file name from the URL """
        url_parts = self.file_url.split('/') # get list sliced with '/'
        filename = url_parts[-1].split('?')[0] # get last name
        return filename

    def get_command(self) -> str:
        """ set command by file extension """
        _, ext = os.path.splitext(self.filename)
        ext = ext.lower()
        if not ext:
            _ = sys.stderr.write(f"ERROR : the filename '{self.filename}' doesn't have file extension.")
            sys.exit(1)

        command = cmd_map.get(ext, '') # get cmd from map, If not, 'use start'
        if not command:
            _ = sys.stderr.write(f"ERROR : No command matched with extension '{ext}' in cmd_map" )
            sys.exit(1)

        return command

    def get_temppath(self) -> str:
        """ Create a local temporary file path, regardless of OS. """
        temp_dir = tempfile.gettempdir() # get temp dir
        temp_path = os.path.join(temp_dir, self.filename)
        return temp_path

    def get_downloadpath(self) -> str:
        """ check download path. """
        path = os.path.join(download_path, self.filename)
        return path


def main():
    if len(sys.argv) < 2:
        _ = sys.stderr.write("ERROR : There are no argument")
        sys.exit(1)

    #####################################################
    # get file class
    #####################################################
    args = Args(
        file_url = sys.argv[1],
    )

    #####################################################
    # check the file is existed already
    #####################################################
    download_file_exists = os.path.exists(args.download_path)
    temp_file_exists = os.path.exists(args.temp_path)
    if download_file_exists:
        file_path = args.download_path
    else:
        file_path = args.temp_path


    #####################################################
    # Download file as temp
    #####################################################
    temp_file_downloaded = False
    if not download_file_exists and not temp_file_exists:
        try:
            # Download files using requests
            with requests.get(args.file_url, stream=True) as res:
                res.raise_for_status() # Handle exceptions when HTTP errors (4xx, 5xx) occur

                # Save the file to a temporary path in binary write mode ('wb')
                with open(args.temp_path, "wb") as f:
                    for chunk in res.iter_content(chunk_size=8192):
                        f.write(chunk)
            temp_file_downloaded = True

        except requests.exceptions.RequestException as e:
            _ = sys.stderr.write(f"ERROR : An error occurred while downloading: {e}")
            sys.exit(1)
        except Exception as e:
            _ = sys.stderr.write(f"ERROR : An unexpected error occurred: {e}")
            sys.exit(1)

    #####################################################
    # open file
    #####################################################
    try:
        # make command to open file
        command_with_file = [args.command, file_path]

        # run cmd
        _ = subprocess.run(command_with_file)
    except FileNotFoundError:
        _ = sys.stderr.write(f"ERROR : executable '{args.command}' not found. Please check the path.")
    finally:
        # temp file is removed If viewer is closed
        if temp_file_downloaded and os.path.exists(args.temp_path):
            try:
                os.remove(args.temp_path)
            except OSError as e:
                _ = sys.stderr.write(f"ERROR: Temp file '{args.temp_path}' cannot be removed. {e}")


if __name__ == '__main__':
    main()
