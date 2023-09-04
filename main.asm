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
		ldy #0
		jsr _setStageAddr
		ldy #0
		jsr _setMapAddr
		jsr _drawMap
@SKIP1:

		; ----- End main -----

		lda #0
		sta is_processing_main
		jmp MAIN
.endproc
