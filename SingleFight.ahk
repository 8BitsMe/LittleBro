SingleFight() {
     global
     
     WinActivate, BlueStacks
     
     ; PRE-BATTLE SETUP
     Cycles = 0
     Strategy = Waiting
     
     Action = 1
     DoActions = 1
     SameColors = 0
     
     SMin = 0
     SMax = 0
     SCount = 0
     SAvg = 0
     
     TMin = 0
     TMax = 0
     TCount = 0
     TAvg = 0
     
     OurDmg = 0
     OurAvgDmg = 0
     TheirDmg = 0
     TheirAvgDmg = 0
     
     WeHaveASpecial = 0
     TheyHaveASpecial = 0
     
     OurHealth = 100
     OldOurHealth = 100
     TheirHealth = 100
     OldTheirHealth = 100
     
     CycleTime = 0
     CycleOld = A_TickCount
     CycleSum = 0
     AvgCycle = 0
     
     LogTip := ""
     
     ComboFrenzy = 0
     
     ; o=-=-=-=-=-=o
     ;   MAIN LOOP
     ; o=-=-=-=-=-=o
     
     While (DoActions = 1) {
          
          Actions()
          
          BattleScan()
          
          ToolTip, [%OmegaLoop%][%OuterLoop%] Action: %Action%`n[%Strategy%]`nC: %Cycles% @ %CycleTime% (%AvgCycle%) T: %CycleSec% D: %DynaRatio%, ToolTipX, ToolTipY, 1
          
          ToolTip, NoDmg: %NoDmg% - DamageLevel: %DamageLevel%`nHAvg: %HAvg% [HMin: %HMin% - HMax: %HMax%] [%HCount%], ToolTipX+wWidth*0.15, ToolTipY, 6
          
          StrataDev()
          
     }
     
     ; o=-=-=-=-=-=-=o
     ;   BATTLE OVER
     ; o=-=-=-=-=-=-=o
     
     ToolTip,,,,1
     ToolTip,,,,2
     ToolTip,,,,3
     ToolTip,,,,4
     ToolTip,,,,5
     ToolTip,,,,6
     
     WaitForColor(Is the plaque visible?,0.270,0.5,0x302C2B,0) ;WaitForColor(Why,X,Y,Color,Timeout)
     
     ;ReadResultsPlaque()
     
     ; WHILE THAT PLAQUE IS VISIBLE TAP THAT
     
     X := wLeft + wWidth * 0.270
     Y := wTop + wHeight * 0.5
     PixelGetColor, Color, X, Y
     
     While (Color = 0x302C2B) {
          MouseClick, left, ContinueButtonX, ContinueButtonY
          Sleep, 3000
          PixelGetColor, Color, X, Y
     }
     
     Sleep, 1000
     MouseClick, left, ContinueButtonX, ContinueButtonY
     
}

; TRY TO OCR END RESULTS FROM THE PLAQUE
ReadResultsPlaque() {
     
     shColor := fastPixelGetColor(getXCoord(0.473), getYCoord(0.473))
     If (shColor = 0x94C7C6) {
          ToolTip, "Sleepy time", wLeft, wTop-32, 9
          Sleep, 6000
     }
     
     sucHits  := GetOCRArea(0.450, 0.449, 0.491, 0.480, "numeric")
     if (sucHits > -1) {
          ; KO LOCATIONS
          ; got sucHits just above
          hitsRec := GetOCRArea(0.450, 0.483, 0.491, 0.515, "numeric")
          sucCombo := GetOCRArea(0.672, 0.449, 0.712, 0.480, "numeric")
          highCombo := GetOCRArea(0.672, 0.483, 0.712, 0.515, "numeric")
     }
     else {
          ; VICTORY LOCATIONS
          sucHits  := GetOCRArea(0.450, 0.592, 0.491, 0.622, "numeric")
          hitsRec := GetOCRArea(0.450, 0.620, 0.491, 0.650, "numeric")
          sucCombo := GetOCRArea(0.672, 0.592, 0.712, 0.622, "numeric")
          highCombo := GetOCRArea(0.672, 0.620, 0.712, 0.650, "numeric")
     }
}
