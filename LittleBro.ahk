#NoEnv
#SingleInstance Force
SetTitleMatchMode, 2

SetBatchLines, -1

;~ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;~ ydobemos LittleBro v 0.9992 & PEOPLE
;~ Thanks to those who contribute with code, tips and ideas, I won't mention you here in
;~ case some salty person ever leaks this to Kabam so only I go down with the ship ;)
;~ =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;~ WHAT YOU NEED
;~ 1) A PC that can run Bluestacks (IMPORTANT - VERSION 1.X OF BLUESTACKS! 2.X DOESN'T PLAY NICE)
;~ 2) BlueStacks - get it here: http://www.bluestacks.com/
;~ 3) AutoHotKey - get it here: http://www.autohotkey.com/
;~ 4) [Optional, but probably needed] A decent AHK editor, I recommend: http://fincs.ahk4.net/scite4ahk
;~ SETUP
;~ 1) Install AutoHotKey (and optionally Scite4AHK)
;~ 2) Install Bluestacks, set up your account, install CoC there, have the window open and active
;~ 3) Run the script and if your config isn't too far off enjoy some neat automation
;~ When you run the script it will find the BlueStacks window and in a perfect world adjust itself so that everything
;~ is clicked/tapped just right. If this doesn't happen you'll have to figure out the ratios and set them up yourself
;~ HOW IT WORKS:
;~ Just use the bottom panel
;~ QUEST  When in quest map screen or fight screen this will automatically continue by clicking nodes, starting fights,  skipping cutscenes. It can get stuck since it detects a certain area around the middle of the screen - in that case just use the mouse to scroll the screen a bit
;~ FIGHT  Start a fight  any place, any time  will engage the LittleBro fight engine and try to pulverize whoever gets in the way.
;~ BATTLE  Use from champion selection screen in an arena. Make your own roster and start a 3 fight battle.
;~ WAR-B, WAR-C, WAR-Y, WAR-Z  In versus screen (where you pick arenas) imagine that each arena corresponds to a letter, so B is 2nd (usually 2*), C is 3rd (usually 4*) and Y and Z are the same, but from the end (so Catalyst arena, for example).
;~ C-B  shuffle mode of given arenas  good when you dont have enough guys or just want to get some points in lower arenas as well. You can change the number of fights on the bottom of LittleBro.ahk
;~ PANIC  cancel script! Useful, also F12 on keyboard.

; WE TRY TO RUN THE SCRIPT AS ADMIN, SINCE SOME WINDOWS VERSIONS DON'T READ BLUESTACKS SCREEN RIGHT OTHERWISE
If not A_IsAdmin
{
     Run *RunAs "%A_ScriptFullPath%" ; Requires v1.0.92.01+
     ExitApp
}

#Include Setup.ahk

#Include fastPixelGetColor.ahk

#Include SingleFight.ahk
#Include BattleScan.ahk
#Include StrataDev.ahk
#Include Actions.ahk

#Include Functions.ahk
#Include ChampSel.ahk
#Include SmartSort.ahk

#Include FullLoop.ahk
#Include BattleCycle.ahk
#Include AutoQuest.ahk
#Include AlliHelp.ahk

;#Include OCR
#Include OCR.ahk


; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F1 TO SOMETHING
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F1::
AutoQuest()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F2 TO SMART SORT
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F2::
;MatchSelection()
SmartSort()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F3 TO SORT BY HERO RATING IN CHAMP SELECTION
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F3::
; Tap Funnel
MouseClick, left, (wLeft + wWidth * 0.97),(wTop + wHeight * 0.84)
Sleep, 1500
; Tap sort by hero rating
MouseClick, left, (wLeft + wWidth * 0.9),(wTop + wHeight * 0.57)
Sleep, 750
; Tap FILTER
MouseClick, left, (wLeft + wWidth * 0.88),(wTop + wHeight * 0.88)
Sleep, 750
; DRAG BOTTOM UP
MouseClickDrag, left, (wLeft + wWidth * 0.88),(wTop + wHeight * 0.88),(wLeft + wWidth * 0.88),(wTop + wHeight * 0.55),5
Sleep, 500
MouseClickDrag, left, (wLeft + wWidth * 0.88),(wTop + wHeight * 0.88),(wLeft + wWidth * 0.88),(wTop + wHeight * 0.55),5
Sleep, 500
; TAP ***
MouseClick, left, (wLeft + wWidth * 0.88),(wTop + wHeight * 0.75)
Sleep, 750
; TAP ****
MouseClick, left, (wLeft + wWidth * 0.88),(wTop + wHeight * 0.83)
Sleep, 750
; Tap Funnel
MouseClick, left, (wLeft + wWidth * 0.75),(wTop + wHeight * 0.84)
Sleep, 1500
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F4 TO PICK FREE CHAMPIONS
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F4::
ChampSel()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F5 TO START THE BATTLE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F5::
SingleFight()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F6 TO ENTER ARENA LOOP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F6::
BattleCycle()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F7 TO MANUALLY CALL ALLIHELP
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F7::
AlliHelp()
Return

; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; PRESS F8 SHOW XP PERCENTAGE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

F8::
XPercentage()
Return

F9::skip := true

F10:: ; ShowMouseRatio and BrightnessIndex
ShowMouseRatio()
Return

F12::
Reload ; Reload script
Return


^+Left::
MouseMove, -1,0,0,R
ShowMouseRatio()
Return

^+Right::
MouseMove, 1,0,0,R
ShowMouseRatio()
Return

^+Up::
MouseMove, 0,-1,0,R
ShowMouseRatio()
Return

^+Down::
MouseMove, 0,1,0,R
ShowMouseRatio()
Return

ButtonQuest:
AutoQuest()
Return

ButtonFight:
SingleFight()
Return

ButtonBattle:
BattleCycle()
Return

ButtonC-B:

OmegaLoop = 0
Loop {
     OmegaLoop++
     Random, A , 5, 7
     FullLoop("WAR-C",A)
     Random, A , 2, 4
     FullLoop("WAR-B",A)
     
     If (OmegaLoop > 3)
     break
     
}

WinClose, BlueStacks

FormatTime, TimeString,, Time
MsgBox OmegaLoop finished at: %TimeString%.
Return

ButtonB-Z:
OmegaLoop = 0
Loop {
     OmegaLoop++
     Random, A , 1, 3
     FullLoop("WAR-B",A)
     Random, A , 7, 9
     FullLoop("WAR-Z",A)
}
Return

ButtonCC:
FullLoop("CC",0)
Return

ButtonWAR-B:
FullLoop("WAR-B",0)
Return

ButtonWAR-C:
FullLoop("WAR-C",0)
Return

ButtonWAR-Y:
FullLoop("WAR-Y",0)
Return

ButtonWAR-Z:
FullLoop("WAR-Z",0)
Return

ButtonPANIC:
Reload
Return

