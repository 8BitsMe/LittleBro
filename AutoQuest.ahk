; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AUTOQUEST™ - AUTOMATION AT ITS BEST
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AutoQuest() {
     global
     
     SearchLeft := wLeft + wWidth * 0.15
     SearchTop := wTop + wHeight * 0.25
     SearchRight := wLeft + wWidth * 0.85
     SearchBottom := wTop + wHeight * 0.75
     
     FightLeft := wLeft + wWidth * 0.82
     FightTop := wTop + wHeight * 0.88
     FightRight := wLeft + wWidth * 0.99
     FightBottom := wTop + wHeight * 0.98
     
     SkipX := wLeft + wWidth * 0.5
     SkipY := wTop + wHeight * 0.88
     
     PauseX := wLeft + wWidth * 0.494
     PauseY := wTop + wHeight * 0.075
     
     CloseX := wLeft + wWidth * 0.970
     CloseY := wTop + wHeight * 0.066
     ;0x726F6D
     
     CompleteA := wLeft + wWidth * 0.200
     CompleteB := wLeft + wWidth * 0.800
     CompleteY := wTop + wHeight * 0.275
     
     Z = 0
     
     Loop {
          
          Z++
          
          ToolTip, AUTOQUEST™ : Detection loop: %Z% , ToolTipX, ToolTipY, 1
          
          DrawRect(SkipX-8, SkipY-4, SkipX+8, SkipY+4,"FFFF00")
          
          ; PERHAPS WE NEED TO SKIP AN ANNOYING CUTSCENE?
          PixelSearch, Px, Py, SkipX-8, SkipY-4, SkipX+8, SkipY+4, 0xEEEEEE, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, left, Px, Py, 1
               ToolTip, Blah!, Px+12, Py+24, 2
          }
          
          DrawRect(SearchLeft, SearchTop, SearchRight, SearchBottom,"FFFF00")
          
          ; IF THE FIGHT! BUTTON IS NOT THERE LOOK FOR A GREEN NODE TO CLICK
          PixelSearch, Px, Py, SearchLeft, SearchTop, SearchRight, SearchBottom, 0x00FF00, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, left, Px, Py, 1
               ToolTip, Tap!, Px+12, Py+24, 2
          }
          
          ; HAVE WE OPENED THE CHAT BY ACCIDENT?
          PixelGetColor, aColor, CloseX, CloseY
          If (aColor = 0x726F6D) {
               MouseClick, left, CloseX, CloseY
          }
          
          ; IF WE SUDDENLY FIND OURSELVES FIGHTING
          PixelGetColor, aColor, PauseX, PauseY
          If (aColor = 0x9BBA9C) {
               SingleFight()
          }
          
          ; QUEST COMPLETE?
          PixelGetColor, aColor, CompleteA, CompleteY
          PixelGetColor, bColor, CompleteB, CompleteY
          If (aColor = 0x302C2B) && (bColor = 0x302C2B){
               Break
          }
          
          DrawRect(FightLeft,FightTop,FightRight,FightBottom,"FFFF00")
          
          ; LOOK FOR FIGHT! BUTTON AGAIN SO ERRORCODES ARE CORRECT
          PixelSearch, Px, Py, FightLeft,FightTop,FightRight,FightBottom, 0x055A22, 32, Fast
          If (ErrorLevel < 1) {
               
               MouseClick, left, FightLeft, FightTop
               
               WaitForChange(0.5,0.75,"AUTOQUEST™ : Fight started...",10)
               
               SingleFight()
               
               Z = 0
               
          }
          
          ; QUEST COMPLETE?
          PixelGetColor, aColor, CompleteA, CompleteY
          PixelGetColor, bColor, CompleteB, CompleteY
          If (aColor = 0x302C2B) && (bColor = 0x302C2B){
               ToolTip, Quest Complete!, CompleteB, CompleteY
               Break
          }
          
          Sleep, 500
     }
     
}
