;********************************************************************************
; P R O G R A M M    Vorlage
;********************************************************************************
; Source-File:      	Lauflicht.a51
; Autor:            	Kay Wild, Christophe Damas, Mattia Müggler
; Datum:            	05.06.2021
; Version:            	2.0
; Beschreibung:        	Lauflicht
; Eingaben:            	8 Schalter S0 bis S7
; Ausgaben:            	8 LEDs PA0 bis PA7
;********************************************************************************
     
$TITLE (Lauflicht)
$NOLIST
$NOMOD51
$INCLUDE (C8051F020.h)                		            ;hier werden alle Bezeichnungen definiert
$LIST
 
NAME Lauflicht
 
;----- Deklarationen
input       equ     P3                    	            ; P3 8 Eingänge
output      equ     P2                   	            ; P2 8 Ausgänge
llStatus	data	20h						            ; ll -> LaufLichtStatus
dStatus		data	21h						            ; DirectionStatus -> bool-Variable die sagt, ob als letztes das Licht Vor- oder Rückwärts gegangen ist
fast		data	22h						            ; deklariert geschwindigkeit -> bool-Variable die entweder schnell oder langsam ist
 
;----- Intitialisierung
            ORG     0000h                	            ; Startadresse
            jmp     init                                ; geht zu init
 
            ORG     0100h                	            ; Programmanfang
init:  	    mov     WDTCN,#0DEh
            mov     WDTCN,#0ADh            	            ; deaktiviert Watchdog
       	    mov     P2MDOUT,#0FFh        	            ; P2 8 Ausgänge 
            mov     P3MDOUT,#000h        	            ; P3 8 Eingänge
            mov     XBR2,#040h            	            ; aktiviert crossbar (Koppelfeld)
 
;------ Hauptprogramm
main:       mov     output,#00h            	            ;LEDs ausschalten
		    mov     input, #00h
		    mov     A,#0h

;------ Schleife
loop:
            jnb		input.2, fastFalse
		    mov		fast, #6h					        ; noch ÄNDERN --> wert für Wait anpassen wenn schnell
		    jmp		fastEnd
            
fastFalse:
		    mov     fast, #60h;	 					    ; noch ÄNDERN --> wert für Wait anpassen wenn langsam

fastEnd:	
   
            jb      input.3, CBitBack ;Endlosschleife
		    jmp		CBit

;------ Licht anschalten Vorwärts
lightsUp: 
		    CALL 	compare
		    jnb		input.4, lightsUpTrue
		    rl		A
		    add 	A, #1h

;------ Licht anschalten Vorwärts Breit
lightsUpTrue:
		    rl		A
		    add 	A, #1h
		    mov		output, A
		    CALL 	wait
		    jmp		loop

;------ Licht ausschalten Vorwärts
lightsDown:	
		    CALL 	compare
		    jnb		input.4, lightsDownTrue
		    rl		A
		    subb 	A, #1h

;------ Licht ausschalten Vorwärts Breit
lightsDownTrue:
		    rl		A
		    subb 	A, #1h
		    mov		output, A
		    CALL 	wait
		    jmp		loop

;------ Licht anschalten Rückwärts
lightsUpBack: 
		    CALL 	compare
		    jnb		input.4, lightsUpBackTrue
		    add 	A, #1h
		    rr		A

;------ Licht anschalten Rückwärts Breit
lightsUpBackTrue:
		    add 	A, #1h
		    rr		A
		    mov		output, A
		    CALL 	wait
		    jmp		loop

;------ Licht ausschalten Rückwärts
lightsDownBack:	
		    CALL 	compare
		    jnb		input.4, lightsDownBackTrue
		    subb 	A, #1h 
		    rr		A

;------ Licht ausschalten Rückwärts Breit
lightsDownBackTrue:
		    subb 	A, #1h 
		    rr		A
		    mov		output, A
		    CALL 	wait
		    jmp		loop
 
;----- überprüft ob stop oder pasue gedrückt wurde
compare:           
            JB      input.0, compare
            JB      input.1, reset
            RET

;----- überprüft Richtung und wenn Schalter gedrückt geht zu CBitTrue (Wenn Vorwärts)
CBit:	
            jb		dStatus.0, CBitTrue
		    mov 	A, #0h
		    mov		dStatus, #1h

;----- Setzt neue Richtung (wenn Vorwärts)
CBitTrue:	
		    mov		llStatus, A
		    jb		llStatus.7, lightsDown
		    jmp 	lightsUp 

;----- überprüft Richtung und wenn Schalter gedrückt geht zu CBitBackTrue (Wenn Rückwärts)
CBitBack:	
            jnb     dStatus.0, CBitBackTrue
			mov 	A, #0h
			mov		dStatus, #0h
			
;----- Setzt neue Richtung (wenn Rückwärts)
CBitBackTrue:
			mov     llStatus, A
			jb      llStatus.0, lightsDownBack
			jmp	    lightsUpBack	 

;----- Start Delay
wait:       mov     R5, #0FFh		                    ; mit wait wird der Delay aufgerufen, und hier wird auf das Register verschiedene Werte gesetzt und Schleifen ineinander aufgerufen
wait1:      mov     R6, #0FFh
wait2:      mov     R7, #05h
wait3:	    mov     R4, fast			                ; noch ÄNDERN --> bei Mesa wait 4 wieder entfernen
wait4:      djnz    R4, wait4
		    djnz    R7, wait3
            djnz    R6, wait2
            djnz    R5, wait1
            ret

;----- Start Reset (Stop)
reset:      mov     output,#00h                         ; setzt die LEDs und den Akumulator zurück und geht wider in die Loop
		    mov	    A, #0h
		    jmp     loop
            END