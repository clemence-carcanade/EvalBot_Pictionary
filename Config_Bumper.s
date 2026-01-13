;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Fichier contenant l'initialisation des bumpers

		AREA    |.text|, CODE, READONLY

SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R
GPIO_PORTE_BASE		EQU		0x40024000	; GPIO Port E
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up

; Broches
BROCHE0				EQU 	0x01		; Bumper Droit
BROCHE1				EQU		0x02		; Bumper Gauche
BROCHE0_1			EQU		0x03		; Bumpers
	
;; The EXPORT command specifies that a symbol can be accessed by other shared objects or executables.
		EXPORT BUMPER_INIT
		EXPORT BUMPER_RIGHT
		EXPORT BUMPER_LEFT
			
;;------------INITIALISATION-----------------
BUMPER_INIT
		
;; Enable the Port E peripheral clock
	ldr r1, = SYSCTL_PERIPH_GPIO  			;; RCGC2
	ldr r0, [r1]  							;; Enable clock on GPIO E
	ORR r0, r0, #0x00000010					;; OU logique binaire pour additionner à l'horloge
	str r0, [r1]
	
;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
	nop
	nop	   
	nop

	ldr r1, = GPIO_PORTE_BASE+GPIO_I_PUR	;; Pull up
	ldr r0, = BROCHE0_1
	str r0, [r1]
	
	ldr r1, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
	ldr r0, = BROCHE0_1
	str r0, [r1]
	
	ldr r1, = GPIO_PORTE_BASE + (BROCHE0_1<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	
	BX LR
	
;;------------LECTURE BUMPER RIGHT-----------------
BUMPER_RIGHT
    ldr r1, = GPIO_PORTE_BASE + (BROCHE0<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r7, [r1]
	cmp r7,#0x00
	BX LR
		
;;------------LECTURE BUMPER LEFT-----------------
BUMPER_LEFT
    ldr r1, = GPIO_PORTE_BASE + (BROCHE1<<2)  ;; @data Register = @base + (mask<<2) ==> Switch
	LDR r8, [r1]
	cmp r8,#0x00
	BX LR
	
	END