;; RK - Evalbot (Cortex M3 de Texas Instrument)
;; Programme - Drawing Shapes

;; definition des temps de rotations
TEMPS_90 				EQU     1950
TEMPS_108 				EQU     2360
TEMPS_36		 		EQU     780
TEMPS_45 				EQU     1000
TEMPS_80				EQU		2100
TEMPS_70				EQU		2000

		AREA    |.text|, CODE, READONLY
		
		EXPORT  SQUARE_DRAWING
		EXPORT  STAR_DRAWING
		EXPORT  TREE_DRAWING
		EXPORT  RIBBON_DRAWING

		IMPORT	AVANCER_NCM
		IMPORT	RECULER_NCM
		IMPORT  TOURNER_DROITE
		IMPORT  TOURNER_GAUCHE

;;------------SQUARE-----------------
SQUARE_DRAWING
		mov r9, lr	;sauvegarde du registre de lien
		mov r4, #4	;nombre de cotes pour le carre
loop_square
        mov r0, #20
        bl  AVANCER_NCM
		ldr r0, =TEMPS_90
        bl  TOURNER_DROITE
        subs r4, r4, #1
        bne loop_square
		mov lr, r9
		bx lr
		
;;------------STAR-----------------
STAR_DRAWING
		mov r9, lr ;sauvegarde du registre de lien
		mov r4, #5 ;nombre de branches pour l'etoile
loop_star
        mov r0, #10
        bl AVANCER_NCM
		ldr r0, =TEMPS_108
        bl TOURNER_DROITE
		mov r0, #10
		bl RECULER_NCM
		ldr r0, =TEMPS_36
		bl TOURNER_GAUCHE
        subs r4, r4, #1
        bne loop_star
		mov lr, r9
		bx lr

;;------------TREE-----------------
TREE_DRAWING
		mov r9, lr
        mov r0, #5
        bl AVANCER_NCM
		ldr r0, =TEMPS_80
        bl TOURNER_GAUCHE
		
        mov r4, #2

loop_tree_gauche
		mov r0, #10
		bl AVANCER_NCM
		ldr r0, =TEMPS_45
        bl TOURNER_GAUCHE
		mov r0, #15
		bl RECULER_NCM
		ldr r0, =TEMPS_45
        bl TOURNER_DROITE

        subs r4, r4, #1
        bne loop_tree_gauche
		
        mov r0, #5
        bl AVANCER_NCM
		ldr r0, =TEMPS_45
        bl TOURNER_GAUCHE
		mov r0, #15
		bl RECULER_NCM
		
		ldr r0, =TEMPS_70
		bl TOURNER_GAUCHE
		mov r0, #10
        bl AVANCER_NCM
		
		ldr r0, =TEMPS_45
        bl TOURNER_GAUCHE
		mov r0, #5
		bl RECULER_NCM
		
		mov r4, #2

loop_tree_droit
		ldr r0, =TEMPS_45
        bl TOURNER_DROITE
		mov r0, #15
		bl AVANCER_NCM
		
		ldr r0, =TEMPS_45
        bl TOURNER_GAUCHE
		mov r0, #10
		bl RECULER_NCM
		
        subs r4, r4, #1
        bne loop_tree_droit
	
		ldr r0, =TEMPS_70
		bl TOURNER_DROITE
		mov r0, #10
		bl AVANCER_NCM
		
		ldr r0, =TEMPS_70
		bl TOURNER_DROITE
		mov r0, #14
		bl AVANCER_NCM
		mov lr, r9
		bx lr

;;------------RIBBON-----------------
RIBBON_DRAWING
		mov r9, lr
		mov r0, #10
		bl AVANCER_NCM
		
        mov r4, #2
loop_left_loop
		ldr r0, =TEMPS_90
		bl TOURNER_DROITE
		mov r0, #10
		bl AVANCER_NCM
		subs r4, #1
		bne loop_left_loop
		
		ldr r0, =TEMPS_45
		bl TOURNER_DROITE
		mov r0, #10
		bl AVANCER_NCM
		ldr r0, =TEMPS_80
		bl TOURNER_GAUCHE
		mov r0, #10
		bl AVANCER_NCM
		ldr r0, =TEMPS_45
		bl TOURNER_DROITE
		
		mov r4, #2
loop_right_loop
		mov r0, #10
		bl AVANCER_NCM
		ldr r0, =TEMPS_90
		bl TOURNER_DROITE
		subs r4, #1
		bne loop_right_loop
		
		mov r0, #10
		bl AVANCER_NCM		
		ldr r0, =TEMPS_45
		bl TOURNER_DROITE
		mov r0, #13
		bl RECULER_NCM
		ldr r0, =TEMPS_45
		bl TOURNER_GAUCHE
		mov r0, #8
		bl AVANCER_NCM
		ldr r0, =TEMPS_80
		bl TOURNER_GAUCHE
		mov r0, #5
		bl AVANCER_NCM
		ldr r0, =TEMPS_45
		bl TOURNER_GAUCHE
		mov r0, #10
		bl RECULER_NCM
		
		ldr r0, =TEMPS_80
		bl TOURNER_DROITE
		mov r0, #10
		bl AVANCER_NCM
		ldr r0, =TEMPS_45
		bl TOURNER_GAUCHE
		mov r0, #5
		bl RECULER_NCM
		ldr r0, =TEMPS_80
		bl TOURNER_DROITE
		mov r0, #8
		bl AVANCER_NCM
		ldr r0, =TEMPS_45
		bl TOURNER_GAUCHE
		mov r0, #13
		bl RECULER_NCM
		mov lr, r9
		bx lr
		
		END