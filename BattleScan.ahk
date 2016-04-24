; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BATTLESCAN HAS BEEN RETOOLED TO ONLY SCAN THINGS, NO DECISIONS AT ALL
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BattleScan() {
     global

     ; GRAB THE SCREEN INTO MEMORY - VERY FAST
     updateFastPixelGetColor()

     ; =-=-=-=-=-=
     ;  SPECIALS
     ; =-=-=-=-=-=

     WeHaveASpecial = 0

     gColor := fastPixelGetColor(Special1, SpecialY)
     WeHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(Special2, SpecialY)
     WeHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(Special3, SpecialY)
     WeHaveASpecial += ScanSpecials(gColor)

     ; ToolTip, %WeHaveASpecial%, Special1, SpecialY + 24, 2

     TheyHaveASpecial = 0

     gColor := fastPixelGetColor(TheirSpecial1, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(TheirSpecial2, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(TheirSpecial3, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)

     ; ToolTip, %TheyHaveASpecial%, TheirSpecial3, TheirSpecialY + 24, 3

     ; =-=-=-=-=
     ;  DAMAGE
     ; =-=-=-=-=

     ; UPDATE OUR HEALTH & DAMAGE
     OldOurHealth := OurHealth

     OurHealthX := GetOurHealth()
     OurHealth := Round(100 + ((OurHealthX - OurMaxHealth) / HealthBar) * 100, 1)
     ; ToolTip, %OurHealth%, OurHealthX, HealthY + 2, 4

     TheirDmg := Round((OldOurHealth - OurHealth),1)

     ; UPDATE THEIR HEALTH & DAMAGE
     OldTheirHealth := TheirHealth

     TheirHealthX := GetTheirHealth()
     TheirHealth := Round(100 - ((TheirHealthX - TheirMaxHealth) / HealthBar) * 100, 1)
     ; ToolTip, %TheirHealth%, TheirHealthX, HealthY + 2, 5

     OurDmg := Round((OldTheirHealth - TheirHealth),1)

     ; =-=-=-=-=-=-=-=-=-=-=-=-=
     ;  CHECK IF FIGHT IS OVER
     ; =-=-=-=-=-=-=-=-=-=-=-=-=

     ; MENU CORNERS VISIBLE?
     aColor := fastPixelGetColor(ChangeXA, ChangeY)
     bColor := fastPixelGetColor(ChangeXB, ChangeY)

     If (aColor = 0x302C2B) && (bColor = 0x302C2B) {
          DoActions = 0
          ToolTip, "Fight ended menu was visible", wLeft, wTop-32, 9
     }

     ; MENU CORNERS WHILE CHAMP CLICKED?
     aColor := fastPixelGetColor(ChangeXA, ChangeY)
     bColor := fastPixelGetColor(ChangeXB, ChangeY)

     If (aColor = 0x0C0B0B) && (bColor = 0x0C0B0B) {
          DoActions = 0
          ToolTip, "Fight started prematurely in champion selection", wLeft, wTop-32, 9
     }

     ; FIGHT OVER PANEL?
     aColor := fastPixelGetColor(MatchLeft, MatchY)
     bColor := fastPixelGetColor(MatchRight, MatchY)

     If (aColor = 0x302C2B) && (bColor = 0x302C2B) {
	  ; Determine Victory or Loss
 	  PixelGetColor, tColor, getXCoord(0.67), getYCoord(0.355)
          PixelGetColor, uColor, getXCoord(0.7), getYCoord(0.41)
	  If ( ( tColor != "0x302C2B" ) and ( uColor != "0x25201B" ) ) {
          	; Loss
	  	  ; Sleep, 1500
		  ; ScreenshotWindow()
          ; LineReport("Lost Fight","Arena")
	  }

		  if (LBWriteExcel != "No") {
	          ReadResultsPlaque()
		  }
       	  DoActions = 0
          ToolTip, "Fight ended cleanly with result plaque", wLeft, wTop-32, 9
     }
}

; TRY TO OCR END RESULTS FROM THE PLAQUE
ReadResultsPlaque() {
	 global
     WaitForColor("Waiting for Result Plaque",0.270,0.5,0x302C2B,5) ;WaitForColor(X,Y,Color,Timeout)

	 ; NEED TO WAIT 1.5 SECONDS FOR THE NUMBERS TO POPULATE ON THE PAGE
	 Sleep, 1500

     shColor := fastPixelGetColor(getXCoord(0.473), getYCoord(0.473))
     If (shColor = 0x94C7C6) {
          ToolTip, "Sleepy time", wLeft, wTop-32, 9
          Sleep, 6000
     }

	 highCombo := GetOCRArea(0.672, 0.652, 0.712, 0.690, "numeric")
     if (highCombo > -1) {
          ; VICTORY LOCATIONS
          sucHits  := GetOCRArea(0.450, 0.616, 0.491, 0.654, "numeric")
          hitsRec := GetOCRArea(0.450, 0.652, 0.491, 0.690, "numeric")
          sucCombo := GetOCRArea(0.672, 0.616, 0.712, 0.654, "numeric")
          ; highCombo above
     } else {
          ; KO LOCATIONS
	      sucHits  := GetOCRArea(0.450, 0.464, 0.491, 0.499, "numeric")
          hitsRec   := GetOCRArea(0.450, 0.494, 0.491, 0.534, "numeric")
          sucCombo  := GetOCRArea(0.672, 0.464, 0.712, 0.499, "numeric")
          highCombo := GetOCRArea(0.672, 0.494, 0.712, 0.534, "numeric")
     }

;     msgbox  %sucHits% %hitsRec% %sucCombo% %highCombo%
}

GetTheirHealth() {
     global

     A := TheirMaxHealth
     B := TheirMinHealth
     C := (B-A)

     Loop, 9 {
          C := C/2
          gColor := fastPixelGetColor((A+C), HealthY)
          If (BRightnessIndex(gColor) > 200) {
               B := (A+C)
          } Else {
               A := (A+C)
          }
     }
     Return A
}

GetOurHealth() {
     global

     A := OurMinHealth
     B := OurMaxHealth
     C := (B-A)

     Loop, 9 {
          C := C/2
          gColor := fastPixelGetColor((A+C), HealthY)
          If (BRightnessIndex(gColor) > 200) {
               A := (A+C)
          } Else {
               B := (A+C)
          }
     }
     Return B
}

ScanSpecials(Color) {
     Result = 0
     ; GREEN
     If (Color = 0x0C7C00) OR (Color = 0x0C7F00)
     Result = 1
     ; ORANGE
     If (Color = 0x00679B) OR (Color = 0x006599)
     Result = 11
     ; RED
     If  (Color = 0x00009E) OR (Color = 0x00009B)
     Result = 111
     Return Result
}