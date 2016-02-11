; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AllianceHelp Module - clear those help requests and look more human
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AlliHelp()
{
	global
     
	lblog("Begin AlliHelp",0,2)

	NavigateToScreen("Alliance", "Help")

	HelpClickX := getXCoord(0.781)
	HelpClickY := getYCoord(0.357) 

	lblog("Beginning while help click loop")
	helpButtonClickCounter :=0
	While checkHelpNeeded()
	{
		ToolTip, Helped %helpButtonClickCounter% times, ToolTipX, ToolTipY, 1
		MouseClick, left, HelpClickX, HelpClickY, 1, 10                         
		Sleep, 500
                helpButtonClickCounter++
                if(helpButtonClickCounter > 40)
                {
                	lblog("helpButtonClickCounter exceeded limit")
                        break
                }				
	}	    

     ToolTip, "AlliHelp Finished", HelpClickX, HelpClickY
     lblog("End AlliHelp",0,2)
}
checkHelpNeeded()
{
    bHelpNeeded := 0
    
    ;Does the user have the blue 'my requests' bar?
    PixelGetColor, HelpTabPanelColor, getXCoord(0.344),getYCoord(0.435)
    If HelpTabPanelColor = 0x533C15
    {
    	HelpNeededCheckX := getXCoord(0.353)
    	HelpNeededCheckY := getYCoord(0.555)
    }
    Else If HelpTabPanelColor = 0x111111
    {
    	HelpNeededCheckX := getXCoord(0.344)
    	HelpNeededCheckY := getYCoord(0.435)	
    }
                    
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