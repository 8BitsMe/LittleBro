; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; LINE messaging and reporting 
;	     *newline* is optional, if set to "newline" it will input shift+Enter to allow for another message to be inputted in the next line
;	     **TODO: find a way to parse newlines in message and replace them with the right newline input.
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

WriteToLINE(message, newline := "no")
{
     global

     ControlSend, , %message%, LBLINE

     If (newline = "newline")
     {
	 ControlSend, , +{Enter}, LBLINE
     }
     Else
     {
         ControlSend, , {Enter}, LBLINE
     }
}

LineReport(message:="", report:="")
{
     global
     WriteToLINE(report . " REPORT", "newline")
     WriteToLINE(message)
}
LineAlert(message)
{
     global
     WriteToLINE("*******ALERT*******", "newline")    
     WriteToLINE(message)
}