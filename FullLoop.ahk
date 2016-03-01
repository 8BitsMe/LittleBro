; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; FULL BATTLELOOP OF A SINGLE VERSUS SYSTEM. POSSIBLE MULTIPLES IN THE FUTURE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

FullLoop() {
     global

     OuterLoop = 0

     Loop {
          OuterLoop++

          Sleep, 1000

          If (WhichWar = "CC") {
				; IS THERE A GAP BETWEEN PANELS?
               PixelGetColor, PColor, GetXCoord(0.260), GetYCoord(0.222)
               If (PColor != 0x312E2C) {
                    ; WAR-B LOCATION OF CC
                    WaitFoRButton(0, "CC versus match Button...", 0.3, 0.83, 0.47, 0.93, 0X024B04,1)
                    winStreak := GetOCRArea(0.49, 0.347, 0.54, 0.39, "numeric")
                    ClickB("WarCC")
               } else {
                    ;NORMAL CC LOCATION
                    WaitForButton(0, "CC versus match Button...", 0.442, 0.825, 0.610, 0.922, 0x549060,1)
                    winStreak := GetOCRArea(0.635, 0.347, 0.685, 0.39, "numeric")
                    ClickCC1("First 3v3 versus match Button...")
               }
          }

          If (WhichWar = "WAR-B") {
               winStreak := GetOCRArea(0.49, 0.347, 0.54, 0.39, "numeric")
               ClickB("WAR-B")
          }

          If (WhichWar = "WAR-C") {
               winStreak := GetOCRArea(0.95, 0.348, 1.0, 0.398, "numeric")
               ClickC("WAR-C")
          }

          If (WhichWar = "WAR-Y") {

               Loop, 3 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 15
                    Sleep, 1000
               }

               WaitForNoChange(0.5,0.75,"Stopped dragging...")

               winStreak := GetOCRArea(0.320, 0.345, 0.370, 0.393, "numeric")

               ClickY("WAR-Y")
          }

          If (WhichWar = "WAR-Z") {

               Loop, 2 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 15
                    Sleep, 1000
               }

               WaitForNoChange(0.5,0.75,"Stopped dragging...")

               winStreak := GetOCRArea(0.769, 0.345, 0.836, 0.393, "numeric")

               ClickZ("WAR-Z")
          }

          WaitForNoChange(0.5,0.75,"EDIT TEAM")

          BattleCycle()

          If (LoopLimit > 0 && OuterLoop >= LoopLimit)
          Break

     }

}