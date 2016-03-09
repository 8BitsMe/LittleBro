BattleCycle() {
     global
     
     loop {
          ; Get rid of things obscuring our window
          NagKiller()
          
          ; IN 1v1 BY ACCIDENT? LET'S GO BACK!
          PixelGetColor, gColor, getXCoord(0.150), getYCoord(0.500)
          If (gColor = 0x302C2B) {
               MouseClick, left, GetXCoord(0.04),GetYCoord(0.04),5
               WaitForChange(0.5,0.75,"Switching versus arenas...",5)
          }
          
          If (gColor = 0x0C0B0B) {
               MouseClick, left, GetXCoord(0.150),GetYCoord(0.500),5
               WaitForChange(0.5,0.75,"Getting out of a misclick...",5)
          }
          
          
          ; IF WE SUDDENLY FIND OURSELVES FIGHTING
          InAFight()
          If (ErrorLevel < 1) {
               SingleFight()
          }
          
          title := getOCRArea(0.20, 0.1, 0.80, 0.17, "alpha")
          
          ShowOSD("ARENA FIGHTS`nFound page name: "title)
          
          if ( InStr(title,"ET LINEUP") OR InStr(title,"SET LINEUP")) {
               
               ShowOSD("SET LINEUP`nDeciding hero vs hero...")
               SmartSort()
               ClickContinue("SET LINEUP`nAccepting match")
          }
          else if ( InStr(title, "LIN_UP") OR InStr(title, "LINEUP") ) {
               ShowOSD("SERIES MATCH - LINEUP`nContinue and fight...")
               BattleMatchFights()
               ShowOSD("SERIES MATCH - LINEUP`nDone with fights...")
          }
          else if ( InStr(title,"EDIT T_AM") OR InStr(title,"EDIT TEAM")){
               ShowOSD("EDIT TEAM`nLaunching ChampSel...")
               ; CLICK FIND MATCH BUTTON
               ShowOSD("EDIT TEAM`nFinding match...")
               If (ChampSel()) {
                    MouseClick, left, FindMatchButtonX, FindMatchButtonY,1, 5
               }
          }
          else if ( InStr(title, "OPPONENT SELE") OR InStr(title, "OPPON")){
               ShowOSD("OPPONENT SELECT`nDeciding which easy/medium team to fight...")
               MatchSel()
               ClickContinue("OPPONENT SELECT`nAccepting match")
          }
          else if InStr(title, "WARDS" ){
               ShowOSD("REWARDS screen`nClicking continue...")
               ClickContinue("REWARDS Screen green Button...")
          }
          else if InStr(title, "ACHI" ) {
               ShowOSD("ACHIEVEMENTS`nClicking continue...")
               ClickContinue("ACHIEVEMENTS Screen green Button...")
          }
          
          ; Need a better way to wait between pages
          WaitForNoChange(0.5,0.5,"Page done, Looking for current page",5)
          
     } Until (InStr(title, "ARENA") OR InStr(title, "MULTIVERSE"))
     
     ShowOSD("Back on ARENA selection")
}

