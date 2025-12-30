;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Programme - Pictionnary

		AREA    |.text|, CODE, READONLY
		ENTRY
        EXPORT  __main

        IMPORT  LEDS_INIT
        IMPORT  LEDS_BLINK
		IMPORT	LEDS_OFF
		IMPORT  LED_FRONT_RIGHT_ON
        IMPORT  LED_FRONT_RIGHT_OFF
		IMPORT  LED_FRONT_LEFT_ON
        IMPORT  LED_FRONT_LEFT_OFF
		IMPORT  LED_BACK_RIGHT_ON
        IMPORT  LED_BACK_RIGHT_OFF
		IMPORT  LED_BACK_LEFT_ON
        IMPORT  LED_BACK_LEFT_OFF
			
        IMPORT  SWITCH_INIT
        IMPORT  SWITCH_TOP
		IMPORT  SWITCH_BOTTOM
			
		IMPORT  BUMPER_INIT
        IMPORT  BUMPER_RIGHT
		IMPORT  BUMPER_LEFT
			
		IMPORT	MOTEUR_INIT
		IMPORT	MOTEUR_DROIT_ON
		IMPORT  MOTEUR_DROIT_OFF
		IMPORT  MOTEUR_DROIT_AVANT
		IMPORT  MOTEUR_DROIT_ARRIERE
		IMPORT	MOTEUR_GAUCHE_ON
		IMPORT  MOTEUR_GAUCHE_OFF
		IMPORT  MOTEUR_GAUCHE_AVANT
		IMPORT  MOTEUR_GAUCHE_ARRIERE
			
DUREE_LONG   			EQU     0x0028FFFF
LOOP_PAR_MS     		EQU     5000
MS_PAR_CM       		EQU     180
TEMPS_90_DROITE 		EQU     2300

__main
;;------------INITIALISATION-----------------
        bl LEDS_INIT
        bl SWITCH_INIT
        bl BUMPER_INIT
		bl MOTEUR_INIT

;;------------BOUCLE PRINCIPALE-----------------
main_loop
wait_press
        bl  SWITCH_TOP
        cmp r5, #0x00          ;; 0 = appuyé
        bne wait_press

;;------------CLIGNOTEMENT DEPART-----------------
        mov r4, #3
bl_blink_loop
        bl  LED_BACK_LEFT_ON
        ldr r0, =DUREE_LONG
bl_wait_on
        subs r0, #1
        bne bl_wait_on

        bl  LED_BACK_LEFT_OFF
        ldr r0, =DUREE_LONG
bl_wait_off
        subs r0, #1
        bne bl_wait_off

        subs r4, #1
        bne bl_blink_loop

;;------------DEPART SQUARE-----------------
        bl LED_BACK_LEFT_ON
        mov r4, #4	;nombre de cotes pour le carre

loop_square
        mov r0, #10
        bl  AVANCER_NCM
        bl  TOURNER_90_DROITE

        subs r4, r4, #1
        bne loop_square
		
;;------------CLIGNOTEMENT FIN-----------------
        mov r4, #3
bl_blink_loop_end
        bl  LED_BACK_LEFT_OFF
        ldr r0, =DUREE_LONG
bl_wait_on_end
        subs r0, #1
        bne bl_wait_on_end

        bl  LED_BACK_LEFT_ON
        ldr r0, =DUREE_LONG
bl_wait_off_end
        subs r0, #1
        bne bl_wait_off_end

        subs r4, #1
        bne bl_blink_loop_end
		bl LED_BACK_LEFT_OFF
		
		b main_loop
;;============================================================================
;; AVANCER_NCM
;;============================================================================
AVANCER_NCM
		mov r8, lr
        ldr r1, =MS_PAR_CM
        mul r2, r0, r1          ;; r2 = temps en ms

        ldr r3, =LOOP_PAR_MS
        mul r2, r2, r3          ;; r2 = nombre total de boucles

        bl  MOTEUR_DROIT_ON
        bl  MOTEUR_GAUCHE_ON
        bl  MOTEUR_DROIT_AVANT
        bl  MOTEUR_GAUCHE_AVANT

delay_avancer
        subs r2, r2, #1
        bne delay_avancer

        bl  MOTEUR_DROIT_OFF
        bl  MOTEUR_GAUCHE_OFF
		
		mov lr, r8
        bx  lr

;;============================================================================
;; TOURNER_90_DROITE
;;============================================================================
TOURNER_90_DROITE
		mov r8, lr
        ldr r0, =TEMPS_90_DROITE
        ldr r1, =LOOP_PAR_MS
        mul r2, r0, r1          ;; r2 = nombre de boucles

        bl  MOTEUR_GAUCHE_ON
        bl  MOTEUR_GAUCHE_AVANT

delay_tourner
        subs r2, r2, #1
        bne delay_tourner

        bl  MOTEUR_GAUCHE_OFF
		
		mov lr, r8
        bx  lr
		
		END