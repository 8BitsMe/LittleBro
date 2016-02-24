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
     Sleep, 500
     lblog("Beginning while help click loop")
     helpButtonClickCounter :=0
     While checkHelpNeeded()
     {
          ShowOSD("Helped " helpButtonClickCounter++ " times")
          MouseClick, left, HelpClickX, HelpClickY, 1, 10                         
          if(helpButtonClickCounter > 40)
          {
               ShowOSD("Exceeded help limit (you heartless bastard!)")
               lblog("helpButtonClickCounter exceeded limit")
               break
          }				
     }	    
     
     ToolTip, "AlliHelp Finished", HelpClickX+15, HelpClickY+15
     lblog("End AlliHelp",0,2)
}

checkHelpNeeded()
{
     bHelpNeeded := 0
     ;MsgBox, Checking for request
     Sleep, 500
     ;Does the user have the blue 'my requests' bar?
     PixelGetColor, HelpTabPanelColor, getXCoord(0.340),getYCoord(0.445)   
     
     If HelpTabPanelColor = 0x533C15
     {
          HelpNeededCheckX := getXCoord(0.305)
          HelpNeededCheckY := getYCoord(0.540)
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