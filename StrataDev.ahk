; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
; BRAINS GO HERE
; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

StrataDev() {
     global
     
     ; IS THE FIGHT OVER?
     If (DoActions = 0) {
          ; IT DOESN'T ALWAYS WORK RIGHT WITH THE FIRST TAP SO WE HAVE TWO
          Sleep, 500
          MouseClick, left, ContinueButtonX, ContinueButtonY
          Sleep, 250
          MouseClick, left, ContinueButtonX, ContinueButtonY
     }
     
     ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
     ;  TIME
     ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
     
     ; How much time this cycle took
     CycleTime := A_TickCount - CycleOld
     CycleOld := A_TickCount
     
     ; How much time in this fight total & converted to seconds
     CycleSum += CycleTime
     CycleSec := Round(CycleSum/1000)
     
     ; Average cycle time
     AvgCycle := Round(CycleSum/Cycles)
     
     ; DYNAMIC ACTION RESPONSE RATIO - RESPONSIBLE FOR SMOOTH COMBOS AND ESCAPING DANGER AT THE RIGHT MOMENT
     DynaRatio := Round(AvgCycle/100,2)
     
     Cycles++
     
     ; APPROXIMATION OF AN END OF A COMBO
     SwipeLimit := 1666/AvgCycle
     
     ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
     ;  ANALYZE WHAT BATTLESCAN GAVE US
     ; =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
     
     ; BATTLESCAN GIVES:
     ; WeHaveASpecial	0: Nothing, >0: L1, >10: L2, >100:L3
     ; TheyHaveASpecial	0: Nothing, >0: L1, >10: L2, >100:L3
     ; TheirDmg 		Amount our health changed within the last cycle
     ; OurDmg 			Amount their health changed within the last cycle
     
     ; SPECIALS
     ; ========
     
     Emergency:
     
     ; IF A SPECIAL EVADE IS ACTIVE NOTHING ELSE MATTERS - JUST EVADE UNTIL WE CONSIDER IT SAFE
     If (SpecialEvade < 1) {
          Action := SpecialEvade
          Evade := SpecialEvade
          SpecialEvade += 1
          Return
     }
     
     ; Have they launched a special?
     If (TheyHadASpecial > 0) && (TheyHaveASpecial = 0) {
          SpecialEvade := Round(-30/DynaRatio)
          TheyHadASpecial := TheyHaveASpecial
          Strategy = EVADE SPECIAL!
          Goto Emergency
     }
     
     ; WE SAVE THE SPECIAL STATE FOR COMPARISON ON NEXT CYCLE
     ; IF IT WAS FULL AND NOW ISN'T THAT MEANS THEY HAVE LAUNCHED A SPECIAL
     TheyHadASpecial := TheyHaveASpecial
     
     ; Have we launched a special?
     If (WeHadASpecial > 0) && (WeHaveASpecial = 0) {
          SpecialEvade := Round(-30/DynaRatio)
          WeHadASpecial := WeHaveASpecial
          Strategy = SPECIAL!
          Goto Emergency
     }
     
     ; WE SAVE THE SPECIAL STATE FOR COMPARISON ON NEXT CYCLE
     ; IF IT WAS FULL AND NOW ISN'T THAT MEANS WE HAVE LAUNCHED A SPECIAL
     ; WHY LIKE THIS AND NOT FROM ACTIONS? BECAUSE IT DOESN'T TRIGGER 100%
     WeHadASpecial := WeHaveASpecial
     
     ; If we have a L3 special - launch it!
     If (WeHaveASpecial > 100) {
          Strategy = L3 SPECIAL!
          Action = 123
          Return
     }
     
    ; If we have a L3 special - launch it!
	;If (WeHaveASpecial > 100) {
	;	Strategy = L3 SPECIAL!
	;	Action = 123
	;	Return
	; If we are hurting and get any special - launch it!
	;} Else If (OurHealth < 40) && (WeHaveASpecial > 0) {
	;	Strategy = SPECIAL!
	;	Action = 123
	;	Return
	; If we get a L2 and are doing okay - launch it!
	;} Else If (OurHealth < 75) && (WeHaveASpecial > 10) {
	;	Strategy = SPECIAL!
	;	Action = 123
	;	Return
	;}
     
     ; DAMAGE
     ; ======
     
     ; IF WE ARE TAKING DAMAGE EVADE - 2% SEEMS TO BE A GOOD SPOT TO ACCOUNT FOR POSSIBLE
     ; WP HEALTH JUMPS, ETC
     If (TheirDmg > 2){
          ComboFrenzy = 0
          OurDmg = 0
          Strategy = Evading damage
          Action := Round(-6/DynaRatio)
          Return
     }
     
     ; IF WE ARE NOT TAKING DAMAGE AND DEALT A DECENT AMOUNT PREVIOUSLY THEN GO FOR COMBO
     If (ComboFrenzy > 0){
          Action++
          ComboFrenzy =- DynaRatio
          Strategy = Combo frenzy!
          Return
     }
     
     ; SEE IF WE ARE DOING DAMAGE
     If (OurDmg > 0 && OurDmg < 10) {
          
          ; UPDATE MIN AND MAX HIT DAMAGE FOR AVERAGES
          If (OurDmg < HMin) or (HMin = 0)
          HMin := OurDmg
          If (OurDmg > HMax)
          HMax := OurDmg
          
          ; HIT COUNT
          HCount++
          
          ; THIS IS IMPORANT - THIS IS THE SPOT WHERE WE DECIDE IF OUR HITS ARE DOING ENOUGH DAMAGE
          ; WHETHER WE ARE HITTING A BLOCK OR DOING REAL DAMAGE
          ; IT IS AFFECTED BY MASTERIES AND POSSIBLY OTHER THINGS SO YOU ADJUST IT BY EYE
          ; CURRENT DEFAULT IS
          ;
          ; HAvg := Round(HMax*0.25,1)
          ;
          ; IF YOUR CHAMPIONS ARE RETREATING AFTER A GOOD HIT YOU NEED TO MAKE IT LOWER
          ; IF THEY ARE SMASHING BLOCKS THEN YOU NEED TO MAKE IT HIGHER. EXPERIMENT BY ADJUSTING
          ; IT BY 0.3 OR SO UP OR DOWN TO FIND THE SWEET SPOT
          
          HAvg := Round(HMax*0.25,1)
          DamageLevel := HAvg
     }
     
     ; IF WE ARE DEALING DAMAGE KEEP AT IT, IF NOT BE CAUTIOS
     If (OurDmg > DamageLevel) {
          ComboFrenzy := (SwipeLimit - Action) ;INITIATE COMBO FRENZY
          If (Action < 2)
          Action = 2
          Strategy = Attacking
          Return
     } Else {
          ; NOT SURE THIS EVEN DOES ANYTHING NOW THAT COMBO FRENZY IS IN :)
          NoDmg += DynaRatio
     }
     
     ; EITHER COMBO IS DONE OR WE ARE SMASHING A BLOCK - RETREAT!
     If (Action > SwipeLimit or NoDmg > 5) {
          Strategy = Being cautios
          Action := Round(-4/DynaRatio)
          NoDmg := Round(-4/DynaRatio)
     }
     
     ; IF NOTHING ELSE JUST KEEP THINGS GOING TOWARDS AN ATTACK
     If (Action < 1)
     Action++
}