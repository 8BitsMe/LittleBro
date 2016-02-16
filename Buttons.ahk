ClickB(Why, timeout := 10){
     WaitFoRButton(1, Why, 0.300, 0.825, 0.466, 0.922, 0x549060, timeout)
}

ClickC(Why, timeout := 10){
     WaitFoRButton(1, Why, 0.760, 0.825, 0.926, 0.922, 0x549060, timeout)
}

ClickMatch(Why, timeout := 10){
     WaitFoRButton(1, Why, 0.006, 0.876, 0.200, 0.972, 0x075009, timeout)
}

ClickContinue(Why, timeout := 10){
     WaitFoRButton(1, Why, 0.826, 0.895, 0.992, 0.992, 0x075009, timeout)
}

ClickAccept(Why, timeout := 10){
     WaitFoRButton(1, Why, 0.790, 0.895, 0.955, 0.992, 0x075009, timeout)
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; UNIVERSAL BUTTON WAIT FUNCTION, DATA IN SAME FORMAT AS F10 SCAN
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForButton(Click, Why, L, T, R, B, Color, TimeOut := 0) {
     global
     Z = 0

     L := wLeft + wWidth * L
     T := wTop + wHeight * T
     R := wLeft + wWidth * R
     B := wTop + wHeight * B

     Skip := false
     MouseMove, X, Y
     
     DrawRect(L,T,R,B,"FFFF00")
     
     PixelSearch, Px, Py, L, T, R, B, Color, 30, Fast
     While (ErrorLevel > 0 && !Skip)	{
          Sleep, 1000
          PixelSearch, Px, Py, L, T, R, B, Color, 30, Fast

          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`n(Press F9 to skip) : " Z++ , ToolTipX, ToolTipY, 1

          If (Timeout > 0 && Z > Timeout) OR (Z > 100)
          Skip := True
     }

     PixelSearch, Px, Py, L, T, R, B, Color, 30, Fast
     
     ; TRY TO CLICK IT UNTIL IT FINALLY GIVES IN
     While (ErrorLevel < 1 && Click && !Skip) {
          MouseClick, left, Px, Py
          Sleep, 100
          ToolTip, Tap!, Px+12, Py+24, 2
          PixelSearch, Px, Py, L, T, R, B, Color, 30, Fast
     }
     
}