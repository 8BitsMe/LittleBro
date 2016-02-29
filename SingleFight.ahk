SingleFight() {
     global
     
     ; Get rid of things obscuring our window
     NagKiller()
     
     ; PRE-BATTLE SETUP
     Cycles = 0
     Strategy = Waiting
     
     Action = 1
     DoActions = 1
     SameColors = 0
     
     HMin = 0
     HMax = 8
     HCount = 0
     HAvg = 2
     
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
     
     HideRect()
     
     ; o=-=-=-=-=-=o
     ;   MAIN LOOP
     ; o=-=-=-=-=-=o
     
     While (DoActions = 1) {
          
          Actions()
          
          BattleScan()
          
          ShowOSD("Action: " Action "`n[" Strategy "]`nC: " Cycles " @ " CycleTime "(" AvgCycle ") T: " CycleSec " D:" DynaRatio)
          
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
     
}