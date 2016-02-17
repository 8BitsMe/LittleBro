; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AUTOQUEST™ - AUTOMATION AT ITS BEST
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AutoQuest() {
     global
     
     SearchL := wLeft + wWidth * 0.15
     SearchT := wTop + wHeight * 0.15
     SearchR := wLeft + wWidth * 0.85
     SearchB := wTop + wHeight * 0.85
     
     FightL := wLeft + wWidth * 0.82
     FightT := wTop + wHeight * 0.88
     FightR := wLeft + wWidth * 0.99
     FightB := wTop + wHeight * 0.98
     
     SkipL := wLeft + wWidth * 0.47
     SkipT := wTop + wHeight * 0.91
     SkipR := wLeft + wWidth * 0.53
     SkipB := wTop + wHeight * 0.95
     
     PauseL := wLeft + wWidth * 0.485
     PauseT := wTop + wHeight * 0.025
     PauseR := wLeft + wWidth * 0.515
     PauseB := wTop + wHeight * 0.075
     
     CloseX := wLeft + wWidth * 0.970
     CloseY := wTop + wHeight * 0.066
     
     CompleteA := wLeft + wWidth * 0.200
     CompleteB := wLeft + wWidth * 0.800
     CompleteY := wTop + wHeight * 0.275
     
     Z = 0
     
     Loop {
          
          Z++
          
          ToolTip, AUTOQUEST™ : Detection loop: %Z% , ToolTipX, ToolTipY, 1
          
          ; IF WE SUDDENLY FIND OURSELVES FIGHTING
          DrawRect(PauseL, PauseT, PauseR, PauseB, "FFFF00")
          
          PixelSearch, Px, Py, PauseL, PauseT, PauseR, PauseB, 0x9BB99B, 10, Fast
          If (ErrorLevel < 1) {
               SingleFight()
          }
          
          Sleep, 200
          
          ; LOOK FOR A GREEN NODE TO CLICK
          DrawRect(SearchL, SearchT, SearchR, SearchB, "FFFF00")
          
          PixelSearch, Px, Py, SearchL, SearchT, SearchR, SearchB, 0x00FF00, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, L, Px, Py, 1
               ToolTip, Tap!, Px+12, Py+24, 2
          }
          
          Sleep, 200
          
          ; PERHAPS WE NEED TO SKIP AN ANNOYING CUTSCENE?
          DrawRect(SkipL, SkipT, SkipR, SkipB, "FFFF00")
          
          PixelSearch, Px, Py, SkipL, SkipT, SkipR, SkipB, 0xEEEEEE, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, L, Px, Py, 1
               ToolTip, Blah!, Px+12, Py+24, 2
          }
          
          Sleep, 200
          
          ; FIGHT BUTTON VISIBLE?
          DrawRect(FightL, FightT, FightR, FightB, "FFFF00")
          
          PixelSearch, Px, Py, FightL, FightT, FightR, FightB, 0x055A22, 32, Fast
          If (ErrorLevel < 1) {
               
               MouseClick, L, FightL, FightT
               
               WaitForChange(0.5, 0.75, "AUTOQUEST™ : Fight started...", 10)
               
               SingleFight()
               
               Z = 0
               
          }
          
          Sleep, 200
          
          HideRect()
          
          ; HAVE WE OPENED THE CHAT BY ACCIDENT?
          PixelGetColor, aColor, CloseX, CloseY
          If (aColor = 0x726F6D) {
               MouseClick, L, CloseX, CloseY
          }
          
          ; QUEST COMPLETE?
          PixelGetColor, aColor, CompleteA, CompleteY
          PixelGetColor, bColor, CompleteB, CompleteY
          If (aColor = 0x302C2B) && (bColor = 0x302C2B){
               ToolTip, Quest Complete!`nOr out of energy..., ToolTipX, ToolTipY, 1
               Break
          }
          
     }
     
}