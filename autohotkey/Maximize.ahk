#Requires AutoHotkey v2.0
#SingleInstance Force ; restart previous instance If it is duplicated

!r:: ; Alt+R
{
	; get current active window state
	; 1 : max / 0 : normal / -1 : min
	currentState := WinGetMinMax("A")
	if (currentState = 1)
	{
		WinRestore("A") ; maximize -> normal/minimize
	}
	else
	{
		WinMaximize("A") ; normal/minimize -> maximize
	}
}
