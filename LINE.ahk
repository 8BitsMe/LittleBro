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
     If (newline = "newline")
     {
          ControlSend, , +{Enter}, LBLINE
     }
     Else
     {
          Sleep, 300
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

EndRunReport(EndReason:= "Unknown")
{
     Global
     ;3StarPoints := 10000
     ;3StarLossCount := 1
     ;3StarSeries := 1
     
     ;SetFormat Float, 0.2
     4StarWinPercentage := (1 - (4StarLossCount / (4StarSeries * 3)))*100
     4StarPointsPerMinute := (4StarPoints / 4StarRunDuration)
     
     3StarWinPercentage := (1 - (3StarLossCount / (3StarSeries * 3)))*100
     3StarPointsPerMinute := (3StarPoints / 3StarRunDuration)
     PIHMin := (SumHMinPerPI / FightCounter)
     PIHMax := (SumHMaxPerPI / FightCounter)
     PIHAvg := (SumHAvgPerPI / FightCounter)
     
     WriteToLINE("End of Run Report ( " . ReportLoop . " )","newline")
     WriteToLINE("* " . EndReason . " *", "newline")
     WriteToLINE("LBCOnlyLVL3: " . LBCOnlyLVL3, "newline")
     WriteToLINE("LBHitRatio: " . LBHitRatio, "newline")
     WriteToLINE("***********************","newline")
     IF ReportLoop in C-B,WAR-C,Z-Y,CC,WAR-Z
     {
          WriteToLINE("4* Duration: " . 4StarRunDuration . " min", "newline")
          WriteToLINE("4* Points Earned: " . ThousandsSep(4StarPoints), "newline")
          WriteToLINE("4* Points / Min: " . 4StarPointsPerMinute, "newline")
          WriteToLINE("4* Series Run: " . 4StarSeries, "newline")
          WriteToLINE("4* Total Losses: " . 4StarLossCount, "newline")
          WriteToLINE("4* Win Rate: " . 4StarWinPercentage,"newline")
          WriteToLINE("***********************","newline")
     }
     If ReportLoop in C-B,WAR-B,Z-Y,WAR-Y
     {
          WriteToLINE("3* Duration: " . 3StarRunDuration . " min", "newline")
          WriteToLINE("3* Points Earned: " . ThousandsSep(3StarPoints), "newline")
          WriteToLINE("3* Points / Min: " . 3StarPointsPerMinute, "newline")
          WriteToLINE("3* Series Run: " . 3StarSeries, "newline")
          WriteToLINE("3* Total Losses: " . 3StarLossCount, "newline")
          WriteToLINE("3* Win Rate: " . 3StarWinPercentage,"newline")
          WriteToLINE("***********************","newline")
     }
     WriteToLINE("HMin/PI: " . PIHMin,"newline")
     WriteToLINE("HMax/PI: " . PIHMax,"newline")
     WriteToLINE("Avg HAvg/PI: " . PIHAvg,"newline")
     WriteToLINE("Total Fights: " . FightCounter,"newline")
     WriteToLINE("***********************")
}


ScreenshotWindow()
{
     global
     
     ;gocrPath=gocr.exe
     
     ;take a screenshot of BlueStacks window
     ;pToken:=Gdip_Startup()
     ;pBitmap:=Gdip_BitmapFromScreen(wLeft "|" wTop "|" wWidth "|" wHeight)
     
     ;send image to clipboard
     ;Gdip_SetBitmapToClipboard(pBitmap)
     
     WinActivate, BlueStacks
     Send !{PrintScreen}
     
     ; paste image in line
     ; Sleep, 500
     WinActivate, LBLINE
     Send ^v
     Sleep, 500
     ControlSend, , {Enter}, LBLINE
     
     WinActivate, BlueStacks
     
     ;Gdip_Shutdown(pToken)
}


