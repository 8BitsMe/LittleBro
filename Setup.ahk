; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; INITIAL SETUP - IF YOUR BLUESTACKS SCREEN HAS A SIMILAR RATIO TO MINE NOTHING
; NEEDS TO BE CHANGED
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

; MAKE ALL ACTIONS RELATIVE TO THE SCREEN
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

SetDefaultMouseSpeed, 1

; CALIBRATE CURRENT WINDOW
WinGetPos, wLeft, wTop, wWidth, wHeight, BlueStacks

; CENTER WINDOW JUST BECAUSE I LIKE IT THAT WAY
WinMove, BlueStacks,, (A_ScreenWidth/2)-(wWidth/2), 64

; TOOLTIP LOCATION
global ToolTipX := wLeft
global ToolTipY := wTop + wHeight + 4

; HEALTH ANALYSIS COORDINATES
global OurMinHealth := wLeft + wWidth * 0.16
global OurMaxHealth := wLeft + wWidth * 0.41
global OurHealthX := wLeft + wWidth * 0.40

global TheirMaxHealth := wLeft + wWidth * 0.59
global TheirMinHealth := wLeft + wWidth * 0.84
global TheirHealthX := wLeft + wWidth * 0.60

global HealthY := wTop + wHeight * 0.138
global HealthBar := wWidth * 0.25

; SPECIAL ANALYSIS COORDINATES
global Special1 := wLeft + wWidth * 0.222
global Special2 := wLeft + wWidth * 0.284
global Special3 := wLeft + wWidth * 0.346
global SpecialY := wTop + wHeight * 0.882

global TheirSpecial1 := wLeft + wWidth * 0.662
global TheirSpecial2 := wLeft + wWidth * 0.724
global TheirSpecial3 := wLeft + wWidth * 0.786
global TheirSpecialY := wTop + wHeight * 0.882

; DETECT CHANGES BEFORE/AFTER LOADING SCREEN
global ChangeXA := wLeft + wWidth * 0.01
global ChangeXB := wLeft + wWidth * 0.99
global ChangeY := wTop + wHeight * 0.10

global MatchLeft := wLeft + wWidth * 0.28
global MatchRight := wLeft + wWidth * 0.72
global MatchY := wTop + wHeight * 0.5

global MidX := wLeft + wWidth * 0.5
global MidY := wTop + wHeight * 0.85

; LOST CONNECTION WINDOW LOCATION
global LostA := wLeft + wWidth * 0.300
global LostA := wLeft + wWidth * 0.700
global LostY := wTop + wHeight * 0.300
;0x302C2B
;Button - 0.432x0.639 0x014903

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
global OurIconsA := wTop + wHeight * 0.390
global OurIconsB := wTop + wHeight * 0.513
global OurIconsC := wTop + wHeight * 0.634

global TheirIconsX := wLeft + wWidth * 0.680
global TheirIconsA := wTop + wHeight * 0.414
global TheirIconsB := wTop + wHeight * 0.539
global TheirIconsC := wTop + wHeight * 0.653

; RED ARROW DETECTION ZONE
global ArrowX := wLeft + wWidth * 0.429
global ArrowA := wTop + wHeight * 0.400
global ArrowB := wTop + wHeight * 0.522
global ArrowC := wTop + wHeight * 0.644

; ACTIONS ARE AT THE END OF LITTLEBRO.AHK

gWidth = 80
gHeight = 40
gPad = 8

gFWidth := gWidth + gPad * 2

gIY := gPad

Gui, Color, 302C2B
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
Gui, Add, Button, x%gPad% y%gIY% w%gWidth% h%gHeight% , PANIC
gIY += gPad + gHeight

gX := wLeft + wWidth + 4
gY := wTop

Gui, Show, NoActivate x%gX% y%gY% w%gFWidth% h%gIY%, LittleBro 0.9993
