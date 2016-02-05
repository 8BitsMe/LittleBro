; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AllianceHelp Module - clear those help requests and look more human
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AlliHelp()
{
     global
     
     lblog("Begin AlliHelp",0,2)
     
     ; Look to see if main menu notifications exist (x: 0.193 y 0.074 color 0x000059)
     
     MainMenuHelpRatioX = 0.193
     MainMenuHelpRatioY = 0.075
     helpColor = 0x000059
     
     bMainHelpColorFound := ClickIfColor(MainMenuHelpRatioX, MainMenuHelpRatioY, helpColor)
     
     ; Is the menu open? Perhaps we just looked if help is needed
     
     OpenMainMenuHelpRatioX := getXCoord(0.166)
     OpenMainMenuHelpRatioY := getYCoord(0.075)
     BackColor = 0x272323
     
     PixelGetColor, MenuColor, OpenMainMenuHelpRatioX, OpenMainMenuHelpRatioY
     
     If(bMainHelpColorFound) or (MenuColor = BackColor)
     {
          Sleep, 1000
          AllianceHelpRatioX := 0.416
          AllianceHelpRatioY := 0.161
          helpColor := 0x000059	
          
          bAllianceHelpColorFound := ClickIfColor(AllianceHelpRatioX, AllianceHelpRatioY, helpColor)
          
          If(bAllianceHelpColorFound)
          {
               Sleep, 500 ; Need a little delay here
               WaitForColor(Are we on Alliance page?,0.06,0.5,0x302C2B,0) ;WaitForColor(X,Y,Color,Timeout)
               
               HelpTabRatioX := 0.484
               HelpTabRatioY := 0.268
               helpColor := 0x000059
               
               bHelpTabColorFound := ClickIfColor(HelpTabRatioX, HelpTabRatioY, helpColor)
               
               If(bHelpTabColorFound)
               {
                    ; NOTE: in this section we look at the Help button to see if it's grey (otherwise it's a pulsing green)
                    
                    Sleep, 500 ; Need a little delay here
                    WaitForColor(Are we on the Help page?,0.5,0.33,0X302C2B,0) ;WaitForColor(X,Y,Color,Timeout)
                    
                    HelpButtonRatioX := 0.781
                    HelpButtonRatioY := 0.357
                    helpButtonGreyColor := 0x3A3837
                    
                    bHelpButtonGrey := ClickIfColor(HelpButtonRatioX, HelpButtonRatioY, helpButtonGreyColor)
                    
                    helpButtonClickCounter :=0
                    HelpClickX := getXCoord(HelpButtonRatioX)
                    HelpClickY := getYCoord(HelpButtonRatioY)
                    
                    lblog("Beginning while help click loop")
                    While !bHelpButtonGrey
                    {
                         ToolTip, Helped %helpButtonClickCounter% times, ToolTipX, ToolTipY, 1
                         
                         MouseClick, left, HelpClickX, HelpClickY
                         
                         Sleep, 1000 ;LET'S NOT BE TOO GREEDY ON FRACTIONS OF SECONDS :)
                         helpButtonClickCounter++
                         if(helpButtonClickCounter > 30)
                         {
                              lblog("helpButtonClickCounter exceeded limit")
                              break
                         }
                         
                         bHelpButtonGrey := ClickIfColor(HelpButtonRatioX, HelpButtonRatioY, helpButtonGreyColor)					
                    }
                    ToolTip, "AlliHelp Finished", HelpClickX, HelpClickY
               }
          }
     }
     lblog("End AlliHelp",0,2)
}