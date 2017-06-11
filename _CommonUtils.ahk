; ##############################################################################
; ########## Common Functions                                         ##########
; ##############################################################################

; CTRL-ALT-SHIFT-H
;   displays the names of any HideOnMin applications
;   that are currently running but hidden
^!+h::
   ; gui window #1 reserved for hidden apps display
   Gui,1:+AlwaysOnTop -Resize -SysMenu +Owner +LabelHiddenAppsWin
   Gui,1:Margin,2,2

   ; try to find window containing title
   SetTitleMatchMode 2

   ; look in all windows including hidden
   DetectHiddenWindows On

   ; build the list
   anyFound := 0
   loop {
      ; check for end of array
      if hideOnMin%A_Index%
      {
         ; if the active window title matches hideOnMin%A_Index%
         searchFor := hideOnMin%A_Index%
         WinGet,winID,ID,%searchFor%
         if winID
         {
            ; window found, check visibility
            WinGet,winStyle,Style,ahk_id %winID%
            visible := winStyle & 0x10000000
            if (! visible)
            {
               anyFound := 1
               WinGetTitle,winTitle,ahk_id %winID%
               Gui,1:Add,Text,X2,%winTitle% ;X2 matches margin
            }
         }
      } else break ; found end of array
   }
   ; add "None" item if necessary
   if (! anyFound)
   {
      Gui,font,italic
      Gui,1:Add,Text,X2,- No Hidden Hide-On-Min Windows -
      Gui,font,norm
   }

   ; show the list
   Gui,1:Show,,Hidden Apps (Press ESC)
return

; whacks the hidden apps window when ESC is pressed
HiddenAppsWinEscape:
   Gui,1:Destroy
return

; Function:  WinWaitForMinimized
;              waits for the window winID to minimize or until timeout,
;              whichever comes first (used to delay other actions until a
;              minimize message is handled and completed)
; Parm1:     winID - ID of window to wait for minimization
; Parm2:     timeOut - optional - timeout in milliseconds to wait
WinWaitForMinimized(ByRef winID, timeOut = 1000) {
   ; wait until minimized (or timeOut)
   iterations := timeOut/10
   loop,%iterations%
   {
      WinGet,winMinMax,MinMax,ahk_id %winID%
      if (winMinMax = -1)
         break
      sleep 10
   }
}

; Function:  PlaySystemSound
;              Looks up and plays the requested system sound. The soundName
;              must match a key name in HKCU\AppEvents\Schemes\Apps\.Default
; Parm1:     SoundName - the name of the system sound to play
PlaySystemSound(soundName) {
   global playSystemSounds
   if (playSystemSounds)
   {
      RegRead,sndFile,HKEY_CURRENT_USER,AppEvents\Schemes\Apps\.Default\%soundName%\.Current
      ; check for absolute path to sound file
      ifInString,sndFile,\
         SoundPlay,%sndFile%,WAIT
      else
         ; no absolute path, go to Windows' standard sound location
         SoundPlay,%A_WinDir%\Media\%sndFile%,WAIT
   }
}

; Function:  AppStartShowHide
;              starts an app if not running, hides the app if it is active,
;              brings it forward (activates) if shown but not active, and
;              shows and activates the app if it is hidden
; Parm1:     winTitle - title of window to look for
; Parm2:     runCmd - command to start app if not found
AppStartShowHide(winTitle, runCmd) {
   ; try to find window containing title
   SetTitleMatchMode 2
   ; look in all windows including hidden
   DetectHiddenWindows On

   WinGet,winID,ID,%winTitle%
   if winID
   {
      ; window found, check visibility
      WinGet,winStyle,Style,ahk_id %winID%
      visible := winStyle & 0x10000000
      if visible
      {
         ifWinNotActive,ahk_id %winID%
            ; visible but not active, bring it forward
            WinActivate,ahk_id %winID%
         else {
            ; visible and active, hide it
            WinMinimize,ahk_id %winID%
            WinWaitForMinimized(winID)
            WinHide,ahk_id %winID%
            PlaySystemSound("Minimize")
         }
      } else {
         ; not visible, activate it
         WinShow,ahk_id %winID%
         WinRestore,ahk_id %winID%
         WinActivate,ahk_id %winID%
         PlaySystemSound("RestoreUp")
      }
   } else
      ; never found window in the first place, so start it
      Run,%runCmd%
}

; Function:  AppStartRestore
;              starts an app if not running, activates the app if running
;              (useful for apps that have built-in hiding and/or min-to-tray)
; Parm1:     winTitle - title of window to look for
; Parm2:     runCmd - command to start app if not found
AppStartRestore(winTitle, runCmd) {
   ; try to find window containing title
   SetTitleMatchMode 2
   ; look in all windows including hidden
   DetectHiddenWindows On

   WinGet,winID,ID,%winTitle%
   if winID
   {
      ; window found, restore
      WinRestore,ahk_id %winID%
      WinActivate,ahk_id %winID%
      PlaySystemSound("RestoreUp")
   } else
      ; didn't find window, so start it
      Run,%runCmd%
}

; Function:  AppStartActivate
;              starts an app if not running, activates the app if running
;              (useful for apps that have built-in hiding and/or min-to-tray)
; Parm1:     winTitle - title of window to look for
; Parm2:     runCmd - command to start app if not found
AppStartActivate(winTitle, runCmd) {
   ; try to find window containing title
   SetTitleMatchMode 2
   ; look in all windows including hidden
   DetectHiddenWindows On

   WinGet,winID,ID,%winTitle%
   if winID
   {
      ; window found, restore
      WinActivate,ahk_id %winID%
      PlaySystemSound("RestoreUp")
   } else
      ; didn't find window, so start it
      Run,%runCmd%
}


; Function:  AppStartMaximize
;              starts an app if not running, activates the app if running
;              (useful for apps that have built-in hiding and/or min-to-tray)
; Parm1:     winTitle - title of window to look for
; Parm2:     runCmd - command to start app if not found
AppStartMaximize(winTitle, runCmd) {
   ; try to find window containing title
   SetTitleMatchMode 2
   ; look in all windows including hidden
   DetectHiddenWindows On

   WinGet,winID,ID,%winTitle%
   if winID
   {
      ; window found, restore
      WinMaximize,ahk_id %winID%
      WinActivate,ahk_id %winID%
      PlaySystemSound("RestoreUp")
   } else
      ; didn't find window, so start it
      Run,%runCmd%
}

; Function:  AppStartShowHide
;              starts an app if not running, hides the app if it is active,
;              brings it forward (activates) if shown but not active, and
;              shows and activates the app if it is hidden
; Parm1:     winTitle - title of window to look for
; Parm2:     runCmd - command to start app if not found
AppHide(winTitle) {
   ; try to find window containing title
   SetTitleMatchMode 2
   ; look in all windows including hidden
   DetectHiddenWindows On

   WinGet,winID,ID,%winTitle%
   if winID
   {
      ; window found, check visibility
      WinGet,winStyle,Style,ahk_id %winID%
      visible := winStyle & 0x10000000
      if visible
      {
         ifWinActive,ahk_id %winID%
         {
            ; visible and active, hide it
            WinMinimize,ahk_id %winID%
            WinWaitForMinimized(winID)
            WinHide,ahk_id %winID%
            PlaySystemSound("Minimize")
         }
      }
   }
}