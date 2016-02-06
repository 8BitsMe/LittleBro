; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; HELP CHAMPIONS IN NEED, SKIP BUSY ONES, FORM A LINEUP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ChampSel() {
     global
     
     ;set bParanoidMode = 1 if you want to skip help
     bParanoidMode := 0
     
     ; HELP TAP LOCATION
     HelpStepX := wWidth * 0.180
     HelpStepY := wHeight * 0.282
     
     ; HELP BADGE AREA
     bLeft := wLeft + wWidth * 0.240
     bTop := wTop + wHeight * 0.200
     bRight := wLeft + wWidth * 0.90
     bBottom := wTop + wHeight * 0.900
     
     ; INITIAL DRAG AND DROP LOCATION
     ChampDestinationX := wLeft + wWidth * 0.155
     ChampDestinationY := wTop + wHeight * 0.455
     
     TopScan:
     
     DrawRect(ChampDestinationX-4,ChampDestinationY-4,ChampDestinationX+4,ChampDestinationY+4,"FFFF00")
     
     ; IS THE LAST SPOT EMPTY? (OR DARKER DUE TO MISCLICK)
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     
     Sleep, 250
     
     ; IF YES START ANALYSIS
     While (gColor = 0x1A1917) or (gColor = 0x060606) {
          
          ; OVERCOME MISCLICKS (DARKENED SCREEN)
          If (gColor = 0x060606) {
               MouseClick, left, ChampDestinationX, ChampDestinationY
               WaitForChange(0.5,0.75,"Fixing misClick...",5)
               MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
               Sleep, 2000
          }
          
          DrawRect(bLeft,bTop,bRight,bBottom,"FFFF00")
          
          If (bParanoidMode = 0) {
               ; ANY HELP BADGES PRESENT?
               PixelSearch, Px, Py, bLeft, bTop, bRight, bBottom, 0x049759, 2, Fast
               
               While (ErrorLevel < 1) {
                    
                    MouseClick, left, Px, Py, 1
                    Sleep, 2000
                    PixelSearch, Px, Py, bLeft, bTop, bRight, bBottom, 0x049759, 2, Fast
               }
               
          }
          
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          ; ALIGN TO CHAMPION PORTRAITS AND CHECK THEM FOR NEED TO HELP OR BEING BUSY
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          
          ; THIS IS THE VERTICAL LINE ON WHICH WE LOOK FOR THE CHAMPION PLAQUE CORNER
          DetX := wLeft + wWidth * 0.272
          DetY := wTop + wHeight * 0.4
          Scanner := wHeight * 0.5
          
          DrawRect(DetX-2,DetY,DetX+2,DetY+Scanner,"FFFF00")
          
          ; FIND A PIXEL ON THE CORNER OF THE CHAMPION FRAME
          PixelSearch, Px, Py, DetX-2, DetY, DetX+2, DetY+Scanner, 0x4D4640, 2, Fast
          
          DrawRect(Px-2, Py-2, Px+2, Py+2,"FFFF00")
          
          ; COULDN'T FIND THE CHAMPION FRAME PIXEL, LET'S TRY TO SCROLL TO GET TO SOME FRESH CHAMPIONS
          If (ErrorLevel > 0) {
               ToolTip, [%OmegaLoop%][%OuterLoop%] CHAMPION PORTRAIT NOT FOUND`nAttempting to fix..., ToolTipX, ToolTipY, 1
               
               MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
               Sleep, 2000
               Goto, TopScan
               
               ; FOUND THE CHAMPION FRAME PIXEL, LET'S TRY TO ANALYZE IT
          } else {
               ; SET LOCATION OF HELP OR BUSY BADGES WITH KNOWN OFFSET
               DefX := Px
               DefY := Py - (wHeight * 0.13)
               
               Rescan:
               
               Obstruction = 1
               Repeats = 0
               
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               ; TRY TO MOVE OVER THE CHAMPION PORTRAITS TO FIND A FREE ONE
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               
               While (Obstruction > 0) && (Repeats < 8) {
                    
                    Obstruction = 0
                    FoundRed = 0
                    FoundGreen = 0
                    
                    DetX := DefX + mod(Repeats,4) * HelpStepX
                    DetY := DefY + Floor(Repeats/4) * HelpStepY
                    
                    DrawRect(DetX-2, DetY-2, DetX+2, DetY+2,"FF0000")
                    
                    ; IF WE FIND RED SKIP IT
                    PixelSearch, Px, Py, DetX-12, DetY-12, DetX+12, DetY+12, 0x1B239B, 5, Fast
                    FoundRed := ErrorLevel
                    
                    ; IF WE FIND GREEN ALSO SKIP IT  *paranoid mode*
                    PixelSearch, Px, Py, DetX-12, DetY-12, DetX+12, DetY+12, 0x049759, 5, Fast
                    FoundGreen := ErrorLevel
                    
                    If (FoundRed = 0) {
                         DrawRect(DetX, DetY, DetX+HelpStepX, DetY+HelpStepY,"FF0000")
                         ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nSkipping busy champions..., ToolTipX, ToolTipY, 1
                         DetX += HelpStepX
                         Repeats++
                         Obstruction++
                    }
                    
                    If (FoundGreen = 0) {
                         DrawRect(DetX, DetY, DetX+HelpStepX, DetY+HelpStepY,"00FF00")
                         ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nSkipping busy champions..., ToolTipX, ToolTipY, 1
                         DetX += HelpStepX
                         Repeats++
                         Obstruction++
                    }
                    
               }
               
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               ; HAVE WE MOVED OVER ALL THE SPOTS AND FOUND NO SUITABLE CHAMPIONS?
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               
               If (Repeats >= 8) or (DetY > (wTop + wHeight*0.8)) {
                    MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
                    Sleep, 2000
                    Goto, TopScan
               }
               
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               ; IF WE HAVE ENDED UP HERE THAT MEANS THE CURRENT POSITION HAS NO RED OR GREEN BADGE
               ; LET'S TRY TO DRAG IT ONTO AN EMPTY SPOT
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               
               currentPI := GetOCRArea(0.270, 0.453, 0.345, 0.491)
               ToolTip, [%OuterLoop%] EDIT TEAM`nDragging champion...`nPI: %currentPI%`nWinStreak: %winStreak%, ToolTipX, ToolTipY, 1
               ; SHIFT CHAMP PORTRAIT DRAG POINT NEXT TO LAST DETECTED SPOT
               ChampPortraitX := DetX + wWidth * 0.08
               ChampPortraitY := DetY + wHeight * 0.08
               
               MouseMove, ChampPortraitX,ChampPortraitY, 1
               
               MouseClickDrag, left, ChampPortraitX,ChampPortraitY,ChampDestinationX,ChampDestinationY, 15
               
               Sleep, 1000
          }
          
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          ; IS THE LAST SPOT STILL EMPTY?
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     }
     
     HideRect()
     
}