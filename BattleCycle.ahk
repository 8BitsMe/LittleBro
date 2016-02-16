BattleCycle(WhichWar := "WAR-B", winStreak := 0) {
     loop {
          ;ToolTip, ARENA FIGHTS`nLooking for page name..., ToolTipX, ToolTipY, 1
          
          title := getOCRArea(0.20, 0.1, 0.80, 0.17, "alpha")
          
          ToolTip, ARENA FIGHTS`nFound page name: %title%, ToolTipX, ToolTipY, 1
          Sleep, 2000
          
          if ( InStr(title, "LIN_UP") OR InStr(title, "LINEUP") ) {
               ToolTip, SERIES MATCH - LINEUP`nContinue and fight..., ToolTipX, ToolTipY, 1
               BattleMatchFights()
               ToolTip, SERIES MATCH - LINEUP`nDone with fights..., ToolTipX, ToolTipY, 1
          }
          else if ( InStr(title,"EDIT T_AM") OR InStr(title,"EDIT TEAM")){
               ToolTip, EDIT TEAM`nLaunching ChampSel..., ToolTipX, ToolTipY, 1
               ChampSel( WhichWar, winStreak )
               ToolTip,
               ; CLICK FIND MATCH BUTTON
               ToolTip, EDIT TEAM`nFinding match..., ToolTipX, ToolTipY, 1
               MouseClick, left, FindMatchButtonX, FindMatchButtonY,1, 5
          }
          else if ( InStr(title, "OPPONENT SELE") OR InStr(title, "OPPON")){
               ToolTip, OPPONENT SELECT`nDeciding which easy/medium team to fight..., ToolTipX, ToolTipY, 1
               MatchSel()
               ClickContinue("OPPONENT SELECT`nAccepting match")
          }
          else if ( InStr(title,"_ET LINEUP") OR InStr(title,"SET LINEUP")) {
               ToolTip, SET LINEUP`nDeciding hero vs hero..., ToolTipX, ToolTipY, 1
               SmartSort()
               ClickContinue("SET LINEUP`nAccepting match")
          } else if InStr(title, "WARDS" ){
               ToolTip, REWARDS screen`nClicking continue..., ToolTipX, ToolTipY, 1
               ClickContinue("REWARDS Screen green Button...")
          } else if InStr(title, "ACHI_V_M_NTS" ) {
               ToolTip, ACHIEVEMENTS`nClicking continue..., ToolTipX, ToolTipY, 1
               ClickContinue("ACHIEVEMENTS Screen green Button...")
          }
          
          ; Need a better way to wait between pages
          WaitForNoChange(0.850,0.876,"Page done, Looking for current page",5)
          
     } Until (InStr(title, "ARENA") OR InStr(title, "MULTIVERSE"))
     
     ToolTip,
}

BattleMatchFights() {
     
     Loop, 3 {
          ; DETERMINING IF THERE WAS ALREADY A WIN/LOSS IN THIS ROUND OF THE FIGHT
          WaitForColor("SERIES MATCH - LINEUP`nLooking for loss in round",0.283,0.443+ (.12 * (A_Index-1) ),0X1A1A72,.5)
          If ( ErrorLevel = 0 )
          continue
          WaitForColor("SERIES MATCH - LINEUP`nLooking for win in round",0.283,0.443+ (.12 * (A_Index-1) ),0X2F5428,.5)
          If ( ErrorLevel = 0 )
          continue
          
          curHero := GetOCRArea(0.136, 0.457 + (.12 * (A_Index-1) ), 0.301, 0.490 + (.12 * (A_Index-1) ), "alpha")
          curStars := GetOCRArea(0.136, 0.425 + (.12 * (A_Index-1) ), 0.235, 0.463 + (.12 * (A_Index-1) ))
          duped := ""
          
          IfInString, curStars, &
          duped := "(Unduped)"
          
          curStars := StrLen(curStars) . "*" . duped
          
          WhatLoop := "Starting fight1... Loop " . A_Index
          ClickContinue(WhatLoop, 60)
          
          ; LOOKING FOR GREEN AT THE TOP OF THE WINDOW
          WaitForColor("Waiting for pause button", 0.485, 0.045, 0x075309,30)
          
          ToolTip, Found Green, ToolTipX, ToolTipY, 1
		  
		  
          
          SingleFight()
          
          ToolTip, Fight finished...`nWaiting on screenload, ToolTipX, ToolTipY, 1
          
          Sleep, 3000
          
          loop 30 {
               title := getOCRArea(0.3, 0.1, 0.7, 0.15, "alpha")
               if InStr(title, "LIN_UP")
                    break
               sleep, 250
          }
          
          WaitForNoChange(getXCoord(0.250), getYCoord(0.425 + (.12 * (A_Index-1) )),"Calculating Score...", 20)
          
          
          ; GET CURRENT POINTS
          fightPoints := GetOCRArea(0.440, 0.470 + (.12 * (A_Index-1) ), 0.512, 0.505 + (.12 * (A_Index-1) ), "numeric")
          currentPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215, "numeric")
          Everything := GetOCRArea(0.136, 0.425 + (.12 * (A_Index-1) ), 0.304, 0.516 + (.12 * (A_Index-1) ), "debug")
          
          msg := curHero . " , " . curStars . " , " . CycleSum/1000 . " , " . fightPoints . " , " . currentPoints . " , " . winStreak . " , " . multiplier . " , " . sucHits . " , " . hitsRec . " , " . sucCombo . " , " . highCombo . " `n " . Everything
          lbFightLog(msg)
     }
     
     ; GET CURRENT POINTS
     fightPoints := GetOCRArea(0.440, 0.470 + (.12 * (2) ), 0.512, 0.505 + (.12 * (2) ), "numeric")
     currentPoints := GetOCRArea(0.526, 0.167, 0.641, 0.215, "numeric")
     Everything := GetOCRArea(0.136, 0.425 + (.12 * (2) ), 0.304, 0.516 + (.12 * (2) ), "debug")
     
     msg := curHero . " , " . curStars . " , " . CycleSum/1000 . " , " . fightPoints . " , " . currentPoints . " , " . winStreak . " , " . multiplier . " , " . sucHits . " , " . hitsRec . " , " . sucCombo . " , " . highCombo . " `n " . Everything
     lbFightLog(msg)
     
     ToolTip, Battles complete!, ToolTipX, ToolTipY, 1
}