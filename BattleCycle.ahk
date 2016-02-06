BattleCycle() {
     global
     
     StepA:
     
     WinActivate, BlueStacks
     
     If (OuterLoop < 9) {
          ; Tap Funnel
          MouseClick, left, (wLeft + wWidth * 0.97),(wTop + wHeight * 0.85)
          Sleep, 1000
          ; Tap sort by hero rating
          MouseClick, left, (wLeft + wWidth * 0.9),(wTop + wHeight * 0.57)
          Sleep, 1000
          ; Tap FILTER
          MouseClick, left, (wLeft + wWidth * 0.750),(wTop + wHeight * 0.855)
          Sleep, 1000
     }
     
     ChampSel()
     
     ; CLICK FIND MATCH BUTTON
     ToolTip, EDIT TEAM`nFinding match..., ToolTipX, ToolTipY, 1
     MouseClick, left, FindMatchButtonX, FindMatchButtonY,5
     
     WaitForColor(Are we in match selection?,0.4,0.3,0x302C2B,60)
     Sleep, 250
     MatchSel()
     
     ; STALLCHECK
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     If (gColor = 0x1A1917) or (gColor = 0x060606)
     Goto StepA
     
     WaitFoRButton(1,"OPPONENT SELECT`nAccepting match",0.910,0.910, 0X024B03, 60)
     
     Sleep, 1000
     
     ; STALLCHECK
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     If (gColor = 0x1A1917) or (gColor = 0x060606)
     Goto StepA
     
     WaitFoRButton(0,"SET LINEUP`nWaiting...",0.910,0.910, 0X024B03, 0)
     
     ToolTip, "SET LINEUP`nAttempting SmartSort...", ToolTipX, ToolTipY, 1
     
     SmartSort()
     
     ; STALLCHECK
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     If (gColor = 0x1A1917) or (gColor = 0x060606)
     Goto StepA
     
     WaitFoRButton(1, "LINEUP`nAccepting SmartSort...", 0.910, 0.910, 0X024B03, 60)
     
     ; STALLCHECK
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     If (gColor = 0x1A1917) or (gColor = 0x060606)
     Goto StepA
     
     ; WAIT FOR NEXT SCREEN
     WaitForNoChange(0.5,0.75,"Waiting to start battle...")
     
     ; GET CURRENT POINTS
     ;     previousPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215)
     ;     currentPoints := %previousPoints%
     
     winStreak := GetOCRArea(0.217, 0.174, 0.286, 0.215, "numeric")
     multiplier := GetOCRArea(0.383, 0.174, 0.434, 0.215)
     
     ToolTip, Points %previousPoints% To start with, ToolTipX, ToolTipY, 1
     
     ; PLAY THREE MATCHES
     Loop, 3 {
          ; TAP BEGIN BATTLE, WAIT FOR THE TRANSITION TO LOADING, THEN WAIT FOR LOADING TO END
          
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          WaitFoRButton(0, "Starting fight...", 0.910, 0.910, 0X024B03, 60)
          
          curHero := GetOCRArea(0.136, 0.457 + (.12 * (A_Index-1) ), 0.301, 0.490 + (.12 * (A_Index-1) ), "debug")
          curStars := GetOCRArea(0.136, 0.425 + (.12 * (A_Index-1) ), 0.235, 0.463 + (.12 * (A_Index-1) ), "debug")
          duped := ""
          IfInString, curStars, & 
          {
               duped := "(Unduped)"
          }
          curStars := StrLen(curStars) . "*" . duped
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          
          WaitFoRButton(1, "Starting fight...", 0.910, 0.910, 0X024B03, 60)
          
          WaitForNoChange(0.5,0.75,"Starting fight...",30)
          
          WaitForChange(0.5,0.75,"Fight started...",30)
          
          SingleFight()
          
          Sleep, 2000
          
          WaitForNoChange(0.5,0.75,"Fight finished...")
          
          ToolTip, Fight finished..., ToolTipX, ToolTipY, 1
          
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          Sleep, 500
          WaitForNoChange(0.5,0.75,"Calculating Score...")
          
          ; GET CURRENT POINTS
          fightPoints := GetOCRArea(0.440, 0.470 + (.12 * (A_Index-1) ), 0.512, 0.505 + (.12 * (A_Index-1) ), "numeric")
          currentPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215, "numeric")
          Everything := GetOCRArea(0.136, 0.425 + (.12 * (A_Index-1) ), 0.304, 0.516 + (.12 * (A_Index-1) ), "debug")
          
          msg := curHero . " , " . curStars . " , " . CycleSum/1000 . " , " . fightPoints . " , " . currentPoints . " , " . winStreak . " , " . multiplier . " , " . sucHits . " , " . hitsRec . " , " . sucCombo . " , " . highCombo . " `n " . Everything
          lbFightLog(msg)
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
     }
     
     ToolTip, Battles complete!, ToolTipX, ToolTipY, 1
     
     ; WAIT FOR STATUS SCREEN
     
     WaitFoRButton(1, "REWARDS Screen green Button...", 0.910, 0.910, 0X024B03, 10)
     
     Sleep, 2000
     
     WaitForNoChange(0.5,0.75,"Waiting for ACHIEVEMENTS...")
     
     WaitFoRButton(1, "ACHIEVEMENTS Screen green Button...", 0.910, 0.910, 0X024B03, 10)
     
     Sleep, 2000
     
     WaitForNoChange(0.5,0.75,"Are we back on VERSUS Screen?")
     
     ToolTip,
     
}
