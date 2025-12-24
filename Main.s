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
		IMPORT  SWITCH_BOTTOM
		IMPORT  BUMPER_INIT
        IMPORT  BUMPER_RIGHT
		IMPORT  BUMPER_LEFT
        IMPORT  LED_FRONT_RIGHT_ON
        IMPORT  LED_FRONT_RIGHT_OFF
		IMPORT  LED_FRONT_LEFT_ON
        IMPORT  LED_FRONT_LEFT_OFF
		IMPORT  LED_BACK_RIGHT_ON
        IMPORT  LED_BACK_RIGHT_OFF
		IMPORT  LED_BACK_LEFT_ON
        IMPORT  LED_BACK_LEFT_OFF
		IMPORT  LED_BACK_LEFT_BLINK_3

__main
;;------------INITIALISATION-----------------
        bl  LEDS_INIT
        bl  SWITCH_INIT
        bl  BUMPER_INIT

        mov r9,  #0x00     ;; état switch haut
        mov r10, #0x00     ;; état switch bas
        mov r11, #0x00     ;; état bumper droit
        mov r12, #0x00     ;; état bumper gauche

;;------------BOUCLE PRINCIPALE-----------------
main_loop

;;================ BUMPER GAUCHE =================
        bl  BUMPER_LEFT
        cmp r8, #0x00
        bne check_bumper_right

        eor r12, r12, #0x01

wait_bumper_left_release
        bl  BUMPER_LEFT
        cmp r8, #0x00
        beq wait_bumper_left_release

;;================ BUMPER DROIT =================
check_bumper_right
        bl  BUMPER_RIGHT
        cmp r7, #0x00
        bne check_switch_top

        eor r11, r11, #0x01

wait_bumper_right_release
        bl  BUMPER_RIGHT
        cmp r7, #0x00
        beq wait_bumper_right_release

;;================ SWITCH HAUT =================
check_switch_top
        bl  SWITCH_TOP
        cmp r5, #0x00
        bne check_switch_bottom

        eor r9, r9, #0x01

wait_switch_top_release
        bl  SWITCH_TOP
        cmp r5, #0x00
        beq wait_switch_top_release
		
;;================ SWITCH BAS =================
check_switch_bottom
        bl  SWITCH_BOTTOM
        cmp r6, #0x00
        bne apply_states

        eor r10, r10, #0x01

wait_switch_bottom_release
        bl  SWITCH_BOTTOM
        cmp r6, #0x00
        beq wait_switch_bottom_release

;;================ SORTIES =================
apply_states

        ;;================ LED AVANT GAUCHE =================
        cmp r12, #0x01
        bne fl_off
        bl  LED_FRONT_LEFT_ON
        b   fl_done
fl_off
        bl  LED_FRONT_LEFT_OFF
fl_done

        ;;================ LED AVANT DROITE =================
        cmp r11, #0x01
        bne fr_off
        bl  LED_FRONT_RIGHT_ON
        b   fr_done
fr_off
        bl  LED_FRONT_RIGHT_OFF
fr_done

		;;================ LED ARRIÈRE GAUCHE =================
        cmp r9, #0x01
		bne bl_off
        bl  LED_BACK_LEFT_ON
        b   bl_done
bl_off
        bl  LED_BACK_LEFT_OFF
bl_done

        ;;================ LED ARRIÈRE DROITE =================
        cmp r10, #0x01
        bne br_off
        bl  LED_BACK_RIGHT_ON
        b   br_done
br_off
        bl  LED_BACK_RIGHT_OFF
br_done

        b   main_loop
		
		NOP
		NOP
		END