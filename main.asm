;*------------------------------------------------------------------------------
; MAIN routine
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		lda is_processing_main
		beq _main

		jsr Joypad::_getJoyData

		lda Joypad::joy1_pushstart
		and #Joypad::BTN_A
		beq @NO_PUSHED_BTN_A

		jsr DrawMap::_updateOneLine
@NO_PUSHED_BTN_A:
		lda Joypad::joy1
		and #Joypad::BTN_B
		beq @NO_PUSHED_BTN_B

		ldy #1
		jsr DrawMap::_changeStage
@NO_PUSHED_BTN_B:
		lda Joypad::joy1
		and #Joypad::BTN_R
		beq @NO_PUSHED_BTN_R

		jsr Func::_scroll

@NO_PUSHED_BTN_R:
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_U
		beq @NO_PUSHED_BTN_U

		inc scroll_amount

@NO_PUSHED_BTN_U:
		lda Joypad::joy1_pushstart
		and #Joypad::BTN_D
		beq @NO_PUSHED_BTN_D

		dec scroll_amount

@NO_PUSHED_BTN_D:


		; ----- End main -----
		lda #0
		sta is_processing_main
		jmp _main
		; ------------------------------
.endproc
