;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Fichier contenant l'initialisation des switchs

		AREA    |.text|, CODE, READONLY

SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R
GPIO_PORTD_BASE		EQU		0x40007000	; GPIO Port D
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up

; Broches
BROCHE6				EQU 	0x40		; Switch 1 Haut
BROCHE7				EQU		0x80		; Switch 2 Bas
BROCHE6_7			EQU		0xC0		; Switchs
	
;; The EXPORT command specifies that a symbol can be accessed by other shared objects or executables.
		EXPORT SWITCH_INIT
		EXPORT SWITCH_TOP
		EXPORT SWITCH_BOTTOM

;;------------INITIALISATION-----------------
SWITCH_INIT
		
;; Enable the Port D peripheral clock
	ldr r1, = SYSCTL_PERIPH_GPIO  			;; RCGC2
	ldr r0, [r1]  							;; Enable clock on GPIO D
	ORR r0, r0, #0x00000008					;; OU logique binaire pour additionner à l'horloge
	str r0, [r1]
	
;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
	nop
	nop	   
	nop

	ldr r1, = GPIO_PORTD_BASE+GPIO_I_PUR	;; Pull up
	ldr r0, = BROCHE6_7	
	str r0, [r1]
	
	ldr r1, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
	ldr r0, = BROCHE6_7
	str r0, [r1]
	
	ldr r1, = GPIO_PORTD_BASE + (BROCHE6_7<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	
	BX LR

;;------------LECTURE SWITH HAUT-----------------
SWITCH_TOP
    ldr r1, = GPIO_PORTD_BASE + (BROCHE6<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r5, [r1]
	cmp r5,#0x00
	BX LR
		
;;------------LECTURE SWITH BAS-----------------
SWITCH_BOTTOM
    ldr r1, = GPIO_PORTD_BASE + (BROCHE7<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r6, [r1]
	cmp r6,#0x00
	BX LR
	
	END
		