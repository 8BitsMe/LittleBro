; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AllianceHelp Module - clear those help requests and look more human
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AlliHelp()
{
     global
     
     lblog("Begin AlliHelp",0,2)
     
     ; Look to see if main menu notifications exist    
     MainMenuHelpRatioX = 0.193
     MainMenuHelpRatioY = 0.075
     helpColor = 0x000059
     
     bMainHelpColorFound := ClickIfColor(MainMenuHelpRatioX, MainMenuHelpRatioY, helpColor) ; checks if red alert circle exists on the main menu icon
     
     ; Is the menu open? Perhaps we just looked if help is needed
     OpenMainMenuHelpX := getXCoord(0.166)
     OpenMainMenuHelpY := getYCoord(0.075)
     BackColor = 0x272323
     
     PixelGetColor, MenuColor, OpenMainMenuHelpX, OpenMainMenuHelpY ; checks top margin for grey background meaning menu is open
     
     If(bMainHelpColorFound) or (MenuColor = BackColor) ; at this point the menu should be open
     {
	  WaitForColor(0.166,0.075,0x272323,0) ; Checking menu background again to ensure loaded
          AllianceHelpRatioX := 0.416
          AllianceHelpRatioY := 0.161
          helpColor := 0x000059	
          
          bAllianceHelpColorFound := ClickIfColor(AllianceHelpRatioX, AllianceHelpRatioY, helpColor) ; checks red alert circle exists on Alliance tab button
          
          If(bAllianceHelpColorFound)
          {
	       ; In the case the user was already on the alliance tab, click the menu close button
	       MenuCloseClickX := getXCoord(0.144)
	       MenuCloseClickY := getYCoord(0.334)
	       MouseClick, left, MenuCloseClickX, MenuCloseClickY

               ; IS THE ALLIANCE PAGE PANEL VISIBLE?
	       Sleep, 500 ; chill half a sec for menu to close
               WaitForColor(0.06,0.5,0x302C2B,0) ; checks left margin for grey background (all other tabs are colorful)
               
               HelpTabRatioX := 0.484
               HelpTabRatioY := 0.268
               helpColor := 0x000059
	       ActiveColor := 0xB07A2D

               PixelGetColor, HelpTabColor, getXCoord(HelpTabRatioX), getYCoord(HelpTabRatioY) ; checks to see if help tab is already active (blue, no red alert circle)
               bHelpTabColorFound := ClickIfColor(HelpTabRatioX, HelpTabRatioY, helpColor) ; checks red alert circle exists on Alliance tab, help button
               
               If(bHelpTabColorFound) or (HelpTabColor = ActiveColor)
               {    
                    ; ARE WE ON THE HELP PAGE?
		    WaitForColor(0.344,0.435,0x533C15,0) ; Checking blue bar labeled "MY REQUESTS"
                 
                    lblog("Beginning while help click loop")
                    helpButtonClickCounter :=0

                    While checkHelpNeeded()
                    {
                         ToolTip, Helped %helpButtonClickCounter% times, ToolTipX, ToolTipY, 1

		         HelpClickX := getXCoord(0.781)
		         HelpClickY := getYCoord(0.357)                         
                         MouseClick, left, HelpClickX, HelpClickY
                         
                         Sleep, 500
                         helpButtonClickCounter++
                         if(helpButtonClickCounter > 40)
                         {
                              lblog("helpButtonClickCounter exceeded limit")
                              break
                         }				
		    }	    
               }
          }
     }

     ToolTip, "AlliHelp Finished", HelpClickX, HelpClickY
     lblog("End AlliHelp",0,2)
}
checkHelpNeeded()
{
    bHelpNeeded := 0
                   
    HelpNeededCheckX := getXCoord(0.353)
    HelpNeededCheckY := getYCoord(0.555)
                    
    PixelGetColor, helpCheckColor, HelpNeededCheckX, HelpNeededCheckY ; checking background of first help request bar (if there)

    If helpCheckColor = 0x111111 ; black
    {
	bHelpNeeded := 1
    }
    Else If helpCheckColor = 0x221D1B ; dark grey
    {
	bHelpNeeded := 0
    }
    Else
    {
	bHelpNeeded := 0
	;ToolTip, %HelpNeededCheckX% x %HelpNeededCheckY% C:%helpCheckColor% , HelpNeededCheckX+12, HelpNeededCheckY+24 ;DEBUG
        lbLog("Something went wrong, neither color found in AlliHelp Help Panel. " . helpCheckColor)
    }

    return bHelpNeeded
}