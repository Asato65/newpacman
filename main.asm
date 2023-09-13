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

		jsr _drawMap
@SKIP1:

		; ----- End main -----

		lda #0
		sta is_processing_main
		jmp MAIN
.endproc
