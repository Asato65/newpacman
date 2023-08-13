;*------------------------------------------------------------------------------
; メイン関数
;*------------------------------------------------------------------------------

.proc MAIN
		lda #0
		sta isend_main

		jsr getJoyData

		; chr disp program
		; AB -> horizontal
		; 12 -> vertical
		; TODO: cycle count
		; addr AB       CD
		;       or
		; addr AB addr CD

		ldx #0
		stx ppu_update_data_pointer

		lda #%11111100					; horizontal
		sta PPU_UPDATE_DATA, x
		inx

		lda #$20
		sta PPU_UPDATE_DATA, x
		inx
		lda #$40
		sta PPU_UPDATE_DATA, x
		inx

		lda #'A'
		sta PPU_UPDATE_DATA, x
		inx
		lda #'B'
		sta PPU_UPDATE_DATA, x
		inx

		lda #%11111110					; vertical
		sta PPU_UPDATE_DATA, x
		inx

		lda #$22
		sta PPU_UPDATE_DATA, x
		inx
		lda #$80
		sta PPU_UPDATE_DATA, x
		inx

		lda #'1'
		sta PPU_UPDATE_DATA, x
		inx

		lda #'2'
		sta PPU_UPDATE_DATA, x
		inx

		; endcode

		; end main
		; TODO: check pointer overflow
		ldx ppu_update_data_pointer
		lda #PPU_END_CODE
		sta PPU_UPDATE_DATA, x
		inx

		lda #1
		sta isend_main

		jmp MAIN
.endproc