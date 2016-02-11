; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; HELP CHAMPIONS IN NEED, SKIP BUSY ONES, FORM A LINEUP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ChampSel(WhichWar := "WAR-B", winStreak := 0) {
     global

     ;set bParanoidMode = 1 if you want to skip help
     bParanoidMode := 0
     
     ; HELP TAP LOCATION
     HelpStepX := wWidth * 0.181
     HelpStepY := wHeight * 0.281
     
     ; INITIAL DRAG AND DROP LOCATION
     ChampDestinationX := wLeft + wWidth * 0.155
     ChampDestinationY := wTop + wHeight * 0.455
     
     if (WhichWar = "WAR-B") OR (WhichWar = "WAR-C"){
;	     if(winStreak < 12)
;		     HeroFilter("Rating^")
     } else {
;	     if(winStreak < 12)
;		     HeroFilter("Rating^","3*", "4*")
;     	     else
;		     HeroFilter("3*", "4*")
     }
     
;     msgBox BOOM!
     
     TopScan:
     
     ; IS THE LAST SPOT EMPTY? (OR DARKER DUE TO MISCLICK)
     PixelGetColor, gColor, ChampDestinationX, ChampDestinationY
     
     Sleep, 250
     
     ; IF YES START ANALYSIS
     While (gColor = 0x1A1917) or (gColor = 0x060606) {
          
          ; OVERCOME MISCLICKS (DARKENED SCREEN)
          If (gColor = 0x060606) {
               MouseClick, left, ChampDestinationX, ChampDestinationY
               WaitForChange(0.5,0.75,"Fixing misClick...",5)
          }
          
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          ; ALIGN TO CHAMPION PORTRAITS AND CHECK THEM FOR NEED TO HELP OR BEING BUSY
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
          
          ; THIS IS THE VERTICAL LINE ON WHICH WE LOOK FOR THE CHAMPION PLAQUE CORNER
          DetX := wLeft + wWidth * 0.268
          DetY := wTop + wHeight * 0.40
          Scanner := wHeight * 0.5
          
          ; FIND A PIXEL ON THE CORNER OF THE CHAMPION FRAME
          PixelSearch, Px, Py, DetX-2, DetY, DetX+2, DetY+Scanner, 0x35302D, 2, Fast
          
          ; COULDN'T FIND THE CHAMPION FRAME PIXEL, LET'S TRY TO SCROLL TO GET TO SOME FRESH CHAMPIONS
          If (ErrorLevel > 0) {
               ToolTip, [%OmegaLoop%][%OuterLoop%] CHAMPION PORTRAIT NOT FOUND`nAttempting to fix..., ToolTipX, ToolTipY, 1
               
               MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
               Sleep, 2000
               Goto, TopScan
               
               ; FOUND THE CHAMPION FRAME PIXEL, LET'S TRY TO ANALYZE IT
          } else {
               
               MouseMove, Px, Py
               sleep, 2000
               ; SET LOCATION OF HELP OR BUSY BADGES WITH KNOWN OFFSET
               DefX := Px - (wWidth * 0.010)
               DefY := Py - (wHeight * 0.144)
               
               Rescan:
               
               Obstruction = 1
               Repeats = 0
               
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               ; TRY TO MOVE OVER THE CHAMPION PORTRAITS TO FIND A FREE ONE
               ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
               
               While (Obstruction <> 0) {
                    
		  ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		  ; HAVE WE MOVED OVER ALL THE SPOTS AND FOUND NO SUITABLE CHAMPIONS?
		  ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 
 		    If (Repeats >= 8) or (DetY > (wTop + wHeight*0.8)) {
		  	MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.65, 20
		  	Sleep, 2000
;			Goto, Rescan
			Goto, TopScan
		    }


                    
                    DetX := DefX + mod(Repeats,4) * HelpStepX
                    DetY := DefY + Floor(Repeats/4) * HelpStepY
                    
                    ; IF WE FIND RED SKIP IT
                    PixelSearch, Px, Py, DetX-12, DetY-12, DetX+12, DetY+12, 0x1B239C, 5, Fast
                    RedErrorLevel := ErrorLevel
                    
                    
                    ; IF WE FIND GREEN ALSO SKIP IT  *paranoid mode*
                    GreenErrorLevel := 1
                    If (bParanoidMode)
                    {
                         PixelSearch, Px, Py, DetX-12, DetY-12, DetX+12, DetY+12, 0x096F16, 5, Fast
                         GreenErrorLevel := ErrorLevel
                    }
                    
                    If (RedErrorLevel < 1 || GreenErrorLevel < 1) {
                         ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nSkipping busy champions..., ToolTipX, ToolTipY, 1
                         MouseMove, Px, Py, 1
;                         DetX += HelpStepX
                         Repeats++
                         continue
                    } Else {
                         Obstruction = 0
                    }
                    
                    If (!bParanoidMode)
                    {
                         ; IF WE FIND GREEN CLICK IT AND START ANEW (AS WE DON'T KNOW WHERE THE CHAMPION WILL GO)
                         PixelSearch, Px, Py, DetX-12, DetY-12, DetX+12, DetY+12, 0x096F16, 10, Fast
                         If (ErrorLevel < 1) {
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nAsking for help..., ToolTipX, ToolTipY, 1
                              MouseClick, left, Px, Py, 1
                              Sleep, 2000
                              Goto, Rescan
                         }
                         
                    }
                    
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    ; IF WE HAVE ENDED UP HERE THAT MEANS THE CURRENT POSITION HAS NO RED OR GREEN BADGE
                    ; LET'S TRY TO DRAG IT ONTO AN EMPTY SPOT
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    currentPI := GetOCRArea(0.270, 0.453, 0.345, 0.491)
;                    msgbox %currentPI%
                    ToolTip, [%OuterLoop%] EDIT TEAM`nDragging champion...`nPI: %currentPI%`nWinStreak: %winStreak%, ToolTipX, ToolTipY
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
          
     }
     
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PICK EASY MATCHES BOTTOM TO TOP, MEDIUMS TOP TO BOTTOM, HARD LEAVE AS IS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

MatchSel() {
     global
     
     ScanX := wLeft + wWidth * 0.56
     ScanA := wTop + wHeight * 0.20
     ScanB := wTop + wHeight * 0.42
     ScanC := wTop + wHeight * 0.64
     
     ; GREEN
     PixelSearch, Px, Py, ScanX-4, ScanC-4, ScanX+4, ScanC+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanB-4, ScanX+4, ScanB+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanA-4, ScanX+4, ScanA+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     ; ORANGE
     PixelSearch, Px, Py, ScanX-4, ScanA-4, ScanX+4, ScanA+4, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanB-4, ScanX+4, ScanB+4, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
}