BattleMatchFights() {
     global
     
     multiplier := GetOCRArea(0.38, 0.15, 0.42, 0.2)
     
     SeriesFightPoints := 0
     SeriesPIs := ""

     Loop, 3 {
          loopOffset := .134 * (A_Index-1)
          
          currentPoints := GetOCRArea(0.52, 0.15, 0.66, 0.2, "numeric")
          
          ; DETERMINING IF THERE WAS ALREADY A WIN/LOSS IN THIS ROUND OF THE FIGHT
          PixelGetColor, aColor, getXCoord(0.283), getYCoord(0.443+ loopOffset)
          
          If ( aColor = 0X2F5428 ) {
               ; Win spotted
               continue
          }
          If ( aColor = 0X1A1A72 ) {
               ; Loss spotted
               If (LBSaveStreak = "no") {
                    continue
               }
               Else If (winStreak > 0) {
                    LineAlert("Potential to LOSE STREAK ... pausing LB", "newline")
                    Sleep, 1000
                    ScreenshotWindow()
                    MsgBox, Streak loss possible ... Click OK to let LB continue or F12 to take over.
                    continue
               }

          }
          
	  curPI := GetOCRArea(0.310, 0.513 + loopOffset, 0.365, 0.540 + loopOffset, "numeric")
          curHero := GetOCRArea(0.130, 0.472 + loopOffset, 0.301, 0.506 + loopOffset, "alpha")
          curStars := GetOCRArea(0.130, 0.435 + loopOffset, 0.235, 0.475 + loopOffset)
          duped := ""
          
          IfInString, curStars, &
          duped := "(Unduped)"
          
          curStars := StrLen(curStars) . "*" . duped
          
          WhatLoop := "Starting fight1... Loop " . A_Index
          
          ClickContinue(WhatLoop, 30)
          
          ; LOOKING FOR GREEN AT THE TOP OF THE WINDOW
          WaitForColor("Waiting for pause button", 0.485, 0.045, 0x075309,15)
          
          SingleFight()
          
          ShowOSD("Fight finished...`nWaiting on screenload")
          
          Sleep, 3000
          
          loop 90 {
               title := getOCRArea(0.3, 0.1, 0.7, 0.15, "alpha")
               if InStr(title, "LIN_UP")
                    break
               sleep, 250
          }
          
          WinOrLoss := ""
          
          WaitForNoChange(getXCoord(0.250), getYCoord(0.425 + loopOffset),"Calculating Score...", 20)
	   If ( A_Index = 3 ){
               LossCount := 0
               Loop, 3 {
                    loopOffset := .134 * (A_Index-1)
                    PixelGetColor, aColor, getXCoord(0.283), getYCoord(0.443+ loopOffset)
                    If ( aColor = 0X1A1A72 ) {
                         ; Loss spotted
                         LossCount++	
                         WinOrLoss := WinOrLoss . "L"
                    } else {
                         WinOrLoss := WinOrLoss . "W"
                    }
               }
               If ( LossCount > 1 ) {
                    ; We lost series	
                    ScreenshotWindow()
                    LineAlert("Loss Detected", "newline")	
               }
          }          
          ; GET CURRENT POINTS
          fightPoints := GetOCRArea(0.440, 0.481 + loopOffset, 0.512, 0.526 + loopOffset, "numeric")
          Everything := GetOCRArea(0.131, 0.436 + loopOffset, 0.300, 0.539 + loopOffset)
          enemyEverything := GetOCRArea(0.696, 0.436 + loopOffset, 0.870, 0.539 + loopOffset)

	  SeriesFightPoints += fightPoints
	  SeriesPIs = %SeriesPIs% %curPI%
	  FightHMinPI := (HMin/(curPI/1000))
	  FightHMaxPI := (HMax/(curPI/1000))
	  FightHAvgPI := (((HMin+HMax)/2)/(curPI/1000))
	  SumHMinPerPI += FightHMinPI
	  SumHMaxPerPI += FightHMaxPI
	  SumHAvgPerPI += FightHAvgPI
	  FightCounter++
 ;MsgBox, %SumHMinPerPI% %SumHMaxPerPI% %SumHAvgPerPI% %FightCounter% %HMin% %HMax% %HAvg%

          msg := curHero . " , " . curStars . " , " . CycleSum/1000 . " , " . fightPoints . " , " . currentPoints . " , " . winStreak . " , " . multiplier . " , " . sucHits . " , " . hitsRec . " , " . sucCombo . " , " . highCombo . " , `n " . Everything . " , VS , " . enemyEverything
          lbFightLog(msg)
     }
     
     ShowOSD(Battles complete!)

	If(ReportCategory = 3)
	{
		3StarSeries ++
		3StarLossCount += LossCount
		3StarPoints += SeriesFightPoints
	}
	Else
	{
		4StarSeries ++
		4StarLossCount += LossCount
		4StarPoints += SeriesFightPoints
	}

     LineReport("[" OmegaLoop "][" OuterLoop "/" LoopLimit "] - " WhichWar " - [Streak: " winStreak "][PI: " StreakPI "] [" ThousandsSep( currentPoints ) "][" WinOrLoss "][" (SeriesFightPoints) "]", "ARENA")
     previousPoints := currentPoints
}