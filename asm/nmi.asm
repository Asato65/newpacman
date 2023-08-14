;*------------------------------------------------------------------------------
; PPU_UPDATE_DATAを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Read PPU update data & store to PPU
; @PARAM ADDR forwarding address
; @BREAK A, X
; @RETURN void
;*------------------------------------------------------------------------------

.macro tfrDataToPPU ADDR
	lda PPU_UPDATE_DATA, x
	sta ADDR
	inx
.endmacro

; memo
; データ構造
; r: データの書き込みの方向 -> 0b111111[0/1]0 -> 0xFC（横方向）/0xFE（縦方向）
; e: エンドコード -> 0b11111111 -> 0xFF
; a: addr
; d: data
; r a a d d d ... d r a a d d ... d e


;*------------------------------------------------------------------------------
; NMI (Interrupt)
;*------------------------------------------------------------------------------

.proc NMI
		registerSave
		inc nmi_cnt
		lda isend_main
		beq @EXIT

		inc frm_cnt

		ldx #0
@SET_MODE:
		lda PPU_UPDATE_DATA, x
		cmp #PPU_END_CODE
		beq @EXIT
		bpl @SET_ADDR					; 0xff~0x7e => @SET_ADDR
		cmp #%11111100					; $fc
		bmi @SET_ADDR					; 0xfc~0xff = plus, 0x7c~0xfb => @SET_ADDR
		and #%00000010					; Get mode
		asl
		sta tmp1						; Start using tmp1
		lda ppu_ctrl1_cpy
		and #%11111011
		ora tmp1						; End using tmp1
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1					; Not use restorePPUSet()
@SET_ADDR:
		inx								; Not do inx when go to @EXIT
		lda PPU_UPDATE_DATA, x
		sta PPU_ADDR
		inx
		lda PPU_UPDATE_DATA, x
		sta PPU_ADDR
		inx
@STORE_DATA:
		lda PPU_UPDATE_DATA, x
		tay
		and #PPU_SP_CODE
		cmp #PPU_SP_CODE
		beq @SET_MODE					; no inx
		tya
		sta PPU_DATA
		inx
		bne @STORE_DATA

@EXIT:
		lda #0
		sta isend_main
		jsr _setScroll
		registerLoad
		rti	; --------------------------
.endproc
