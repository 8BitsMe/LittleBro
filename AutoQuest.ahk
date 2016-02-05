; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AUTOQUEST™ - AUTOMATION AT ITS BEST
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AutoQuest() {
     global
     
     SearchLeft := wLeft + wWidth * 0.15
     SearchTop := wTop + wHeight * 0.25
     SearchRight := wLeft + wWidth * 0.85
     SearchBottom := wTop + wHeight * 0.75
     
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
     
     Loop {
          
          Z = 0
          
          ; LOOK FOR FIGHT! BUTTON
          PixelSearch, Px, Py, ContinueButtonX-4, ContinueButtonY-4, ContinueButtonX+4, ContinueButtonY+4, 0x014903, 32, Fast
          
          DrawRect(SearchLeft,SearchTop,SearchRight,SearchBottom,"FF0000")
          
          While (ErrorLevel > 0) {
               
               Z++
               
               ToolTip, AUTOQUEST™ : Detection loop: %Z% , ToolTipX, ToolTipY, 1
               
               ; PERHAPS WE NEED TO SKIP AN ANNOYING CUTSCENE?
               PixelSearch, Px, Py, SkipX-8, SkipY-4, SkipX+8, SkipY+4, 0xEEEEEE, 10, Fast
               If (ErrorLevel < 1) {
                    MouseClick, left, Px, Py, 1
                    ToolTip, Blah!, Px+12, Py+24, 2
               }
               
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
               
               ; LOOK FOR FIGHT! BUTTON AGAIN SO ERRORCODES ARE CORRECT
               PixelSearch, Px, Py, ContinueButtonX-4, ContinueButtonY-4, ContinueButtonX+4, ContinueButtonY+4, 0x014903, 32, Fast
               
               Sleep, 500
          }
          
          HideRect()
          
          ; QUEST COMPLETE?
          PixelGetColor, aColor, CompleteA, CompleteY
          PixelGetColor, bColor, CompleteB, CompleteY
          If (aColor = 0x302C2B) && (bColor = 0x302C2B){
               ToolTip, Quest Complete!, CompleteB, CompleteY
               Break
          }
          
          WaitForColor(Are we in fight screen?,0.755,0.525,0x302C2B,10) ;WaitForColor(X,Y,Color,Timeout)
          
          WaitFoRButton(1, "Entering FIGHT...", 0.835, 0.875, 0x066122)
          
          WaitForNoChange(0.5,0.75,"AUTOQUEST™ : Starting fight...",10)
          
          WaitForChange(0.5,0.75,"AUTOQUEST™ : Fight started...",10)
          
          SingleFight()
          
          WaitForChange(0.5,0.75,"AUTOQUEST™ : Looking for green node...", 10)
          
     }
     
}
