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
          
          ;~ If (OurDmg > 0) {
               
               ;~ LogTip := % "[" Action "] " OurDmg " / " TheirDmg "`n" LogTip
               ;~ StringLeft, LogTip, LogTip, 600
               
               ;~ ToolTip, %LogTip%, wLeft + wWidth, wTop, 10
          ;~ }
          
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
     
}
