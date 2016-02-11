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
          ; Open main menu
          OpenMainMenu()
          
          ; Click on Fight button
          MouseClick, left, getXCoord(0.270), getYCoord(0.199), 1, 10
          
          ; In the case the user was already on the alliance tab, click the menu close button
          CloseMainMenu()     
          
          ; verify we're on the Fight page
          WaitForColor(0.304,0.466,0x005C02,0) ; green view quests button ... TODO: find a better verification.
          
          If (Sub = "default")
          {
               return
          }
          Else If (Sub = "versus")	
          {
               ; Click Versus Box
               MouseClick, left, getXCoord(0.575), getYCoord(0.440), 1, 10
               
               ; verify we're on the Versus page
               WaitForColor(0.285,0.143,0xAD782C,0) ; light blue background behind 'multiverse arenas' ... TODO: find a better verification.
          }		
          Else If	(Sub = "story")
          {
               ; Click Story Box
               MouseClick, left, getXCoord(0.290), getYCoord(0.337), 1, 10
               
               ; verify we're on the Story page
               ; WaitForColor(0.###,0.###,0x######,0) ; TODO: verification. // probably should try OCR on title
               
               ; TODO: eventually find a path to 3.4.1 for xp/gold farming via auto quest
          }
          Else If	(Sub = "event")
          {
               ; Click Event Box
               MouseClick, left, getXCoord(0.290), getYCoord(0.681), 1, 10
               
               ; verify we're on the Events page
               ; WaitForColor(0.###,0.###,0x######,0) ; TODO: verification. // probably should try OCR on title
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


