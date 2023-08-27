;*------------------------------------------------------------------------------
; MAIN routine
;*------------------------------------------------------------------------------

.proc MAIN
		lda is_processing_main
		beq MAIN

		jsr _getJoyData

		lda joy1_pushstart
		and #BTN_A
		beq @SKIP1
		lda $80
		sta bg_buff_pointer
@SKIP1:
		lda joy1_pushstart
		and #BTN_B
		beq @SKIP2
		jsr _disp_status
@SKIP2:

		; ----- End main -----

		lda #0
		sta is_processing_main
		jmp MAIN
.endproc
