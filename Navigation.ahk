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
		MouseClick, left, getXCoord(0.416), getYCoord(0.161), 1, 10

		; In the case the user was already on the alliance tab, click the menu close button
		CloseMainMenu()

		;verify we're on Alliance page
		WaitForColor(0.06,0.5,0x302C2B,0) ; checks left margin for grey background (all other tabs are colorful)

	    	If (Sub = "Help")
		{
			; Click Help Tab
			MouseClick, left, getXCoord(0.484), getYCoord(0.268), 1, 10
		
			; verify we're on the Help Tab
			WaitForColor(0.225,0.34,0x302C2B,0) ;			
		}
	}
	Else If (Menu = "champions")
	{
		; Navigate to champions
	}
}

OpenMainMenu()
{
     MouseClick, left, getXCoord(0.193), getYCoord(0.075), 1, 10
     WaitForColor(0.166,0.075,0x272323,0) ; Checking menu background again to ensure loaded

     ; TODO: hanlde if the messaging screen open which covers entire screen and hides main menu button   
}
CloseMainMenu()
{
     MouseClick, left, getXCoord(0.144), getYCoord(0.334), 1, 10
}
