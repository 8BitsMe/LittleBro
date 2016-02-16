; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; HELP CHAMPIONS IN NEED, SKIP BUSY ONES, FORM A LINEUP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ChampSel(WhichWar := "WAR-B", winStreak := 0) {
     global
     
     ; SET bParanoidMode = 1 IF YOU WANT TO SKIP HELP
     bParanoidMode := 0
     
     ; DISTANCE BETWEEN PORTRAITS
     HelpStepX := wWidth * 0.181
     HelpStepY := wHeight * 0.281
     
     ; INITIAL DRAG AND DROP LOCATION
     ChampDestinationX := wLeft + wWidth * 0.155
     ChampDestinationY := wTop + wHeight * 0.455
     
     tx := ChampDestinationX - (wWidth * 0.09)
     
     PixelGetColor, gColor, tx, ChampDestinationY
     
     ; LOOKING FOR ???
     If (gColor <> 0x302C2B) {
          return -1
     }
     
     ; CLICK ON ALL GREEN HELP BADGES
     ; -----------------------------
     ; THIS IS THE VERTICAL LINE ON WHICH WE LOOK FOR THE CHAMPION PLAQUE CORNER
     
     
     
     DetX := getXCoord(0.268)
     DetY := getYCoord(0.40)
     Scanner := wHeight * 0.5
     
     ; FIND A PIXEL ON THE CORNER OF THE CHAMPION FRAME
     PixelSearch, Px, Py, DetX-2, DetY, DetX+2, DetY+Scanner, 0x35302D, 2, Fast
     
     DefX := Px - (wWidth * 0.010)
     DefY := Py - (wHeight * 0.144)
     
     Loop {
          PixelSearch, Px, Py, DefX-12, DefY-12, DefX+12, DefY+12, 0x096F16, 5, Fast
          if ( ErrorLevel < 1 ) {
               MouseClick, left, Px, Py, 1
               Sleep, 2200
          }
     } Until (ErrorLevel = 1 )
     
     ; -----------------------------
     ReverseFilter := 12
     if (WhichWar = "WAR-B") OR (WhichWar = "WAR-C"){
          if(winStreak < ReverseFilter)
               HeroFilter("Rating^")
     } else {
          if(winStreak < ReverseFilter)
               HeroFilter("Rating^","3*", "4*")
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
          
          ; THIS IS THE VERTICAL LINE ON WHICH WE LOOK FOR THE CHAMPION PLAQUE CORNER
          DetX := getXCoord(0.268)
          DetY := getYCoord(0.40)
          Scanner := wHeight * 0.5
          
          ; FIND A PIXEL ON THE CORNER OF THE CHAMPION FRAME
          PixelSearch, Px, Py, DetX-2, DetY, DetX+2, DetY+Scanner, 0x35302D, 2, Fast
          
          ; COULDN'T FIND THE CHAMPION FRAME PIXEL, LET'S TRY TO SCROLL TO GET TO SOME FRESH CHAMPIONS
          If (ErrorLevel > 0) {
               ToolTip, [%OmegaLoop%][%OuterLoop%] CHAMPION PORTRAIT NOT FOUND1`nAttempting to fix..., ToolTipX, ToolTipY, 1
               
               MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.25, 15
               Sleep, 2000
               Goto, TopScan
               
               ; FOUND THE CHAMPION FRAME PIXEL, LET'S TRY TO ANALYZE IT
          } else {
               
               ; diff := (Py - DetY)/Scanner
               ; msgbox %Py% < %DetY%  Difference %diff%
               If ( Py < ( DetY + 15 )) {
                    ; msgbox Should I move the screen down a little? %Py% < %DetY%
                    MouseClickDrag, left, MidX,MidY,MidX,MidY+(Scanner/2), 15
                    Goto, TopScan
               }
               
               ;               sleep, 1000
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
                    
                    If (Repeats >= 8) or (DetY > (wTop + wHeight*0.7)) {
                         
                         ;		    msgbox %Repeats% %DetY% > half of screen
                         MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.34, 20
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
                         ;                         sleep, 1000
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
                              Sleep, 2200
                              Goto, Rescan
                         }
                         
                    }
                    
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    ; IF WE HAVE ENDED UP HERE THAT MEANS THE CURRENT POSITION HAS NO RED OR GREEN BADGE
                    ; LET'S TRY TO DRAG IT ONTO AN EMPTY SPOT
                    ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                    
                    ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nGetting current PI..., ToolTipX, ToolTipY, 1
                    temp1 := ((DetX - wLeft)/wWidth) + 0.010
                    temp2 := ((DetY - wTop)/wHeight) + 0.171
                    
                    ;		    MouseMove, getXCoord(temp1), getYCoord(temp2)
                    
                    ;		    Sleep, 3000
                    ;		    MouseMove, getXCoord(temp1 + 0.074), getYCoord(temp2 + 0.040)
                    currentPI := getPI(temp1, temp2, temp1 + 0.10, temp2 + 0.042, "numeric")
                    ;msgbox current PI: '%currentPI%'
                    ToolTip, [%OuterLoop%] EDIT TEAM`nDragging champion...`nPI: %currentPI%`nWinStreak: %winStreak%, ToolTipX, ToolTipY
                    If (WhichWar != "WAR-B") {
                         If (winStreak > 20 AND currentPI < 1650){
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n2.Skipping low PI champions...'%currentPI%'`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              Goto, TopScan
                         }
                         If ((winStreak > 13 AND winStreak < 21) AND currentPI < 2200) {
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n1.Skipping low PI champions...%currentPI%`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              Goto, TopScan
                         }
                         If ((winStreak = 12 OR winStreak = 13) AND currentPI < 2900 ) {
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n1.Skipping low PI champions...%currentPI%`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              Goto, TopScan
                         }
                         If (winStreak > 8 AND currentPI < 1200){
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n1.Skipping low PI champions...%currentPI%`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              if ( winStreak < ReverseFilter) {
                                   MouseClickDrag, left, MidX,MidY,MidX,MidY-wHeight*0.34, 20
                                   Sleep, 2000
                                   ;			Goto, Rescan
                                   Goto, TopScan
                              }
                              Goto, TopScan
                         }
                    }
                    If (WhichWar = "WAR-B") {
                         If (winStreak > 20 AND currentPI < 400){
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n4.Skipping low PI champions...'%currentPI%'`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              Goto, TopScan
                         }
                         If ((winStreak > 13 AND winStreak < 21) AND currentPI < 450) {
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n3.Skipping low PI champions...'%currentPI%'`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
                              Goto, TopScan
                         }
                         If ((winStreak = 12 OR winStreak = 13) AND currentPI < 500) {
                              ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`n3.Skipping low PI champions...'%currentPI%'`nwaiting for higher PI to show up, ToolTipX, ToolTipY, 1
                              MouseMove, Px, Py, 1
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
; PICK EASY MATCHES BOTTOM TO TOP, MEDIUMS TOP TO BOTTOM, HARD LEAVE AS IS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
HeroScroll() {
     
     
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
     
     ToolTip, OPPONENT SELECT`nPicking easy match with most points`nOr medium among hard ones, ToolTipX, ToolTipY, 1
     ;WaitFoRButton(0,"OPPONENT SELECT`nPicking easy match with most points`nOr medium among hard ones",0.910,0.910, 0X024B03, 10)
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