																							   ;********************************************************************************
; P R O G R A M M    Vorlage
;********************************************************************************
; Source-File:      	Lauflicht.a51
; Autor:            	Kay Wild, Christophe Damas, Mattia Müggler
; Datum:            	05.06.2021
; Version:            	1.0
; Beschreibung:        	Lauflicht
; Eingaben:            	8 Schalter S0 bis S7
; Ausgaben:            	8 LEDs PA0 bis PA7
;********************************************************************************
     
$TITLE (Lauflicht)
$NOLIST
$NOMOD51
$INCLUDE (C8051F020.h)                		;hier werden alle Bezeichnungen definiert
$LIST
 
NAME Lauflicht
 
;----- Deklarationen
input    equ        P2                    	;P3 8 Eingänge
output   equ        P3                   	;P2 8 Ausgänge
 
;----- Intitialisierung
        ORG        0000h                	;Startadresse
        jmp        init
 
        ORG        	0100h                	;Programmanfang
init:  	mov        	WDTCN,#0DEh
        mov        	WDTCN,#0ADh            	;disable Watchdog
       	mov        	P2MDOUT,#0FFh        	;P2 8 Ausgänge push/pull
        mov        	P3MDOUT,#000h        	;P3 8 Eingänge
        mov        	XBR2,#040h            	;enable crossbar (Koppelfeld)
		mov 		bp, 43690
		mov 		si, 43690
 
;------ Hauptprogramm
main:   mov        output,#00h            	;LEDs dunkel schalten
 
loop:   mov        A,input                	;Schalter einlesen
        
        CJNE    	A, #00000001b, loop
        jmp        	lights                ;Endlosschleife

lights: mov  		output,#00000001b
        CALL    CMPR
		CALL	delay1
        mov        output,#00000011b
        CALL    CMPR
		CALL	delay1
        mov        output,#00000111b
        CALL    CMPR
		CALL	delay1
        mov        output,#00001111b
        CALL    CMPR
		CALL	delay1
        mov        output,#00011111b
        CALL    CMPR
		CALL	delay1
        mov        output,#00111111b
        CALL    CMPR
		CALL	delay1
        mov        output,#01111111b
        CALL    CMPR
		CALL	delay1
        mov        output,#11111111b
        CALL    CMPR
		CALL	delay1
        mov        output,#11111110b
        CALL    CMPR
		CALL	delay1
        mov        output,#11111100b
        CALL    CMPR
		CALL	delay1
        mov        output,#11111000b
        CALL    CMPR
		CALL	delay1
        mov        output,#11110000b
        CALL    CMPR
		CALL	delay1
        mov        output,#11100000b
        CALL    CMPR
		CALL	delay1
        mov        output,#11000000b
        CALL    CMPR
		CALL	delay1
        mov        output,#10000000b
        CALL    CMPR
		CALL	delay1
        mov        output,#00000000b
        CALL    CMPR
		CALL	delay1
        jmp        lights
 
; überprüft ob stop oder pasue gedrückt wurde
CMPR:    
        mov        	R1, input        
        JB        	input.0, pause
        JB        	input.1, stop 
        RET
        
pause:  JB        	input.0, CMPR
       	JMP        	pause                
 
stop:   JMP    		main
        END

; start delay

delay1: MOV R5,#521D
label: ACALL delay
       ACALL delay
       ACALL delay
       ACALL delay
       DJNZ R5,label
       RET
delay: MOV R6,#250D
       MOV R7,#250D
loop1: DJNZ R6,loop1
loop2: DJNZ R7,loop1
       RET
			