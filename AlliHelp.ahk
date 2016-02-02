; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; AllianceHelp Module - clear those help requests and look more human
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

AlliHelp()
{
	global

	lblog("Begin AlliHelp",0,2)

  	; Look to see if main menu notifications exist (x: 0.193 y 0.074 color 0x000059)

	MainMenuHelpRatioX := 0.193
	MainMenuHelpRatioY := 0.074
	helpColor := 0x000059

	bMainHelpColorFound := ClickIfColor(MainMenuHelpRatioX, MainMenuHelpRatioY, helpColor)

	If(bMainHelpColorFound)
	{
		Sleep, 1000
		AllianceHelpRatioX := 0.416
		AllianceHelpRatioY := 0.163
		helpColor := 0x000059	
		
		bAllianceHelpColorFound := ClickIfColor(AllianceHelpRatioX, AllianceHelpRatioY, helpColor)
		
		If(bAllianceHelpColorFound)
		{
			Sleep, 6000
			HelpTabRatioX := 0.485
			HelpTabRatioY := 0.267
			helpColor := 0x000059

			bHelpTabColorFound := ClickIfColor(HelpTabRatioX, HelpTabRatioY, helpColor)

			If(bHelpTabColorFound)
			{
				; NOTE: in this section we look at the Help button to see if it's grey (otherwise it's a pulsing green)
				Sleep, 1000

				HelpButtonRatioX := 0.781
				HelpButtonRatioY := 0.353
				helpButtonGreyColor := 0x3A3837
	
				bHelpButtonGrey := ClickIfColor(HelpButtonRatioX, HelpButtonRatioY, helpButtonGreyColor)
				
				helpButtonClickCounter :=0
				lblog("Beginning while help click loop")
				While !bHelpButtonGrey a
				{
					lblog("Beginning while help click loop")
				
					HelpClickX := wLeft + wWidth * HelpButtonRatioX
					HelpClickY := wTop + wHeight * HelpButtonRatioY

					MouseMove, HelpClickX, HelpClickY
					Click %HelpClickX%, %HelpClickY%

					Sleep, 500
					helpButtonClickCounter++					
					if(helpButtonClickCounter > 50)
					{
						lblog("helpButtonClickCounter exceeded 50")
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