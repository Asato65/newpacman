;*------------------------------------------------------------------------------
; MAIN routine
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		lda is_processing_main
		beq _main

		jsr Joypad::_getJoyData

		lda joy1_pushstart
		and #BTN_A
		beq @NO_PUSHED_BTN_A

		jsr DrawMap::_updateOneLine
@NO_PUSHED_BTN_A:

		; ----- End main -----
		lda #0
		sta is_processing_main
		jmp _main
.endproc
