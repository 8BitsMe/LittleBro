; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; ADDS UP COLOR CHANNELS TO GET "BRIGHTNESS" - USED TO ANALYZE HEALTH BAR
; SINCE IT CHANGES COLOR OVER TIME
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BrightnessIndex(pColor) {
     vred := (pColor & 0xFF)
     vgreen := ((pColor & 0xFF00) >> 8)
     vblue := ((pColor & 0xFF0000) >> 16)
     BI := vred + vgreen + vblue
     Return BI
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; COUNTS DOWN FROM A CERTAIN NUMBER OF SECONDS, WITH EXPLANATION
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

CountDown(Why,TimeOut) {
     global
     Skip := false
     While TimeOut && !Skip {
          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`n(Press F9 to skip) : " TimeOut, ToolTipX, ToolTipY, 1
          TimeOut--
          Sleep, 1000
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WAIT FOR A CHANGE ON SCREEN
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForChange(X,Y,Why,Timeout := 0) {
     global
     X := wLeft + wWidth * X
     Y := wTop + wHeight * Y
     PixelGetColor, aColor, X, Y
     PixelGetColor, bColor, X, Y
     Z = 0
     Skip := false
     While (aColor = bColor) && !Skip {
          PixelGetColor, bColor, X, Y
          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`nWaiting for change... (Press F9 to skip)`n" aColor " - " bColor " : " Z++, ToolTipX, ToolTipY, 1
          Sleep, 1500
          If (Timeout > 0 && Z > Timeout)
          Skip := true
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WAIT FOR A STATIC SCREEN
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForNoChange(X,Y,Why,Timeout := 0) {
     global
     X := wLeft + wWidth * X
     Y := wTop + wHeight * Y
     PixelGetColor, aColor, X, Y
     bColor := 0
     Z = 0
     Skip := false
     While (aColor <> bColor) && !Skip {
          aColor := bColor
          PixelGetColor, bColor, X, Y
          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`nWaiting for no change... (Press F9 to skip)`n" aColor " - " bColor " : " Z++ , ToolTipX, ToolTipY, 1
          Sleep, 1500
          If (Timeout > 0 && Z > Timeout)
          Skip := true
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SHOWS MOUSE POSITION IN RATIO SYSTEM COORDINATES, BRIGHTNESS INDEX & COLOR
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ShowMouseRatio() {
     global
     MouseGetPos,X,Y
     RatioX := Round((X - wLeft)/wWidth,3)
     RatioY := Round((Y - wTop)/wHeight,3)

     PixelGetColor, gColor, X, Y
     B := BrightnessIndex(gColor)

     ReverseColor := SubStr(gColor, 7 , 2) . SubStr(gColor, 5 , 2) . SubStr(gColor, 3 , 2)

     X += 16

     ToolTip, %RatioX% x %RatioY% B: %B% C:%gColor% R:%ReverseColor% - W: %wWidth% - H: %wHeight%, X+21, Y

     Gui, 98: Destroy
     Gui, 98: Color, %ReverseColor%
     Gui 98: -Caption +AlwaysOnTop +ToolWindow +Border

     ; SHOW WHAT WE CREATED
     Gui, 98: Show, NoActivate x%X% y%Y% w18 h18 ;The Gui will not steal keyboard focus

}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; SHOWS YOUR SUMMONER XP AS A PERCENTAGE IF THE BAR IS VISIBLE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

XPercentage() {
     global

     A := wLeft + wWidth * 0.360
     B := wLeft + wWidth * 0.458
     BMAX := B

     Y := wTop + wHeight * 0.09

     C := (B-A)
     Sum := C

     Loop, 9 {
          C := C/2
          PixelGetColor, gColor, A+C, Y
          If (BrightnessIndex(gColor) > 300) {
               A := (A+C)
          } Else {
               B := (A+C)
          }
     }

     X := wLeft + wWidth * 0.43
     Y := wTop + wHeight * 0.059

     C := Round(100 + ((B - BMAX) / Sum) * 100, 1)
     ToolTip, %C%, X, Y
}



; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CALL OCR LIBRARY
; Top left x and y, bottom right x and y (percentages)
; Options:
;	debug
;	numeric
;	alpha
;	(others that we don't use.  Look at OCR.ahk if you want to see them)
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

GetOCRArea(tlX, tlY, brX, brY, options="") {
     global

     topLeftX := wLeft + wWidth * tlX
     topLeftY := wTop + wHeight * tlY
     widthToScan := (wLeft + wWidth * brX) - topLeftX
     heightToScan := (wTop + wHeight * brY) - topLeftY

     DrawRect(topLeftX,topLeftY,topLeftX+widthToScan,topLeftY+heightToScan,"0080FF")

     magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, options)

     ;     	ToolTip, Says: %magicalText%, Px+12, Py+24, 2
     ;Sleep, 1000

     Return SubStr(magicalText, 1,-2)
}


getPI(tlX, tlY, brX, brY, options) {

     loop, 10 {
          ToolTip, [%OmegaLoop%][%OuterLoop%] EDIT TEAM`nGetting current PI...`nLoop: %A_Index%, ToolTipX, ToolTipY, 1

          cPI := getOCRArea(tlX, tlY, brX-=.01, brY, options)
          cPI := RegExReplace(cPI, "i)[^0-9]")
          ;	msgbox PI: '%cPI%' Loop: '%A_Index%'
          if  (cPI > 200 ) AND (cPI < 9000)
               return cPI
     }
     return False
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; LOGGING -- *bOpen* is optional, if set to 1 it will open the log file (this is baked into F10 for me).
;	     *headerstyle* is also optional, the default value of 0 will just print a normal time stamp, see below for other options
;		we should set a convention for this to improve the readability of the log ... e.g. headerstyle1 for loops/main modules and headerstyle2
;		for sub-functions
;	     *Examples*: lblog("my information I want logged",0,1)
; 			 lblog("my info")
; 			 lblog("F10 pressed",1,2)
; 		         lblog("Panic button pressed",0,2)
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

lblog(info, bOpen:=0, headerstyle:=0)
{
     filename := a_scriptdir . "\LBLog.txt"
     headerstyle1 := "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
     headerstyle2 := "*******************************************"
     FormatTime, Timestamp, %A_now%, yyyy_MM_dd HH:mm:ss

     info := Timestamp . " " . info
     If (headerstyle == 1)
     {
          LogLine := headerstyle1 . "`n" . info . "`n" . headerstyle1 . "`n" . LogLine
     }
     Else If (headerstyle == 2)
     {
          LogLine := headerstyle2 . "`n" . info . "`n" . headerstyle2 . "`n" . LogLine
     }
     Else
     {
          LogLine := info . "`n" . LogLine
     }

     FileAppend, %LogLine%, %filename%

     IF (bOpen) ; I use this with F10 or you can set this to 1 when LB knows it crashed to have the log open and waiting
     {
          WinClose, LBLog.txt - Notepad ; close it if already open
          Run, Notepad.exe %filename%
     }
}

lbFightLog(info, bOpen:=0)
{
     filename := a_scriptdir . "\LBFightLog.csv"
     FormatTime, Timestamp, %A_now%, yyyy_MM_dd HH:mm:ss

     WinClose, Microsoft Excel - LBFightLog.csv ; close it if already open

     IfNotExist, %filename%
     {
          header := "Timestamp,Hero,Stars, Fight Time, Fight Points,Current Points,Streak,Multiplier,Successful Hits, Hits Recieved,Successful Combos, Highest Combo`n" . LogLine
          FileAppend, %header%, %filename%
     }

     info := Timestamp . "," . info
     LogLine := info . "`n" . LogLine

     FileAppend, %LogLine%, %filename%

     IF (bOpen) ; I use this with F10 or you can set this to 1 when LB knows it crashed to have the log open and waiting
     {
          WinClose, LBLog.txt - Notepad ; close it if already open
          Run, Notepad.exe %filename%
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; DETERMINE OFFSET X-COORDINATE FROM X PERCENT
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

getXCoord(xPercent){
     global
     return (wLeft + wWidth * xPercent)
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; DETERMINE OFFSET Y-COORDINATE FROM Y PERCENT
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

getYCoord(yPercent){
     global
     return (wTop + wHeight * yPercent)
}

ClickIfColor(ratioX, ratioY, clickColor, speed := 2)
{
     global
     bColorFound = 0
     clickX := wLeft + wWidth * ratioX
     clickY := wTop + wHeight * ratioY

     cicX := getXCoord(ratioX)
     cicY := getYCoord(ratioY)

     DrawRect(cicX-10,cicY-10,cicX+10,cicY+10,"FF00FF")

     PixelSearch, Px, Py, clickX-8, clickY-8, clickX+8, clickY+8, clickColor, 10, Fast

     If (ErrorLevel < 1)
     {
          bColorFound = 1
          MouseClick, left, clickX, clickY, 1, speed
     }

     lblog("******** ClickIfColor ==> clickX: " . clickX . " - clickY: " . clickY . " ... clickColor: " . clickColor . " -- gColor: " . gColor . " .. Return: " . bColorFound)
     return bColorFound
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WAITS FOR A SPECIFIC COLOR TO SHOW UP AT A SPECIFIC LOCATION
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForColor(Why,X,Y,Color,Timeout)
{
     global
     X := wLeft + wWidth * X
     Y := wTop + wHeight * Y
     PixelGetColor, ComColor, X, Y
     Z = 0
     Skip := false

     DrawRect(X-6,Y-6,X+6,Y+6,"00FFFF")
     PixelSearch, Px, Py, X-4, Y-4, X+4, Y+4, Color, 30, Fast
     While ErrorLevel > 0 && !Skip {
          PixelSearch, Px, Py, X-4, Y-4, X+4, Y+4, Color, 30, Fast
          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`nWaiting for color..." "(Press F9 to skip)`n" ComColor " - " Color " : " Z++ , ToolTipX, ToolTipY, 1
          Sleep, 1000
          If (Timeout > 0 && Z > Timeout)
          Skip := true
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; HeroFilter --Filters heros according to the passed in parameters
;	     Able to filter and sort on unlimited number of options (parameters is variable)
;	     *Sorting* can be done with a single word, and a ^ to denote an up arrow, and no ^ to denote a down arrow.
;		Rank
;		Level
;		Rating
;		Tier
;	     *Filtering*
;		Green
;		Red
;		Yellow
;		LBlue
;		DBlue
;		Purple
;		1*
;		2*
;		3*
;		4*
;		5*
;	     *Examples*: HeroFilter("Rating^","3*", "4*")
; 			 HeroFilter("Green", "Purple")
; 			 HeroFilter("Level^", "3*", "Purple","Red", "4*","Green","DBlue","1*","LBlue")
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

HeroFilter(params*) {
     xCoord = 0.860
     sorts := Object("Rank", 0.410,"Level", 0.489,"Rating",0.563,"Tier",0.718)
     class := Object("Green",0.441, "Red",0.441,"Yellow",0.547,"LBlue",0.547,"DBlue",0.655,"Purple",0.655)
     tier  := Object("1*",0.588,"2*",0.663,"3*",0.738,"4*",0.817,"5*",0.890)
     ;SINCE THE FILTER OPEN/CLOSE ISN'T DEPENDABLE, LOOP TO MAKE SURE OPEN

     while true {
          PixelGetColor, aColor, getXCoord(0.790), getYCoord(0.382)
          ; MsgBox, %aColor%
          if(aColor <> 0X302C2B){
               ;OPEN FILTER MENU
               ssX = 0.975
               found = 0
               While(0 = found){
                    found := ClickIfColor(ssX, 0.904, 0X716E6E)
                    ;KEEP LOOKING
                    ssX -= 0.002
               }
               ToolTip, Hold on...Confirming panel is fully open, Px+12, Py+24, 2
               Sleep,500
          }
          else {
               break
          }
     }
     Tooltip, , , , 2

     ;RESET FILTERS
     MouseClick, left, getXCoord(xCoord), getYCoord(0.180), 2
     for index,param in params {
          Sleep,250
          ;CLICK SORT
          MouseClick, left, getXCoord(xCoord), getYCoord(0.258),2,10
          Sleep,250
          for k, v in sorts {
               If InStr(param, k){
                    clickCt = 2
                    if InStr(param, "^")
                         clickCt = 1
                    MouseClick, left, getXCoord(xCoord), getYCoord(v),clickCt,10
                    Sleep,250
               }
          }
          for k, v in class {
               If InStr(param, k){
                    ;CLICK FILTER
                    MouseClick, left, getXCoord(xCoord), getYCoord(0.873),1,10
                    Sleep,500
                    ;MAY NEED TO SCROLL TO THE TOP - CHECK IF IT'S AT TOP
                    PixelGetColor, aColor, getXCoord(xCoord), getYCoord(0.481)
                    If ( aColor <> 0X1E942A ) {
                         PixelSearch, Px, Py, getXCoord(xCoord), getYCoord(0.405), getXCoord(xCoord+3), getYCoord(0.698), 0XD33318, 10, Fast
                         ;SCROLL..
                         MouseClickDrag, left, Px, Py, getXCoord(xCoord), getYCoord(0.805), 10
                    }
                    MouseClick, left, getXCoord(xCoord + (Mod(a_index,2) * .09)), getYCoord(v),1,10
                    Sleep,250
               }
          }
          for k, v in tier {
               If InStr(param, k){
                    ;CLICK FILTER
                    MouseClick, left, getXCoord(xCoord), getYCoord(0.873),1,10
                    Sleep,500
                    ;MAY NEED TO SCROLL TO THE BOTTOM - CHECK IF IT'S AT BOTTOM
                    PixelGetColor, aColor, getXCoord(0.854), getYCoord(0.421)
                    If ( aColor <> 0XD33318 ) {
                         PixelSearch, Px, Py, getXCoord(xCoord), getYCoord(0.405), getXCoord(xCoord+3), getYCoord(0.698), 0XD33318, 10, Fast
                         ;SCROLL..
                         MouseClickDrag, left, Px, Py, getXCoord(xCoord), getYCoord(0.200), 7
                    }
                    MouseClick, left, getXCoord(xCoord), getYCoord(v),1,10
                    Sleep,250
               }
          }
     }

     ;CLOSE FILTER MENU
     MouseClick, left, getXCoord(0.753), getYCoord(0.845),1,10
     ;	ToolTip, DONE!, Px+12, Py+24, 2

}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; RECTANGLE FUNCTIONS, FOR MAKING DEBUGGING EASIER
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

; DRAWS A RECTANGLE
DrawRect(Left,Top,Right,Bottom,BorderColor) {
     Border := 2

     ; MSGBOX %Left%,%Top%,%Right%,%Bottom%,%BorderColor%

     Gui, 99: Destroy

     ; MAKE A WINDOW, SET IT TO OUR COLOR OF CHOICE
     Gui, 99: Margin, %Border%, %Border%

     ;Gui, 99: Color, FF0000
     Gui, 99: Color, %BorderColor%

     ; GET WINDOW AND INSIDE SIZE
     tW := Right-Left
     tH := Bottom-Top
     W := tW + Border*2
     H := tH + Border*2
     Left -= Border
     Top -= Border


     ; ADD AN AREA TO MAKE TRANSPARENT
     Gui, 99: Add, Text, w%tW% h%tH% 0x6 ; Draw a white static control
     Gui 99: +LastFound
     WinSet, TransColor, FFFFFF
     Gui 99: -Caption +AlwaysOnTop +ToolWindow

     ; SHOW WHAT WE CREATED
     Gui, 99: Show, NoActivate x%Left% y%Top% w%W% h%H% ;The Gui will not steal keyboard focus
}

; HIDES A RECTANGLE
HideRect() {
     Gui, 99: Destroy
}