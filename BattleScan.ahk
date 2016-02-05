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
     
     ToolTip, %WeHaveASpecial%, Special1, SpecialY + 24, 2
     
     TheyHaveASpecial = 0
     
     gColor := fastPixelGetColor(TheirSpecial1, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(TheirSpecial2, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)
     gColor := fastPixelGetColor(TheirSpecial3, TheirSpecialY)
     TheyHaveASpecial += ScanSpecials(gColor)
     
     ToolTip, %TheyHaveASpecial%, TheirSpecial3, TheirSpecialY + 24, 3
     
     ; =-=-=-=-=
     ;  DAMAGE
     ; =-=-=-=-=
     
     ; UPDATE OUR HEALTH & DAMAGE
     OldOurHealth := OurHealth
     
     OurHealthX := GetOurHealth()
     OurHealth := Round(100 + ((OurHealthX - OurMaxHealth) / HealthBar) * 100, 1)
     ToolTip, %OurHealth%, OurHealthX, HealthY + 2, 4
     
     TheirDmg := Round((OldOurHealth - OurHealth),1)
     
     ; UPDATE THEIR HEALTH & DAMAGE
     OldTheirHealth := TheirHealth
     
     TheirHealthX := GetTheirHealth()
     TheirHealth := Round(100 - ((TheirHealthX - TheirMaxHealth) / HealthBar) * 100, 1)
     ToolTip, %TheirHealth%, TheirHealthX, HealthY + 2, 5
     
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
          DoActions = 0
          ToolTip, "Fight ended cleanly with result plaque", wLeft, wTop-32, 9
     }
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
     If (Color = 0x0B7700) OR ( Color = 0x0B7800 ) OR ( Color = 0x0B7A00 ) OR ( Color = 0x0C7B00 ) OR ( Color = 0x0A6E00)
     Result = 1
     ; ) OR (ANGE
     If (Color = 0x006295) OR ( Color = 0x006396 ) OR ( Color = 0x006498 ) OR ( Color = 0x006599 ) OR ( Color = 0x005B89)
     Result = 11
     ; RED
     If  ( Color = 0x000095 ) OR ( Color = 0x000098 ) OR ( Color = 0x000089)
     Result = 111
     Return Result
}