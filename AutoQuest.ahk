; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AUTOQUEST? - AUTOMATION AT ITS BEST
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AutoQuest() {
     global

     ; GREEN NODE SEARCH AREA
     SearchL := wLeft + wWidth * 0.1
     SearchT := wTop + wHeight * 0.1
     SearchR := wLeft + wWidth * 0.99
     SearchB := wTop + wHeight * 0.9

     ; FIGHT BUTTON SEARCH AREA
     FightL := wLeft + wWidth * 0.82
     FightT := wTop + wHeight * 0.88
     FightR := wLeft + wWidth * 0.99
     FightB := wTop + wHeight * 0.98

     ; SKIP CUTSCENE TEXT SEARCH AREA
     SkipL := wLeft + wWidth * 0.47
     SkipT := wTop + wHeight * 0.91
     SkipR := wLeft + wWidth * 0.53
     SkipB := wTop + wHeight * 0.95

     ; CHAT CLOSE BUTTON LOCATION
     CloseX := wLeft + wWidth * 0.970
     CloseY := wTop + wHeight * 0.066

     ; QUEST COMPLETE PLAQUE
     CompleteA := wLeft + wWidth * 0.200
     CompleteB := wLeft + wWidth * 0.800
     CompleteY := wTop + wHeight * 0.275

     Z = 0
     F = 0
     CurY := SearchT

     Loop {

          Z++

          ShowOSD("AUTOQUEST™ 1.57`nDetection loop: " Z "`nFights so far: " F)

          ; IF WE SUDDENLY FIND OURSELVES FIGHTING
          InAFight()
          If (ErrorLevel < 1) {
               SingleFight()
               F++
          }

          Sleep, 50

          ; LOOK FOR A GREEN NODE TO CLICK
          DrawRect(SearchL, CurY, SearchR, SearchB, "FFFF00")

          PixelSearch, Px, Py, SearchL, CurY, SearchR, SearchB, 0x00FF00, 10, Fast
          if (ErrorLevel < 1) {
               MouseClick, L, Px, Py, 1
               ToolTip, Tap!, Px+12, Py+24, 2
               CurY := Py+8
          } else {
			CurY := SearchT
			Middle := wTop + wHeight * 0.5
			if ( Mod( Z, 3) = 0 ) {
	            MouseClick, R, SkipL, Middle, 1
				Send ^{WheelDown 10}
			}
		  }

          ; PERHAPS WE NEED TO SKIP AN ANNOYING CUTSCENE?
          DrawRect(SkipL, SkipT, SkipR, SkipB, "FFFF00")

          PixelSearch, Px, Py, SkipL, SkipT, SkipR, SkipB, 0xEEEEEE, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, L, Px, Py, 1
               ToolTip, Blah!, Px+12, Py+24, 2
          }

          Sleep, 50

          ; FIGHT BUTTON VISIBLE?
          DrawRect(FightL, FightT, FightR, FightB, "FFFF00")

          PixelSearch, Px, Py, FightL, FightT, FightR, FightB, 0x055A22, 10, Fast
          If (ErrorLevel < 1) {
               MouseClick, L, FightL, FightT

               WaitForChange(0.5, 0.75, "AUTOQUEST™ : Fight started...", 5)
               SingleFight()
               F++
          }

          Sleep, 50

          HideRect()

          ; HAVE WE OPENED THE CHAT BY ACCIDENT?
          PixelGetColor, aColor, CloseX, CloseY
          If (aColor = 0x726F6D) {
               MouseClick, L, CloseX, CloseY
               Sleep, 500
          }

          ; QUEST COMPLETE?
          PixelGetColor, aColor, CompleteA, CompleteY
          PixelGetColor, bColor, CompleteB, CompleteY
          If (aColor = 0x302C2B) && (bColor = 0x302C2B){
               LineReport("Quest Complete! :) Or out of energy... :(", "AUTOQUEST")
               ShowOSD("AUTOQUEST™ 1.57`nQuest Complete! :)`nOr out of energy... :(")
               Break
          }

     }

}

; POWERLEVEL -- This function will continually hit the first node in 3.4.5 for 456xp per energy.
PowerLevel()
{
     global
     NavigateToScreen("Fight","Story")
}