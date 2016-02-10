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
     
     ToolTip, %RatioX% x %RatioY% B: %B% C:%gColor% , X+12, Y+24
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
; UNIVERSAL BUTTON WAIT FUNCTION, DATA IN SAME FORMAT AS F10 SCAN
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForButton(Click, Why, X, Y, Color, TimeOut := 0) {
     global
     Z = 0
     
     X := wLeft + wWidth * X
     Y := wTop + wHeight * Y
     
     Skip := false
     MouseMove, X, Y
     PixelSearch, Px, Py, X-4, Y-4, X+4, Y+4, Color, 30, Fast
     While (ErrorLevel > 0 && !Skip)	{
          Sleep, 1000
          PixelSearch, Px, Py, X-4, Y-4, X+4, Y+4, Color, 30, Fast
          
          ToolTip, % "[" OmegaLoop "][" OuterLoop "] " Why "`n(Press F9 to skip) : " Z++ , ToolTipX, ToolTipY, 1
          
          If (Timeout > 0 && Z > Timeout) OR (Z > 100)
          Skip := True
     }
     
     If Click && !Skip {
          MouseClick, left, X, Y
          Sleep, 250
          ToolTip, Tap!, Px+12, Py+24, 2
          MouseClick, left, X, Y
          Sleep, 250
          ToolTip, Tap!, Px+12, Py+24, 2
     }
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; CALL OCR LIBRARY
; Top left x and y, bottom right x and y (percentages)
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

GetOCRArea(tlX, tlY, brX, brY, options="") {
     global
     
     topLeftX := wLeft + wWidth * tlX
     topLeftY := wTop + wHeight * tlY
     widthToScan := (wLeft + wWidth * brX) - topLeftX
     heightToScan := (wTop + wHeight * brY) - topLeftY
     
     magicalText := GetOCR(topLeftX, topLeftY, widthToScan, heightToScan, options)
     
     ;	ToolTip, Says: %magicalText%, Px+12, Py+24, 2
     ;Sleep, 1000
     
     Return SubStr(magicalText, 1,-2)
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

NavigateToScreen(screen)
{
     ;always reset to 'home'
     
     ;If (screen == "main") 
     ;navigate to main
     ;Else If (screen == "vs")
     ;navigate to vs
     ;Else If (screen == "quest")
     ;navigate to quests
     ;Else
     ;navigate to main
}

ClickIfColor(ratioX, ratioY, clickColor, speed := 2)
{
     global
     bColorFound = 0
     clickX := wLeft + wWidth * ratioX 
     clickY := wTop + wHeight * ratioY
     
     
     PixelSearch, Px, Py, clickX-8, clickY-8, clickX+8, clickY+8, clickColor, 10, Fast
     
     If (ErrorLevel < 1)
     { 
          bColorFound = 1
          MouseClick, left, clickX, clickY, speed
     }
     
     lblog("******** ClickIfColor ==> clickX: " . clickX . " - clickY: " . clickY . " ... clickColor: " . clickColor . " -- gColor: " . gColor . " .. Return: " . bColorFound)	
     return bColorFound
}

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; WAITS FOR A SPECIFIC COLOR TO SHOW UP AT A SPECIFIC LOCATION
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WaitForColor(X,Y,Color,Timeout)
{     
     global
     X := wLeft + wWidth * X
     Y := wTop + wHeight * Y
     PixelGetColor, ComColor, X, Y
     Z = 0
     Skip := false
     While (ComColor <> Color) && !Skip {
          PixelGetColor, ComColor, X, Y
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
;	     *Examples*: HeroSort("Rating^","3*", "4*")
; 			 HeroSort("Green", "Purple")
; 			 HeroSort("Level^", "Purple","Red","Green","LBlue","DBlue","1*", "3*", "4*")
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

HeroFilter(params*) {
	xCoord = 0.860
	sorts := Object("Rank", 0.410,"Level", 0.489,"Rating",0.563,"Tier",0.718)
	class := Object("Green",0.441, "Red",0.441,"Yellow",0.547,"LBlue",0.547,"DBlue",0.655,"Purple",0.655)
	tier  := Object("1*",0.588,"2*",0.663,"3*",0.738,"4*",0.817,"5*",0.890)
	;SINCE THE FILTER OPEN/CLOSE ISN'T DEPENDABLE, LOOP TO MAKE SURE OPEN

	while true {
		PixelGetColor, aColor, getXCoord(0.790), getYCoord(0.382)

		if(aColor <> 0X302C2B){
			;OPEN FILTER MENU
			ssX = 0.966
			found = 0
			While(0 = found){
				found := ClickIfColor(ssX, 0.838, 0X716E6E,1)
				;KEEP LOOKING
				ssX -= 0.002
			}
			ToolTip, AFTer LOOP, Px+12, Py+24, 2
			Sleep,100
		}
		else {
			break
		}
	}
	;RESET FILTERS
	MouseClick, left, getXCoord(xCoord), getYCoord(0.180), 2
	for index,param in params {
		;CLICK SORT
		MouseClick, left, getXCoord(xCoord), getYCoord(0.258),2,10
		for k, v in sorts {
			If InStr(param, k){
				clickCt = 2
				if InStr(param, "^")
					clickCt = 1
				MouseClick, left, getXCoord(xCoord), getYCoord(v),clickCt,10
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
			}
		}
	}
	
	;CLOSE FILTER MENU
	MouseClick, left, getXCoord(0.753), getYCoord(0.845),1,10
;	ToolTip, DONE!, Px+12, Py+24, 2

}
