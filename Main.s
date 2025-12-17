;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Programme - Pictionnary

		AREA    |.text|, CODE, READONLY
        EXPORT  main

        IMPORT  LEDS_INIT
        IMPORT  LEDS_BLINK
		IMPORT	LEDS_OFF
        IMPORT  SWITCH_INIT
        IMPORT  SWITCH_TOP

main
;;------------INITIALISATION-----------------
        bl  LEDS_INIT
        bl  SWITCH_INIT
		mov r9, #0x00		;; Etat du switch haut

;;------------SWITCH ACTIVE/DESACTIVE CLIGNOTEMENT-----------------
main_loop
        bl  SWITCH_TOP
        cmp r5, #0x00
		bne no_press
		
		eor r9, r9, #0x01	;; Changement de l'etat du switch haut
wait
		bl SWITCH_TOP
		cmp r5, #0x00
        beq wait
no_press
		cmp r9, #0x01
		beq start_blink
		
		bl LEDS_OFF
		b main_loop
start_blink
		bl LEDS_BLINK
		b main_loop
		
		NOP
		NOP
		END