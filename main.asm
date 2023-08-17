;*------------------------------------------------------------------------------
; メイン関数
;*------------------------------------------------------------------------------

.proc MAIN
		lda isend_main
		bne MAIN

		jsr _getJoyData

		ldx #5
		add x, #5
		stx $80


		ldx #0
		ldy #PPU_DATA_ARR_END - PPU_DATA_ARR
		stx ppu_update_data_pointer

@STORE_PPU_DATA_LOOP:
		lda PPU_DATA_ARR, x
		beq @END_STORE
		sta PPU_UPDATE_DATA, x
		inx
		dey
		bne @STORE_PPU_DATA_LOOP
@END_STORE:
		stx ppu_update_data_pointer



		; endcode

		; ----- End main -----
		ldx ppu_update_data_pointer
		lda #PPU_END_CODE
		sta PPU_UPDATE_DATA, x
		inx

		lda #1
		sta isend_main

		jmp MAIN
.endproc


PPU_DATA_ARR:
		.byte %11111110					; horizontal
		.dbyt $2043						; dbyt=Define BYTe?: Define word data with the hi & lo bytes swapped.($1234=$12,$34)
		.byte "ABC"
		.byte %11111111					; vertical
		.dbyt $2280
		.byte "123456789A"
PPU_DATA_ARR_END:
