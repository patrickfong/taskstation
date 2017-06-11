; Starts redmine in webapp mode and stores the 
; Window ID for activing the window later on.

global chromeWindowID
global chromeLocator := "0 - Dashboard View - Hampton Green - Task Management System ahk_class Chrome_WidgetWin_1"

RunWait taskkill /im chrome.exe /f
Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" --app-id=aldkomclnjkdfoaocfcdilclcbgllbkg
WinWait,%chromeLocator%
WinGet,chromeWindowID,ID,%chromeLocator%
WinActivate
WinMaximize

Browser_Home::
	global chromeWindowID
	IfWinExist, ahk_id %chromeWindowID%
	{
		WinActivate, ahk_id %chromeWindowID%
		WinMaximize
		SendInput, {Alt down}{Home}{Alt up}
	}
return

Launch_Media::
	; New task
	Run, "C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" --app-id=mdddbdfgcmjodfldmnnmbgfhbmjdcmcc
return
