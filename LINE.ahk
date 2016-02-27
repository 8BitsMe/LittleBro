;~ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;~ LINE messaging and reporting
;~ To USE:
;~ 1) Be a part of LBLINE
;~ 2) start LINE on your LB pc
;~ 3) open the LBLINE window (can be minimized)
;~ *newline* is optional, if set to "newline" it will input shift+Enter to allow
;~ for another message to be inputted in the next line
;~ TODO:
;~ 1) find a way to parse newlines in message and replace them with the right newline input.
;~ 2) when 8bits finishes his other thread script, tie into that and set LB on a schedule.
;~ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WriteToLINE(message, newline := "no")
{
     global
     
     ControlSend, , %message%, LBLINE
     Sleep, 200
     If (newline = "newline")
     {
          ControlSend, , +{Enter}, LBLINE
     }
     Else
     {
          ControlSend, , {Enter}, LBLINE
     }
}

LineReport(message:="", report:="")
{
     global
     WriteToLINE("[" LBUsername "] - " message)
}

LineAlert(message, newline:="no")
{
     global
     WriteToLINE("[" LBUsername "] *** ALERT ***", "newline")    
     WriteToLINE(message, "newline")
     If (newline != "newline") {
          WriteToLINE("[" LBUsername "] *** ALERT ***")    
     }
}

ScreenshotWindow()
{
     global
     
     gocrPath=gocr.exe
     
     ;take a screenshot of BlueStacks window
     pToken:=Gdip_Startup()
     pBitmap:=Gdip_BitmapFromScreen(wLeft "|" wTop "|" wWidth "|" wHeight)
     
     ;send image to clipboard
     Gdip_SetBitmapToClipboard(pBitmap)
     
     ; paste image in line
     Sleep, 500
     WinActivate, LBLINE
     Send ^v
     Sleep, 500
     ControlSend, , {Enter}, LBLINE
     
     WinActivate, BlueStacks
     
     Gdip_Shutdown(pToken)
}

