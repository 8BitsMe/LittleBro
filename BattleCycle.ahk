BattleCycle() {
     
     StepA:
     ChampSel()
     
     ; CLICK FIND MATCH BUTTON
     ToolTip, EDIT TEAM`nFinding match..., ToolTipX, ToolTipY, 1
     MouseClick, left, FindMatchButtonX, FindMatchButtonY,5
     
     WaitFoRButton(0,"OPPONENT SELECT`nPicking easy match with most points`nOr medium among hard ones",0.910,0.910, 0X024B03, 60)
     
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
     WaitForNoChange("Waiting to start battle...")
     
     ; GET CURRENT POINTS
     previousPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215)

     lblog("Starting points: " . previousPoints)

     ToolTip, Points %previousPoints% To start with, ToolTipX, ToolTipY, 1
     
     ; PLAY THREE MATCHES
     Loop, 3 {
          ; TAP BEGIN BATTLE, WAIT FOR THE TRANSITION TO LOADING, THEN WAIT FOR LOADING TO END
          
          WaitFoRButton(1, "Starting fight...", 0.910, 0.910, 0X024B03, 60)
          
          WaitForNoChange("Starting fight...",30)
          
          WaitForChange("Fight started...",30)
          
          SingleFight()
          
          Sleep, 2000
          
          WaitForNoChange("Fight finished...")
          
          ToolTip, Fight finished..., ToolTipX, ToolTipY, 1

     ; GET CURRENT POINTS
     currentPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215)
     lblog("Starting points:  " . previousPoints . ", Current points: " . currentPoints)

     }
     lblog("AFTER::: Starting points:  " . previousPoints . ", Current points: " . currentPoints)

     rPoints := currentPoints  - previousPoints
     lblog("Gained: " . rPoints . " points")
     
     ToolTip, Battles complete!, ToolTipX, ToolTipY, 1
     
     ; WAIT FOR STATUS SCREEN
     
     WaitFoRButton(1, "REWARDS Screen green Button...", 0.910, 0.910, 0X024B03, 20)
     
     Sleep, 2000
     
     WaitForNoChange("Waiting for ACHIEVEMENTS...")
     
     WaitFoRButton(1, "ACHIEVEMENTS Screen green Button...", 0.910, 0.910, 0X024B03, 20)
     
     Sleep, 2000
     
     WaitForNoChange("Are we back on VERSUS Screen?")
     
     ToolTip,
     
}
