;*------------------------------------------------------------------------------
; メインルーチン
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _main
		; -------- Vblank終了待ち --------
		lda is_processing_main
		beq _main

		lda engine
		shl #1
		tax
		lda Engine::ENGINE_ADDR, x
		sta addr_tmp1+0
		lda Engine::ENGINE_ADDR+1, x
		sta addr_tmp1+1
		jmp (addr_tmp1)

.endproc
