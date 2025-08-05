import ctypes
import os

# definition for c type
UINT = ctypes.c_uint
HWND = ctypes.c_uint
WPARAM = ctypes.c_uint
LPARAM = ctypes.c_ulong
LRESULT = ctypes.c_ulong

# Load DLL
user32 = ctypes.windll.user32
imm32 = ctypes.windll.imm32

# Explicitly set arguments and return types of C functions
user32.GetForegroundWindow.restype = HWND
imm32.ImmGetDefaultIMEWnd.restype = HWND
user32.SendMessageA.restype = LRESULT
user32.SendMessageA.argtypes = [HWND, UINT, WPARAM, LPARAM]

# IME mode value
IME_MODE_KR = 1
IME_MODE_EN = 0

def set_ime_mode(mode):
    try:
        # get current window handle
        hwnd = user32.GetForegroundWindow()
        if not hwnd:
            return
        # get current IME window hanle
        ime_hwnd = imm32.ImmGetDefaultIMEWnd(hwnd)
        if not ime_hwnd:
            return

        WM_IME_CONTROL = 0x283
        IMC_SETCONVERSIONMODE = 0x002
        # set ime
        user32.SendMessageA(ime_hwnd, WM_IME_CONTROL, IMC_SETCONVERSIONMODE, mode)
    except Exception as e:
        print(f"Failed to set IME mode: {e}")


# executes this file when it run as main
if __name__ == "__main__":
    set_ime_mode(IME_MODE_EN)
