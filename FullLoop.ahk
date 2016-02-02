; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FULL BATTLELOOP OF A SINGLE VERSUS SYSTEM. POSSIBLE MULTIPLES IN THE FUTURE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

FullLoop(WhichWar,LoopLimit) {
     global
     
     OuterLoop = 0
     
     Loop {
          OuterLoop++
          
          Sleep, 1000
          
          If (WhichWar = "CC") {
               WaitFoRButton(1, "First 3v3 versus match Button...", 0.46, 0.850, 0X024B04)
          }
          
          If (WhichWar = "WAR-B") {
               WaitFoRButton(1, "First 3v3 versus match Button...", 0.32, 0.850, 0X024B04)
          }
          
          If (WhichWar = "WAR-C") {
               WaitFoRButton(1, "Second 3v3 versus match Button...", 0.77, 0.850, 0X024B04)
          }
          
          If (WhichWar = "WAR-Y") {
               
               Loop, 7 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 5
                    Sleep, 1000
               }
               
               WaitForNoChange("Stopped dragging...")
               
               WaitFoRButton(1, "Last versus match Button...", 0.14, 0.850, 0X024B04)
          }
          
          If (WhichWar = "WAR-Z") {
               
               Loop, 7 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 5
                    Sleep, 1000
               }
               
               WaitForNoChange("Stopped dragging...")
               
               WaitFoRButton(1, "Last versus match Button...", 0.6, 0.850, 0X024B04)
          }
          
          WaitForChange("Picked 3v3 ARENA...", 60)
          
          ; =-= FIX POSSIBLE STALL HERE =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          PixelGetColor, aColor, (wLeft + wWidth * 0.8),(wTop + wHeight * 0.6)
          PixelGetColor, bColor, (wLeft + wWidth * 0.2),(wTop + wHeight * 0.6)
          If (aColor = 0x302C2B) && (bColor = 0x302C2B) {
               MouseClick, left, ContinueButtonX, ContinueButtonY, 5
               WaitForChange("FIXING STALL...", 60)
               Continue
          }
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          
          WaitForNoChange("EDIT TEAM")
          
          BattleCycle()
          
          If (LoopLimit > 0 && OuterLoop >= LoopLimit)
          Break
          
     }
     
     ;~ WinClose, BlueStacks
     
     ;~ ToolTip, Done %OuterLoop% loops, Closed window @ A_Hour A_Min
     
}

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
     }
     
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
