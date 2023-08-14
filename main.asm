;*------------------------------------------------------------------------------
; メイン関数
;*------------------------------------------------------------------------------

.proc MAIN
		lda isend_main
		bne MAIN

		jsr _getJoyData

		ldx #0
		stx ppu_update_data_pointer

@STORE_PPU_DATA_LOOP:
		lda PPU_DATA_ARR, x
		cmp #$ff
		beq @END_STORE
		sta PPU_UPDATE_DATA, x
		inx
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
		.byte %11111100					; horizontal
		.dbyt $2040						; dbyt = Define BYTe?: Define word sized data with the hi and lo bytes swapped. ($1234 = $12, $34)
		.byte "ABC"
		.byte %11111110					; vertical
		.dbyt $2280
		.byte "123"
		.byte $ff						; loop end code
