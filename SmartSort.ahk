; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SORT HEROES BASED ON THEIR CLASS, THEN TRY TO AVOID RED ARROWS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

SmartSort() {
     global
     
     ToolTip, [%OuterLoop%] SET LINEUP`nFind weaknesses..., ToolTipX, ToolTipY, 1
     
     MouseMove, OurIconsX+16, OurIconsA, 5
     FindWeaker(OurIconsX,OurIconsA,TheirIconsX,TheirIconsA)
     FindWeaker(OurIconsX,OurIconsA,TheirIconsX,TheirIconsB)
     FindWeaker(OurIconsX,OurIconsA,TheirIconsX,TheirIconsC)
     
     MouseMove, OurIconsX+16, OurIconsB, 5
     FindWeaker(OurIconsX,OurIconsB,TheirIconsX,TheirIconsA)
     FindWeaker(OurIconsX,OurIconsB,TheirIconsX,TheirIconsB)
     FindWeaker(OurIconsX,OurIconsB,TheirIconsX,TheirIconsC)
     
     MouseMove, OurIconsX+16, OurIconsC, 5
     FindWeaker(OurIconsX,OurIconsC,TheirIconsX,TheirIconsA)
     FindWeaker(OurIconsX,OurIconsC,TheirIconsX,TheirIconsB)
     FindWeaker(OurIconsX,OurIconsC,TheirIconsX,TheirIconsC)
     
     RedArrowCheck()
     RedArrowCheck()
     
}

FindWeaker(AX,AY,BX,BY) {
     
     Gap = 8
     
     ; COLORS - EACH OVERPOWERS THE ONE BELOW
     
     ; YELLOW 	- MUTANT -	0x1BC1F8
     ; RED 		- SKILL - 	0x1212EB
     ; GREEN 	- SCIENCE -	0x17AA52
     ; PURPLE	- MYSTIC -	0xC622BC
     ; CYAN 		- COSMIC - 	0xC69A00
     ; BLUE 		- TECH - 	0xD85904
     
     ; OUR ARRAY THEN BECOMES - OUR-COLOR/WEAK-TO-IT-COLOR
     
     ;              MUTANT     SKILL        SKILL       SCIENCE     SCIENCE     MYSTIC      MYSTIC      COSMIC      COSMIC      TECH        TECH        MUTANT
     ColorArray := {"0x1BC1F8": "0x1212EB", "0x1212EB": "0x17AA52", "0x17AA52": "0xC622BC", "0xC622BC": "0xC69A00", "0xC69A00": "0xD85904", "0xD85904": "0x1BC1F8"}
     
     ; GO THROUGH ALL COLORS
     For key, Color in ColorArray {
          
          ; IS THIS COLOR PRESENT ON OUR SIDE?
          PixelSearch, Sx, Sy, AX-Gap, AY-Gap, AX+Gap, AY+Gap, key, 3, Fast
          
          If (ErrorLevel < 1) {
               ; IS WEAK-TO-IT-COLOR PRESENT ON OPPOSITE SIDE?
               Sleep, 100
               PixelSearch, Dx, Dy, BX-Gap, BY-Gap, BX+Gap, BY+Gap, Color, 3, Fast
               
               If (ErrorLevel < 1) {
                    Sleep, 100
                    ; DRAG TO GET THAT GREEN ARROW
                    MouseClickDrag, left, Sx,Sy,Sx,Dy - 16, 10
                    Sleep, 500
               }
               
          }
          
     }
     
}

RedArrowCheck() {
     global
     
     GreenA = 0
     GreenB = 0
     GreenC = 0
     
     RedA = 0
     RedB = 0
     RedC = 0
     
     ; TALLY RED AND GREEN ARROWS
     MouseMove, ArrowX, ArrowA, 5
     PixelSearch, Px, Py, ArrowX-4, ArrowA-4, ArrowX+4, ArrowA+4, 0x13BB11, 3, Fast
     If (ErrorLevel < 1) {
          GreenA++
     }
     PixelSearch, Px, Py, ArrowX-4, ArrowA-4, ArrowX+4, ArrowA+4, 0x100EBA, 3, Fast
     If (ErrorLevel < 1) {
          RedA++
     }
     
     MouseMove, ArrowX, ArrowB, 5
     PixelSearch, Px, Py, ArrowX-4, ArrowB-4, ArrowX+4, ArrowB+4, 0x13BB11, 3, Fast
     If (ErrorLevel < 1) {
          GreenB++
     }
     PixelSearch, Px, Py, ArrowX-4, ArrowB-4, ArrowX+4, ArrowB+4, 0x100EBA, 3, Fast
     If (ErrorLevel < 1) {
          RedB++
     }
     
     MouseMove, ArrowX, ArrowC, 5
     PixelSearch, Px, Py, ArrowX-4, ArrowC-4, ArrowX+4, ArrowC+4, 0x13BB11, 3, Fast
     If (ErrorLevel < 1) {
          GreenC++
     }
     PixelSearch, Px, Py, ArrowX-4, ArrowC-4, ArrowX+4, ArrowC+4, 0x100EBA, 3, Fast
     If (ErrorLevel < 1) {
          RedC++
     }
     
     GreenArrows	:= (GreenA + GreenB + GreenC)
     RedArrows := (RedA + RedB + RedC)
     
     ToolTip, [%OuterLoop%] SET LINEUP`nRedCheck in Progress...`n%Z% : (%GreenA% %GreenB% %GreenC%) %GreenArrows% vs %RedArrows% (%RedA% %RedB% %RedC%), ToolTipX, ToolTipY, 1
     
     ; IF IT'S 2v1 OF REDvGREEN THEN IT'S WORTH IT AND WE DON'T EVEN BOTHER (AND ANY GREENvNO RED, OF COURSE)
     If (RedArrows >= GreenArrows) {
          
          If (RedA = 1) {
               If (GreenB = 0) {
                    MouseClickDrag, left, OurIconsX,ArrowA-32,OurIconsX,ArrowB-32, 10
                    Return
               } Else If (GreenC = 0) {
                    MouseClickDrag, left, OurIconsX,ArrowA-32,OurIconsX,ArrowC-32, 10
                    Return
               }
          }
          
          If (RedB = 1) {
               If (GreenA = 0) {
                    MouseClickDrag, left, OurIconsX,ArrowB-32,OurIconsX,ArrowA-32, 10
                    Return
               } Else If (GreenC = 0) {
                    MouseClickDrag, left, OurIconsX,ArrowB-32,OurIconsX,ArrowC-32, 10
                    Return
               }
          }
          
          If (RedC = 1) {
               If (GreenA = 0) {
                    MouseClickDrag, left, OurIconsX, ArrowC-32, OurIconsX, ArrowA-32, 10
                    Return
               } Else If (GreenB = 0) {
                    MouseClickDrag, left, OurIconsX, ArrowC-32, OurIconsX, ArrowB-32, 10
                    Return
               }
          }
     }
}
