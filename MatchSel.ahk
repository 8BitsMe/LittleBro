; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PICK EASY MATCHES BOTTOM TO TOP, MEDIUMS TOP TO BOTTOM, HARD LEAVE AS IS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

MatchSel() {
     global
     
     ScanX := wLeft + wWidth * 0.56
     ScanA := wTop + wHeight * 0.20
     ScanB := wTop + wHeight * 0.42
     ScanC := wTop + wHeight * 0.64
     
     ; GREEN
     PixelSearch, Px, Py, ScanX-4, ScanC-4, ScanX+4, ScanC+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanB-4, ScanX+4, ScanB+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanA-4, ScanX+4, ScanA+4, 0x33cc33, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     ; ORANGE
     PixelSearch, Px, Py, ScanX-4, ScanA-4, ScanX+4, ScanA+4, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
     
     PixelSearch, Px, Py, ScanX-4, ScanB-4, ScanX+4, ScanB+4, 0x0D57C6, 5, Fast
     
     If (ErrorLevel < 1) {
          MouseClick, left, Px, Py
          Sleep, 1000
          Return
     }
}