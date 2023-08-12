; NMI処理

;*------------------------------------------------------------------------------
; PPU_UPDATE_DATAを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; Read PPU update data & store to PPU
; ppuUpdDtTfrInx = (read) PPU Update Data, Transfar and Inx
; memo: tfr-ppu-update-dataではダメ？
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
		inx								; inx before branching
		cmp #PPU_HORIZONTAL_MODE
		beq @HORIZON
		cmp #PPU_VERTICAL_MODE
		beq @VERTICAL
		bne @SET_ADDR
@HORIZON:
		lda #%00000000
		beq @SET
@VERTICAL:
		lda #%00000010
@SET_PPU_CTRL:
		sta tmp1
		lda ppu_ctrl1_cpy
		and #PPU_SP_CODE|1				; Mask the bit 1
		ora tmp1						; Insert vertical/horizon mode in bit1
		sta ppu_ctrl1_cpy

/*
short ver.
		; Insert after inx
01		tay
02		and #%11111100					; Mask bit 0 and 1
03		cmp #%11111100
04		bne @SET_ADDR					; beq => 0b111111XX(0xfc~0xff)
05		tya
06		and #%00000010
07		sta tmp1						; start using tmp1
08		lda ppu_ctrl1_cpy
09		and #%11111101
10		ora tmp1						; end using tmp1
11		sta ppu_ctrl1_cpy

shorter ver.
		; Move inx to the beginning of @SET_ADDR
01		bpl @SET_ADDR					; 0x00~0x7f => @SET_ADDR
02		cmp #%11111100					; $fc
03		bmi @SET_ADDR					; 0xfc~0xff = plus, 0x80~0xfb => @SET_ADDR
04		and #%00000010					; Get flag
05		sta tmp1						; start using tmp1
06		lda ppu_ctrl1_cpy
07		and #%11111101
08		ora tmp1						; end using tmp1
09		sta ppu_ctrl1_cpy
*/

@SET_ADDR:
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

/*
@LOOP:
		lda PPU_UPDATE_DATA, x

		lda PPU_UPDATE_DATA, x
		sta PPU_ADDR
		lda PPU_UPDATE_DATA, x
		sta PPU_ADDR
		ldx #0
@PPU_STORE_LOOP:
		lda PPU_UPDATE_DATA+3, x
		cmp #$ff						; PPU_END_CODE
		beq @EXIT
		sta $80
		inx
		bne @PPU_STORE_LOOP
		*/

@EXIT:
		registerLoad
		rti	; --------------------------
.endproc