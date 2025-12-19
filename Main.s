;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Programme - Pictionnary
		AREA    |.text|, CODE, READONLY
		ENTRY
		
        EXPORT  __main
        IMPORT  LEDS_INIT
        IMPORT  LEDS_BLINK
		IMPORT	LEDS_OFF
        IMPORT  SWITCH_INIT
        IMPORT  SWITCH_TOP
		IMPORT	MOTEUR_INIT
		IMPORT	MOTEUR_DROIT_ON
		IMPORT  MOTEUR_DROIT_OFF
		IMPORT  MOTEUR_DROIT_AVANT
		IMPORT  MOTEUR_DROIT_ARRIERE
		IMPORT	MOTEUR_GAUCHE_ON
		IMPORT  MOTEUR_GAUCHE_OFF
		IMPORT  MOTEUR_GAUCHE_AVANT
		IMPORT  MOTEUR_GAUCHE_ARRIERE

MS_PAR_CM EQU 300

__main
;;------------INITIALISATION-----------------
        bl  LEDS_INIT
        bl  SWITCH_INIT
		bl  MOTEUR_INIT
		
		;; === TEST DIAGNOSTIC : Décommentez pour tester ===
		;; bl TEST_ROTATION
		
		mov r9, #0x00
		
		;;Configurer un registre qui retient 4 (nombre de fois que la fonction devra tourner)
		;;Configurer un index qui augmente
		;;Comparer si c'est égal à 4 sinon continuer
		;;Ajouter un à l'index

;;------------BOUCLE PRINCIPALE-----------------
main_loop
        bl  SWITCH_TOP
        cmp r5, #0x00
		bne no_press
		
		eor r9, r9, #0x01
		
		cmp r9, #0x01
		bne wait
		
		;; ===== CORRECTION : Un seul appel =====
		bl  DESSINER_MAISON
		
wait
		bl  SWITCH_TOP
		cmp r5, #0x00
        beq wait
		
no_press
		cmp r9, #0x01
		beq start_blink
		
		bl  LEDS_OFF
		b   main_loop
		
start_blink
		bl  LEDS_BLINK
		b   main_loop

;;============================================================================
;; DESSINER_MAISON
;;============================================================================
DESSINER_MAISON
		PUSH {R4, LR}				; Sauvegarder
		
		MOV R4, #3
		
BOUCLE_MAISON
		CMP R4, #0
		BEQ BOUCLE_TOIT				; Si fini, sortir
		
		MOV R0, #10
		BL AVANCER_NCM
		
		BL TOURNER_90_DROITE
		
		SUB R4, R4, #1
		B BOUCLE_MAISON

BOUCLE_TOIT
	MOV R0, #10
	BL AVANCER_NCM
		
	BL TOURNER_45_DROITE
	
	MOV R0, #10
	BL AVANCER_NCM
	
	
	BL TOURNER_90_DROITE
	MOV R0, #10
	BL AVANCER_NCM
	
	BL FIN_MAISON
	
FIN_MAISON							; ? FIN_CARRE est ICI !
		POP {R4, PC}				; ? POP est ICI !

;;============================================================================
;; AVANCER_NCM
;;============================================================================
AVANCER_NCM
		PUSH {R0-R3, LR}
		
		LDR R1, =MS_PAR_CM
		MUL R2, R0, R1
		
		BL MOTEUR_DROIT_ON
		BL MOTEUR_GAUCHE_ON
		BL MOTEUR_DROIT_AVANT
		BL MOTEUR_GAUCHE_AVANT
		
		MOV R0, R2
		BL DELAY_MS
		
		BL MOTEUR_DROIT_OFF
		BL MOTEUR_GAUCHE_OFF
		
		POP {R0-R3, PC}

;;============================================================================
;; DELAY_MS
;;============================================================================
DELAY_MS
		PUSH {R0-R2, LR}
		
		MOV R2, R0
		
BOUCLE_MS
		CMP R2, #0
		BEQ FIN_DELAY
		
		LDR R1, =5000
BOUCLE_1MS
		SUBS R1, R1, #1
		BNE BOUCLE_1MS
		
		SUBS R2, R2, #1
		B BOUCLE_MS
		
FIN_DELAY
		POP {R0-R2, PC}

;;============================================================================
;; TOURNER_90_DROITE
;;============================================================================
TOURNER_90_DROITE
		PUSH {R0, LR}
		
		BL MOTEUR_GAUCHE_ON
		BL MOTEUR_GAUCHE_AVANT
		
		mov r0, #2500
		bl  DELAY_MS
		
		BL MOTEUR_GAUCHE_OFF
		
		POP {R0, PC}
		
;;============================================================================
;; TOURNER_125_DROITE
;;============================================================================
TOURNER_45_DROITE
		PUSH {R0, LR}
		
		BL MOTEUR_GAUCHE_ON
		BL MOTEUR_GAUCHE_AVANT
		
		mov r0, #1150
		bl  DELAY_MS
		
		BL MOTEUR_GAUCHE_OFF
		
		POP {R0, PC}

		END