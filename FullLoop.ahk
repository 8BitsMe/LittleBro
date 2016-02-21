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
				  ClickB("WarCC")
;			  Loop, 60{
;				Px = 0
;				  ;NORMAL CC LOCATION
;				  WaitForButton(0, "First 3v3 versus match Button...", 0.46, 0.850,0.47,0.87, 0X024B04,1)
;				  if (Px > 0 ) {
;					  WaitFoRButton(1, "First 3v3 versus match Button...", 0.46, 0.850, 0.47,0.87, 0X024B04,1)
;					  break
;				  }
;
;				  ; WAR-B LOCATION OF CC
;		      	  WaitFoRButton(0, "First 3v3 versus match Button...", 0.32, 0.850, 0.33,0.87, 0X024B04,1)
;				  if (Px > 0 ) {
;			      	  WaitFoRButton(1, "First 3v3 versus match Button...", 0.32, 0.850, 0.33,0.87, 0X024B04,1)
;					  break
;				  }
;				 Sleep, 500
;			  }
          }

          If (WhichWar = "WAR-B") {
               winStreak := GetOCRArea(0.49, 0.347, 0.54, 0.39, "numeric")
               WaitFoRButton(1, "First 3v3 versus match Button...", 0.3, 0.83, 0.46, 0.93, 0X024B04)
          }

          If (WhichWar = "WAR-C") {
               winStreak := GetOCRArea(0.95, 0.348, 1.0, 0.398, "numeric")
               WaitFoRButton(1, "Second 3v3 versus match Button...", 0.76, 0.83, 0.92,0.93, 0X024B04)
          }

          If (WhichWar = "WAR-Y") {

               Loop, 4 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 15
                    Sleep, 1000
               }

               WaitForNoChange(0.5,0.75,"Stopped dragging...")

	       winStreak := GetOCRArea(0.320, 0.345, 0.370, 0.393, "numeric")

               WaitFoRButton(1, "Last versus match Button...", 0.18, 0.850, 0.20, 0.87, 0X024B04)
          }

          If (WhichWar = "WAR-Z") {

               Loop, 4 {
                    MouseClickDrag, left, MidX + wWidth * 0.4, wTop + wHeight * 0.5 , MidX - wWidth*0.2, wTop + wHeight * 0.5, 15
                    Sleep, 1000
               }

               WaitForNoChange(0.5,0.75,"Stopped dragging...")

	       winStreak := GetOCRArea(0.769, 0.345, 0.836, 0.393, "numeric")

               WaitFoRButton(1, "Last versus match Button...", 0.6, 0.850, 0.62, 0.87, 0X024B04)
          }

;          WaitForChange(0.5,0.75,"Picked 3v3 ARENA...", 60)

          ; =-= FIX POSSIBLE STALL HERE =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;          PixelGetColor, aColor, (wLeft + wWidth * 0.8),(wTop + wHeight * 0.6)
;          PixelGetColor, bColor, (wLeft + wWidth * 0.2),(wTop + wHeight * 0.6)
;          If (aColor = 0x302C2B) && (bColor = 0x302C2B) {
;               MouseClick, left, ContinueButtonX, ContinueButtonY, 5
;               WaitForChange(0.5,0.75,"FIXING STALL...", 60)
;               Continue
;          }
          ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

          WaitForNoChange(0.5,0.75,"EDIT TEAM")

          BattleCycle( WhichWar, winStreak )

          If (LoopLimit > 0 && OuterLoop >= LoopLimit)
	          Break

     }

     ;~ WinClose, BlueStacks

     ;~ ToolTip, Done %OuterLoop% loops, Closed window @ A_Hour A_Min

}
