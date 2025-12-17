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
BROCHE4				EQU		0x10		; LED avant gauche
BROCHE5				EQU		0x20		; LED avant droite
BROCHE4_5			EQU		0x30		; LEDs avant
BROCHE2				EQU		0x04		; LED arrière gauche
BROCHE3				EQU		0x08		; LED arrière droite
BROCHE2_3			EQU		0x0C		; LEDs arrière
BROCHE2_3_4_5		EQU		0x3C		; LEDs
	
; Blinking Frequency
DUREE   			EQU     0x0006FFFF
		
;; The EXPORT command specifies that a symbol can be accessed by other shared objects or executables.
		EXPORT LEDS_INIT
		EXPORT LEDS_BLINK
		EXPORT LEDS_OFF
			
;;------------INITIALISATION-----------------
LEDS_INIT

;; Enable the Port F peripheral clock
		ldr r4, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        ldr r0, [r4]
		ORR r0, r0, #0x00000020  				;; Enable clock on GPIO F with logic OR
        str r0, [r4]
		
;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop
		nop	   
		nop

;; LEDs configuration
        ldr r4, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 : 00010000)
        ldr r0, = BROCHE2_3_4_5 	
        str r0, [r4]
		
		ldr r4, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = BROCHE2_3_4_5		
        str r0, [r4]
		
		ldr r4, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        ldr r0, = BROCHE2_3_4_5	
        str r0, [r4]
		
		mov r2, #BROCHE2_3      				;; LEDS OFF
		
		ldr r4, = GPIO_PORTF_BASE + (BROCHE2_3_4_5<<2)
		str r2, [r4]
		
		BX LR

;;------------CLIGNOTEMENT-----------------
LEDS_BLINK
		str r3, [r4]
		ldr r1, =DUREE
wait_on	
		subs r1, #1
        bne wait_on

        str r2, [r4]
        ldr r1, = DUREE
wait_off
		subs r1, #1
        bne wait_off

        BX LR

;;------------ETEINDRE-----------------
LEDS_OFF
        mov r0, #BROCHE2_3
        str r0, [r4]
        BX  LR

		END