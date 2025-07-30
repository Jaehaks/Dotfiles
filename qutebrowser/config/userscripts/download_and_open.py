#!/usr/bin/env python3
import os
import platform
import subprocess
import sys
import urllib.parse


# send command to qutebrowser using QUTE_FIFO
# in this code, I will use FIFO for only message, the commands are (message-info, message-error, message_warning)
def send_qute_message(message_type, message):
    fifo_path = os.environ.get('QUTE_FIFO')
    if fifo_path:
        msg = f"{message_type} \"{message}\"\n"
        try:
            with open(fifo_path, 'w') as f:
                _ = f.write(msg)
        except Exception as e:
            print(f"Error writing to QUTE_FIFO: {e}", file=sys.stderr)

def print_help():
    help_text = """
NAME
    download_and_open.py

DESCRIPTION
    Userscript for qutebrowser to download and open selected URL in zathura or SumatraPDF.
    It automatically detects the operating system and uses the appropriate viewer.

USAGE
    Copy zathura.py to qutebrowser userscript directory and make it executable.

    Open url in viewer:
        :spawn -u zathura.py
        :hint links userscript zathura.py

REQUIREMENTS
    Linux/macOS: curl, zathura
    Windows: curl, sioyek
"""
    print(help_text)

def main():
    # If run outside the Qutebrowser environment, it will output help and then exit.
    if not os.environ.get('QUTE_FIFO'):
        print_help()
        sys.exit(0) # terminate all python script (super concept of return)

    # Get URL
    url = os.environ.get('QUTE_URL', '')
    if not url: # python consider '' as false
        send_qute_message("message-error", "There is no $QUTE_URL")
        sys.exit(1)

    # Extract file name from URL
    filename = os.path.basename(urllib.parse.urlparse(url).path)
    if not filename:
        send_qute_message("message-error", f"Could not extract filename from URL: {url}")
        sys.exit(1)
    fileextension = os.path.splitext(filename)[1].lower() # splitext will return tuple (filename_only, fileextension)

    if fileextension == '.pdf':
        # Go to the download directory
        download_dir = os.environ.get('QUTE_DOWNLOAD_DIR', '.')
        os.chdir(download_dir)

        # Download if file does not exist
        if not os.path.exists(filename):
            send_qute_message("message-info", f"[curl] Downloading {filename}...")
            try:
                # check=True : if download is failed, invoke CalledProcessError
                # _ = subprocess.run(['curl', '-o', filename, url], check=True)
                _ = subprocess.run(['cmd', '/c', 'curl', '-o', filename, url], check=True)
                send_qute_message("message-info", "[curl] Downloading completed")
            except subprocess.CalledProcessError:
                send_qute_message("message-error", f"Failed to download {url} using curl")
                sys.exit(1)
            except FileNotFoundError:
                send_qute_message("message-error", "Download tool not found. Please install curl.")
                sys.exit(1)
        else:
            send_qute_message("message-warning", f"File '{filename}' already exists")

        # Open file
        try:
            if platform.system() == 'Windows':
                _ = subprocess.Popen(['sioyek', '--new-window', filename])
            else:
                _ = subprocess.Popen(['zathura', filename])
        except FileNotFoundError:
            send_qute_message("message-error", "Viewer not found. zathura(Linux) or sioyek(Windows) in system path.")
            sys.exit(1)
    else: # if link, go to link, (not recommend because it is slower than original `hint links`)
        send_qute_message('message-error', 'Use only .pdf file')


# INFO: subprocess.run() executes command synchronously, it make the new instance of viewer has focus.
# this python code doesn't exit until the viewer instance is terminated.
# if you use subprocess.Popen(), it executes the command asynchronously and focus remains to qutebrowser.
# if there are more than one instance of viewer, focus remains to qutebrowser


# executes this file when it run as main
if __name__ == "__main__":
    main()
