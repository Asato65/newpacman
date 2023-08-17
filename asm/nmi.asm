;*------------------------------------------------------------------------------
; PPU_UPDATE_DATAを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Read PPU update data & store to PPU
; @PARAM	ADDR: Forwarding address
; @BREAK	A X
; @RETURN	None
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
; @BREAK X Y (When end main process.)
;*------------------------------------------------------------------------------

.proc NMI
		php
		pha
		inc nmi_cnt
		lda isend_main
		beq @EXIT

		inc frm_cnt

		ldx #0
		cpx ppu_update_data_pointer
		beq @EXIT
@SET_MODE:
		lda PPU_UPDATE_DATA, x
		bpl @SET_ADDR					; 0x00~0x7f => @SET_ADDR
		cmp #%11111110
		bmi @SET_ADDR					; 0xfe~0xff = plus, 0x7e~0xfd => @SET_ADDR
		and #%00000001					; Get mode
		asl
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
		and #%11111110
		cmp #%11111110
		beq @SET_MODE					; no inx
		tya
		sta PPU_DATA
		inx
		cpx ppu_update_data_pointer
		bne @STORE_DATA

		; @SET_MODE + @SET_ADDR = 51 cycle
		; @STORE_DATA (return @STORE_DATA) = 24 cycle
		; @STORE_DATA (return @SET_MODE) = 13 cycle

		; str1 = "A  B"
		; => 51 + space_len * 24 cycle
		; => mode(1) + addr(2) + data(2 + space_len) = (5 + space_len) bytes
		; |  len  || 1  | 2  |  3  |  4  |
		; | cycle || 75 | 99 | 123 | 147 |
		; str2 = 'A', str3 = 'B'
		; => (51 + 13) * 2 = 64 * 2 = 128 cycle
		; => (mode(1) + addr(2) + data(1)) * 2 = 8 bytes
		; space length:
		; 1: 75 cycle,	6 bytes (str1)
		; 2: 99 cycle,	7 bytes
		; 3: 123 cycle,	8 bytes
		; 4~: 128 cycle,8 bytes (str2)

@EXIT:
		lda #0
		sta isend_main
		jsr _setScroll
		pla
		plp
		rti	; --------------------------
.endproc
