#include <windows.h>
#include <stdio.h>

int main() {
	int i;
	int opened = 0;

	// open clipboard, retry 10 times if it is failed.
	for (i=0; i < 10; i++){
		if (OpenClipboard(NULL)) {
			opened = 1;
			break;
		}
		Sleep(10); // wait 10ms
	}

	// return if clipboard opening is failed.
	if (!opened) {
		printf("ERROR");
		return -1;
	}

	//---------- check -----------------
    const char* result = "NONE";
    int exitCode = 0;

    // file list
    if (IsClipboardFormatAvailable(CF_HDROP)) { // file/dir
        result = "Files";
        exitCode = 1;
    }
	// image list
    else if (IsClipboardFormatAvailable(CF_BITMAP)  	// bitmap, screenshot
			|| IsClipboardFormatAvailable(CF_DIB)) { 	// independent bitmap for compatible
        result = "Image";
        exitCode = 2;
    }
	// text
    else if (IsClipboardFormatAvailable(CF_UNICODETEXT) // unicode text
			|| IsClipboardFormatAvailable(CF_TEXT)) { 	// ansi text
        result = "Text";
        exitCode = 3;
    }

	// print output to stdout
    printf("%s", result);
    CloseClipboard(); // close clipboard

    return exitCode;
}
