BattleCycle(WhichWar := "WAR-B", winStreak := 0) {
	 loop {
	    title := getOCRArea(0.251, 0.119, 0.725, 0.226, "alpha")

		if InStr(title, "LIN_UP")
			BattleMatchFights()
	    else if InStr(title,"EDIT T_AM") {
	    	ChampSel( WhichWar, winStreak )
			ToolTip,
			; CLICK FIND MATCH BUTTON
			ToolTip, EDIT TEAM`nFinding match..., ToolTipX, ToolTipY, 1
			MouseClick, left, FindMatchButtonX, FindMatchButtonY,1, 5
		}
		else if InStr(title, "OPPONENT SELE") {
			MatchSel()
			ClickContinue("OPPONENT SELECT`nAccepting match")
		}
		else if InStr(title,"_ET LINEUP") {
			SmartSort()
			ClickContinue("SET LINEUP`nAccepting match")
		} else if InStr(title, "REWARDS" )
			ClickContinue("REWARDS Screen green Button...")
		else if InStr(title, "ACHI_V_M_NTS" )
			ClickContinue("ACHIEVEMENTS Screen green Button...")

		Sleep, 100

	 } Until InStr(title, "MULTM")

     ToolTip,

}

BattleMatchFights() {

     Loop, 3 {
          ; TAP BEGIN BATTLE, WAIT FOR THE TRANSITION TO LOADING, THEN WAIT FOR LOADING TO END
	 	  Sleep, 3500




		  PixelGetColor, gColor, getXCoord(0.250), getYCoord(0.425 + (.12 * (A_Index-1) ))
		  ; LOOKING FOR RED OR GREEN
     	  If ((gColor = 0x2E5526) OR (gColor = 0x1A1A72))
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
		  WaitForColor(0.485, 0.078, 0x065108,30)

          ToolTip, Found Green, ToolTipX, ToolTipY, 1

          SingleFight()

          ToolTip, Fight finished...`nWaiting on screenload, ToolTipX, ToolTipY, 1

		  Sleep, 5

		  loop
		  	title := getOCRArea(0.251, 0.119, 0.725, 0.226, "alpha")
		  Until InStr(title, "LIN_UP")


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



ClickContinue(Why, timeout :=10){
     WaitFoRButton(1, Why, 0.910, 0.910, 0X024B03, timeout)
}