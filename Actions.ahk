Actions() {
     global
     
     ; SPECIAL
     If (Action > 100) {
          SendInput, {Space}
          Return
     }
     
     ; SWIPE LEFT - Evade
     If (Action < 1) {
          SendInput, v
          Return
     }
     
     ; SWIPE RIGHT - Medium hit
     If (Action = 1) or (Action >= SwipeLimit) {
          SendInput, x
          Return
     }
     
     ; TAP - Low hit
     SendInput, z
}
