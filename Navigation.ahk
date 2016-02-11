; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; Navigation Module - One stop shop for getting around the menus
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

NavigateToScreen(Menu, Sub := "default", Subsub := "default")
{
	IF (Menu = "home")
	{
		; Navigate Home
	}
	Else If (Menu = "fight")
	{
		; Navigate to fight

		If (Sub = "default")
		{
			; return
		}
		Else If (Sub = "versus")	
		{
			; Navigate to versus
		}		
		Else If	(Sub = "story")
		{
			; Navigate to story
		}
		Else If	(Sub = "event")
		{
			; Navigate to event
		}
	}
	Else If (Menu = "alliance")
	{
		; Open main menu
		OpenMainMenu()
	    
		; Click on alliance button
	    	If (Sub = "Help")
		{
			; Navigate to Help
		}
	}
	Else If (Menu = "champions")
	{
		; Navigate to champions
	}
}

OpenMainMenu()
{
     ; Click main menu button to open ... if main menu already open click there anyways
     MainMenuRatioX = 0.193
     MainMenuRatioY = 0.075

     MouseClick, left, getXCoord(MainMenuRatioX), getYCoord(MainMenuRatioY), 1, 10

     ; not handled: messaging screen open
}