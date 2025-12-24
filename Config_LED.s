;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Fichier contenant l'initialisation des LEDs

		AREA    |.text|, CODE, READONLY

SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F
GPIO_O_DIR   		EQU 	0x00000400  ; GPIO Direction
GPIO_O_DR2R   		EQU 	0x00000500  ; GPIO 2-mA Drive Select
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up

; Broches
BROCHE4				EQU		0x10		; LED avant droite
BROCHE5				EQU		0x20		; LED avant gauche
BROCHE4_5			EQU		0x30		; LEDs avant
BROCHE2				EQU		0x04		; LED arrière gauche
BROCHE3				EQU		0x08		; LED arrière droite
BROCHE2_3			EQU		0x0C		; LEDs arrière
BROCHE2_3_4_5		EQU		0x3C		; LEDs
	
; Blinking Frequency
DUREE_SHORT   			EQU     0x0006FFFF
DUREE_LONG   			EQU     0x0028FFFF
		
;; The EXPORT command specifies that a symbol can be accessed by other shared objects or executables.
		EXPORT LEDS_INIT
		EXPORT LEDS_BLINK
		EXPORT LEDS_OFF
		EXPORT LED_FRONT_RIGHT_ON
		EXPORT LED_FRONT_RIGHT_OFF
		EXPORT LED_FRONT_LEFT_ON
		EXPORT LED_FRONT_LEFT_OFF
		EXPORT LED_BACK_RIGHT_ON
		EXPORT LED_BACK_RIGHT_OFF
		EXPORT LED_BACK_LEFT_ON
		EXPORT LED_BACK_LEFT_OFF
		EXPORT LED_BACK_LEFT_BLINK_3
			
;;------------INITIALISATION-----------------
LEDS_INIT

;; Enable the Port F peripheral clock
		ldr r1, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        ldr r0, [r1]
		ORR r0, r0, #0x00000020  				;; Enable clock on GPIO F with logic OR
        str r0, [r1]
		
;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop
		nop	   
		nop

;; LEDs configuration
        ldr r1, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 : 00010000)
        ldr r0, = BROCHE2_3_4_5 	
        str r0, [r1]
		
		ldr r1, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = BROCHE2_3_4_5		
        str r0, [r1]
		
		ldr r1, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        ldr r0, = BROCHE2_3_4_5	
        str r0, [r1]
		
		ldr r1, = GPIO_PORTF_BASE + (BROCHE2_3_4_5<<2)
		mov r0, #BROCHE2_3      				;; LEDS OFF
		str r0, [r1]							;; Eteint les lEDs
		
		BX LR

;;------------CLIGNOTEMENT-----------------
LEDS_BLINK
		mov r1, #BROCHE2_3      				;; LEDS OFF
		mov r2, #BROCHE4_5						;; LEDS ON
		ldr r3, = GPIO_PORTF_BASE + (BROCHE2_3_4_5<<2)
		
		str r2, [r3]
		ldr r0, =DUREE_SHORT
wait_on	
		subs r0, #1
        bne wait_on

        str r1, [r3]
        ldr r0, = DUREE_SHORT
wait_off
		subs r0, #1
        bne wait_off

        BX LR
		
;;------------LED AVANT DROITE-----------------
LED_FRONT_RIGHT_ON
        mov r0, #BROCHE4
		ldr r1, = GPIO_PORTF_BASE + (BROCHE4<<2)
        str r0, [r1]
        BX  LR
		
LED_FRONT_RIGHT_OFF
        mov r0, #0x00
		ldr r1, = GPIO_PORTF_BASE + (BROCHE4<<2)
        str r0, [r1]
        BX  LR
		
;;------------LED AVANT GAUCHE-----------------
LED_FRONT_LEFT_ON
        mov r0, #BROCHE5
		ldr r1, = GPIO_PORTF_BASE + (BROCHE5<<2)
        str r0, [r1]
        BX  LR
		
LED_FRONT_LEFT_OFF
        mov r0, #0x00
		ldr r1, = GPIO_PORTF_BASE + (BROCHE5<<2)
        str r0, [r1]
        BX  LR
		
;;------------LED ARRIERE DROITE-----------------
LED_BACK_RIGHT_ON
        mov r0, #0x00
		ldr r1, = GPIO_PORTF_BASE + (BROCHE3<<2)
        str r0, [r1]
        BX  LR
		
LED_BACK_RIGHT_OFF
        mov r0, #BROCHE3
		ldr r1, = GPIO_PORTF_BASE + (BROCHE3<<2)
        str r0, [r1]
        BX  LR
		
;;------------LED ARRIERE GAUCHE-----------------
LED_BACK_LEFT_ON
        mov r0, #0x00
		ldr r1, = GPIO_PORTF_BASE + (BROCHE2<<2)
        str r0, [r1]
        BX  LR
		
LED_BACK_LEFT_OFF
        mov r0, #BROCHE2
		ldr r1, = GPIO_PORTF_BASE + (BROCHE2<<2)
        str r0, [r1]
        BX  LR
		
LED_BACK_LEFT_BLINK_3
        mov r4, #3              ;; compteur de clignotements
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

        BX  LR


;;------------ETEINDRE----------------- 
LEDS_OFF
        mov r0, #BROCHE2_3
		ldr r1, = GPIO_PORTF_BASE + (BROCHE2_3_4_5<<2)
        str r0, [r1]
        BX  LR

		END