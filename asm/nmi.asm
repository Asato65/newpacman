; NMI処理

;*------------------------------------------------------------------------------
; PPU_UPDATE_DATAを読み取り，指定アドレスに書き込んでカウンタをインクリメント
; store Data To PPU
; @PARAM ADDR ストア先
; @BREAK A, X
; @RETURN void
;*------------------------------------------------------------------------------
.macro ppuUpdDtTfrInx ADDR
	lda PPU_UPDATE_DATA, x
	sta ADDR
	inx
.endmacro

.proc NMI
		registerSave
		inc nmi_cnt
		lda isend_main
		beq @EXIT

		inc frm_cnt
		ldx #0
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

@EXIT:
		registerLoad
		rti	; --------------------------
.endproc