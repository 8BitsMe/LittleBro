; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; INITIAL SETUP - IF YOUR BLUESTACKS SCREEN HAS A SIMILAR RATIO TO MINE NOTHING
; NEEDS TO BE CHANGED
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

; CALIBRATE CURRENT WINDOW
WinGetPos, wLeft, wTop, wWidth, wHeight, BlueStacks

SysGet, xborder, 32
SysGet, yborder, 33
SysGet, caption, 4

wTop += caption + yborder/2
wHeight -= (caption + 48 + yborder)
wLeft += xborder/2 - 1
wWidth -= xborder - 2

; MAKE ALL ACTIONS RELATIVE TO THE SCREEN
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

SetDefaultMouseSpeed, 1

; CENTER WINDOW JUST BECAUSE I LIKE IT THAT WAY
WinMove, BlueStacks,, (A_ScreenWidth/2)-(wWidth/2), 64
; TOOLTIP LOCATION
global ToolTipX := wLeft
global ToolTipY := wTop + wHeight + 52

; HEALTH ANALYSIS COORDINATES
global OurMinHealth := wLeft + wWidth * 0.155
global OurMaxHealth := wLeft + wWidth * 0.41
global OurHealthX := wLeft + wWidth * 0.40

global TheirMaxHealth := wLeft + wWidth * 0.59
global TheirMinHealth := wLeft + wWidth * 0.845
global TheirHealthX := wLeft + wWidth * 0.60

global HealthY := wTop + wHeight * 0.115
global HealthBar := wWidth * 0.25

; SPECIAL ANALYSIS COORDINATES
global Special1 := wLeft + wWidth * 0.224
global Special2 := wLeft + wWidth * 0.282
global Special3 := wLeft + wWidth * 0.344
global SpecialY := wTop + wHeight * 0.930

global TheirSpecial1 := wLeft + wWidth * 0.664
global TheirSpecial2 := wLeft + wWidth * 0.726
global TheirSpecial3 := wLeft + wWidth * 0.788
global TheirSpecialY := wTop + wHeight * 0.930

; DETECT CHANGES BEFORE/AFTER LOADING SCREEN
global ChangeXA := wLeft + wWidth * 0.01
global ChangeXB := wLeft + wWidth * 0.99
global ChangeY := wTop + wHeight * 0.03

global MatchLeft := wLeft + wWidth * 0.28
global MatchRight := wLeft + wWidth * 0.72
global MatchY := wTop + wHeight * 0.5

global QuestLeft := wLeft + wWidth * 0.2
global QuestRight := wLeft + wWidth * 0.8
global QuestY := wTop + wHeight * 0.3

global MidX := wLeft + wWidth * 0.5
global MidY := wTop + wHeight * 0.85

; LOST CONNECTION WINDOW LOCATION
global LostA := wLeft + wWidth * 0.300
global LostA := wLeft + wWidth * 0.700
global LostY := wTop + wHeight * 0.300

; CONTINUE BUTTON LOCATION
global ContinueButtonX := wLeft + wWidth * 0.840
global ContinueButtonY := wTop + wHeight * 0.900

; FIND MATCH BUTTON
global FindMatchButtonX := wLeft + wWidth * 0.09
global FindMatchButtonY := wTop + wHeight * 0.90

; COMBAT VARIABLES

global Cycles = 0
global Strategy = Waiting

global Action = 1
global PreAction = 1
global DoActions = 1
global SameColors = 0

global OldAction = 0

global HMin = 0
global HMax = 0
global HCount = 0
global HAvg = 0

global OurDmg = 0
global OurAvgDmg = 0
global TheirDmg = 0
global TheirAvgDmg = 0

global DmgTime = 0
global DmgThreshold = 0

global OurHealth = 100
global OldOurHealth = 100
global TheirHealth = 100
global OldTheirHealth = 100

global sucHits  = 0
global hitsRec = 0
global sucCombo = 0
global highCombo = 0


global CycleTime = 0
global CycleOld = A_TickCount
global CycleSum = 0
global AvgCycle = 0

; DYAMIC ACTION RESPONSE VALUES
global DynaRatio = 0.75
global DamageLevel = 0

global OuterLoop = 0
global OmegaLoop = 0

; ICON LOCATIONS
global OurIconsX := wLeft + wWidth * 0.357
global OurIconsA := wTop + wHeight * 0.395
global OurIconsB := wTop + wHeight * 0.530
global OurIconsC := wTop + wHeight * 0.665

global TheirIconsX := wLeft + wWidth * 0.680
global TheirIconsA := wTop + wHeight * 0.415
global TheirIconsB := wTop + wHeight * 0.550
global TheirIconsC := wTop + wHeight * 0.685

; RED ARROW DETECTION ZONE
global ArrowX := wLeft + wWidth * 0.430
global ArrowA := wTop + wHeight * 0.400
global ArrowB := wTop + wHeight * 0.540
global ArrowC := wTop + wHeight * 0.675

; ACTIONS ARE AT THE END OF LITTLEBRO.AHK

; SHOW US WHAT WE DETECTED AS OUR INSIDE WINDOW
DrawRect(wLeft,wTop,wLeft + wWidth,wTop + wHeight,"FF0000")

gWidth = 80
gHeight = 40
gPad = 8

gFWidth := gWidth + gPad * 2

gIY := gPad

Gui, Color, 303030
Gui, -Caption +Border
Gui, Font, s14

Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , Help
gIY += gPad + gHeight

Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , Quest
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , Fight
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , Battle

gIY += gPad + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , CC
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , C-B
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , B-Z

gIY += gPad + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , WAR-B
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , WAR-C
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , WAR-Y
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , WAR-Z

gIY += gPad + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , F9
gIY += gPad/2 + gHeight
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , PANIC
gIY += gPad + gHeight

gX := wLeft + wWidth + 4
gY := wTop

Gui, Show, NoActivate x%gX% y%gY% w%gFWidth% h%gIY%, LittleBro 0.9993
