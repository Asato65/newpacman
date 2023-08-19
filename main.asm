;*------------------------------------------------------------------------------
; メイン関数
;*------------------------------------------------------------------------------

.proc MAIN
		lda is_processing_main
		beq MAIN

		jsr _getJoyData

		ldx #$00
		ldy #PPU_DATA_ARR_END - PPU_DATA_ARR
		stx ppu_update_data_pointer

@STORE_PPU_DATA_LOOP:
		lda PPU_DATA_ARR, x
		beq @END_STORE
		sta PPU_BUFF, x
		inx
		dey
		bne @STORE_PPU_DATA_LOOP
@END_STORE:
		stx ppu_update_data_pointer


		ldx ppu_update_data_pointer
@STR_LP:
		dex
		lda PPU_BUFF, x
		pha
		bne @STR_LP


		; endcode

		; ----- End main -----

		lda #0
		sta is_processing_main

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
