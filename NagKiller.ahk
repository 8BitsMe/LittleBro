; CLOSES STUPID TEAMVIEWER WINDOWS THAT GET IN THE WAY OF COLOR DETECTION
; Feel free to add whatever you may need closed/disabled/hiddent to not interfere with LB

NagKiller() {
     IfWinExist, Sponsored session
     {
          ControlClick, OK
          WinClose, Sponsored session
     }
}