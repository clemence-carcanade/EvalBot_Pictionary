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
		IMPORT  LED_FRONT_RIGHT_BLINK
		IMPORT  LED_FRONT_LEFT_ON
        IMPORT  LED_FRONT_LEFT_OFF
		IMPORT  LED_FRONT_LEFT_BLINK
		IMPORT  LED_BACK_RIGHT_ON
        IMPORT  LED_BACK_RIGHT_OFF
		IMPORT  LED_BACK_RIGHT_BLINK
		IMPORT  LED_BACK_LEFT_ON
        IMPORT  LED_BACK_LEFT_OFF
		IMPORT  LED_BACK_LEFT_BLINK
			
        IMPORT  SWITCH_INIT
        IMPORT  SWITCH_TOP
		IMPORT  SWITCH_BOTTOM
			
		IMPORT  BUMPER_INIT
        IMPORT  BUMPER_RIGHT
		IMPORT  BUMPER_LEFT
			
		IMPORT	MOTEUR_INIT
			
		IMPORT  SQUARE_DRAWING
		IMPORT  STAR_DRAWING
		IMPORT  TREE_DRAWING
		IMPORT  RIBBON_DRAWING

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
        cmp r5, #0x00          ;; 0 = appuye
        beq square_start

		bl  SWITCH_BOTTOM
        cmp r6, #0x00
        beq ribbon_start
		
		bl BUMPER_RIGHT
		cmp r7, #0x00
		beq star_start
		
		bl BUMPER_LEFT
		cmp r8, #0x00
		beq tree_start
		
		b wait_press

;;------------SQUARE-----------------
square_start
		bl LED_BACK_LEFT_BLINK
        bl LED_BACK_LEFT_ON
		
		bl SQUARE_DRAWING

        bl LED_BACK_LEFT_BLINK
		b main_loop

;;------------STAR-----------------
star_start
		bl LED_FRONT_RIGHT_BLINK
        bl LED_FRONT_RIGHT_ON
		
		bl STAR_DRAWING
		
		bl LED_FRONT_RIGHT_BLINK
		b main_loop

;;------------TREE-----------------
tree_start
		bl LED_FRONT_LEFT_BLINK
        bl LED_FRONT_LEFT_ON
		
		bl TREE_DRAWING
		
		bl LED_FRONT_LEFT_BLINK
		b main_loop
		
;;------------RIBBON-----------------
ribbon_start
		bl LED_BACK_RIGHT_BLINK
		bl LED_BACK_RIGHT_ON

		bl RIBBON_DRAWING
		
		bl LED_BACK_RIGHT_BLINK		
		b main_loop
		
		END