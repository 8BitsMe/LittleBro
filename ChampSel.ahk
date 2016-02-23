; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; HELP CHAMPIONS IN NEED, SKIP BUSY ONES, FORM A LINEUP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ChampSel() {
     global
     
     ; SET bParanoidMode = 1 IF YOU WANT TO SKIP HELP
     bParanoidMode := 0
     
     ; DISTANCE BETWEEN PORTRAITS
     HelpStepX := wWidth * 0.182
     HelpStepY := wHeight * 0.308
     
     ; INITIAL DRAG AND DROP LOCATION
     ChampDestinationX := getXCoord( 0.155 )
     ChampDestinationY := getYCoord( 0.455 )
     
     ; SIDE PANEL
     tx := ChampDestinationX - (wWidth * 0.09)
     
     ; NOT IN CHAMPION SELECTION? Looking for Gray color on left side
     PixelGetColor, gColor, tx, ChampDestinationY
     If (gColor <> 0x302C2B) {
          return -1
     }
     
     ; CLICK ON ALL GREEN HELP BADGES
     ; -----------------------------
     ; THIS IS THE VERTICAL LINE ON WHICH WE LOOK FOR THE CHAMPION PLAQUE CORNER
     
     FindChampionPlaque()
     
     BadgeX := Px - (wWidth * 0.010)
     BadgeY := Py - (wHeight * 0.144)
     
     DrawRect(BadgeX-12, BadgeY-12, BadgeX+12, BadgeY+12,"FFFF00")
     
     Loop {
          PixelSearch, Px, Py, BadgeX-12, BadgeY-12, BadgeX+12, BadgeY+12, 0x096F16, 5, Fast
          if ( ErrorLevel < 1 ) {
               MouseClick, left, Px, Py, 1
               Sleep, 2200
          }
     } Until (ErrorLevel > 0 )
     
     ; SORT CHAMPIONS ACCORDING TO STREAK AND TRY TO PRE-SCROLL TO AVOID UNNECESSARY OCR
     
     ReverseFilter := 12
     
     if (WhichWar = "WAR-B") OR (WhichWar = "WAR-C"){
          if(winStreak < ReverseFilter) {
               HeroFilter("Rating^")
               Sleep, 500
               ScrollUP()
          }
     }
     else {
          if(winStreak < ReverseFilter) {
               HeroFilter("Rating^","3*", "4*")
               Sleep, 500
               ScrollUP()
          }
     }
     
     
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
          
          ShowOSD("EDIT TEAM`nLooking for champion plaque...")
          FindChampionPlaque()
          
          ; COULDN'T FIND THE CHAMPION FRAME PIXEL, LET'S TRY TO SCROLL TO GET TO SOME FRESH CHAMPIONS
          If (ErrorLevel > 0) {
               ShowOSD("CHAMPION PORTRAIT NOT FOUND!`nAttempting to fix...")
               
               MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
               Sleep, 2000
               Goto, TopScan
               
               ; FOUND THE CHAMPION FRAME PIXEL, LET'S TRY TO ANALYZE IT
          } else {
               If (Py < (DetY + 15)) {
                    ; msgbox Should I move the screen down a little? %Py% < %DetY%
                    MouseClickDrag, left, MidX,MidY,MidX,MidY+(Scanner/2), 15
                    Goto, TopScan
               }
               
               ; SET LOCATION OF HELP OR BUSY BADGES WITH KNOWN OFFSET
               BadgeX := Px - (wWidth * 0.010)
               BadgeY := Py - (wHeight * 0.144)
               
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
                    
                    If (Repeats >= 8) or (DetY > (wTop + wHeight*0.7)) {
                         MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.34, 20
                         Sleep, 2000
                         Goto, TopScan
                    }
                    
                    DetX := BadgeX + mod(Repeats,4) * HelpStepX
                    DetY := BadgeY + Floor(Repeats/4) * HelpStepY
                    
                    DrawRect(DetX-12, DetY-12, DetX+12, DetY+12,"FFFF00")
                    
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
                         ShowOSD("EDIT TEAM`nSkipping busy champions...")
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
                              ShowOSD("EDIT TEAM`nAsking for help...")
                              MouseClick, left, Px, Py, 1
                              Sleep, 2200
                              Goto, Rescan
                         }
                         
                    }
                    
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    ; IF WE HAVE ENDED UP HERE THAT MEANS THE CURRENT POSITION HAS NO RED OR GREEN BADGE
                    ; LET'S TRY TO DRAG IT ONTO AN EMPTY SPOT
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    
                    ShowOSD("EDIT TEAM`nGetting current PI...")
                    temp1 := ((DetX - wLeft)/wWidth) + 0.014
                    temp2 := ((DetY - wTop)/wHeight) + 0.176
                    
                    currentPI := getPI(temp1, temp2, temp1 + 0.11, temp2 + 0.05, "numeric")
                    
                    If(currentPI < 100) {
                         ShowOSD("OCR GOT CONFUSED`nProbably tried to scan a face`nAttempting to fix...")
                         
                         MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
                         Sleep, 2000
                         Goto, TopScan
                    }
                    
                    ShowOSD("EDIT TEAM`nCurrent PI... " currentPI)
                    
                    If (currentPI < 100 OR currentPI > 8000) {
                         Repeats++
                         continue
                    }
                    
                    ShowOSD("EDIT TEAM`nDragging champion...`nPI: " currentPI)
                    If (WhichWar != "WAR-B") {
                         If (winStreak > 20 AND currentPI < LBStreak_Infinite_PI){
                              ShowOSD("EDIT TEAM`n2.Skipping low PI champions... " currentPI "`nGoing back to versus screen...")
                              
                              MouseClick, left, GetXCoord(0.04),GetYCoord(0.04),5
                              WaitForChange(0.5,0.75,"Switching versus arenas...",5)
                              OuterLoop += 100
                              return
                         }
                         If ((winStreak > 13 AND winStreak < 21) AND currentPI < LBStreak_13_21_PI) {
                              ShowOSD("EDIT TEAM`n1.Skipping low PI champions... " currentPI "`nWaiting for higher PI to show up...")
                              Goto, TopScan
                         }
                         If ((winStreak = 12 OR winStreak = 13) AND currentPI < 2400 ) {
                              ShowOSD("EDIT TEAM`n1.Skipping low PI champions... " currentPI "`nWaiting for higher PI to show up...")
                              Goto, TopScan
                         }
                         If (winStreak > 8 AND currentPI < LBStreak_Above_8_PI){
                              ShowOSD("EDIT TEAM`n1.Skipping low PI champions... " currentPI "`nWaiting for higher PI to show up...")
                              if ( winStreak < ReverseFilter) {
                                   MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.3, 20
                                   Sleep, 2000
                                   Goto, TopScan
                              }
                              Goto, TopScan
                         }
                    }
                    
                    If (WhichWar = "WAR-B") {
                         If (winStreak > 20 AND currentPI < 400){
                              ShowOSD("EDIT TEAM`n4.Skipping low PI champions... " currentPI "`nGoing back to versus screen...")
                              
                              MouseClick, left, GetXCoord(0.04),GetYCoord(0.04),5
                              WaitForChange(0.5,0.75,"Switching versus arenas...",5)
                              OuterLoop += 100
                              return
                         }
                         If ((winStreak > 13 AND winStreak < 21) AND currentPI < 450) {
                              ShowOSD("EDIT TEAM`n3.Skipping low PI champions... " currentPI "`nWaiting for higher PI to show up...")
                              Goto, TopScan
                         }
                         If ((winStreak = 12 OR winStreak = 13) AND currentPI < 500) {
                              ShowOSD("EDIT TEAM`n3.Skipping low PI champions... " currentPI "`nWaiting for higher PI to show up...")
                              Goto, TopScan
                         }
                    }
                    
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
     return 1
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SCROLL THE SCREEN IN ADVANCE TO SAVE SOME TIME (ALSO HELPS WITH PI A BIT)
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ScrollUp() {
     global
     A := Floor(WinStreak/2)
     Loop, %A% {
          ShowOSD("EDIT TEAM`nPre-skipping lower PI/busy champions")
          MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.3, 15
          Sleep, 1000
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FIND THE SPOT ON THE CHAMPION PLAQUE OF GRAY COLOR
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

FindChampionPlaque() {
     global
     DetX := getXCoord(0.268)
     DetY := getYCoord(0.40)
     Scanner := wHeight * 0.5
     
     DrawRect(DetX-2,DetY,DetX+2,DetY+Scanner,"FFFF00")
     
     ; FIND A PIXEL ON THE CORNER OF THE CHAMPION FRAME
     PixelSearch, Px, Py, DetX-2, DetY, DetX+2, DetY+Scanner, 0x35302D, 2, Fast
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PICK EASY MATCHES BOTTOM TO TOP, MEDIUMS TOP TO BOTTOM, HARD LEAVE AS IS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

MatchSel() {
     global
     
     ; ADJUSTED COORDINATES TO NEW, MORE EXACT RATIO SYSTEM
     ScanX := wLeft + wWidth * 0.56
     ScanA := wTop + wHeight * 0.19
     ScanB := wTop + wHeight * 0.43
     ScanC := wTop + wHeight * 0.67
     
     ShowOSD("OPPONENT SELECT`nPicking easy match with most points`nOr medium among hard ones")
     Sleep, 1000
     
     ; GREEN
     PixelSearch, Px, Py, ScanX-8, ScanC-8, ScanX+8, ScanC+8, 0x33CB33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-8, ScanB-8, ScanX+8, ScanB+8, 0x33CB33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-8, ScanA-8, ScanX+8, ScanA+8, 0x33CB33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     ; ORANGE
     PixelSearch, Px, Py, ScanX-8, ScanA-8, ScanX+8, ScanA+8, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-8, ScanB-8, ScanX+8, ScanB+8, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
}