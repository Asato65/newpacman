.scope Subfunc

;*------------------------------------------------------------------------------
; Restore PPU setting
; @PARAM	None
; @BREAK	A
; @RETURN	None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _restorePPUSet
		lda ppu_ctrl1_cpy
		sta PPU_CTRL1
		lda ppu_ctrl2_cpy
		sta PPU_CTRL2
		rts
		; ------------------------------
.endproc



;*------------------------------------------------------------------------------
; Set scroll position
; Use during NMI or executing raster scroll.
; @PARAM	None
; @BREAK	A
; @RETURN	None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setScroll
		lda scroll_x
		sta PPU_SCROLL
		lda scroll_y
		sta PPU_SCROLL

	; TODO: きちんとスクロール実装したらメインスクリーンの切り替え実装
	lda ppu_ctrl1_cpy
	and #%1111_1100
	sta ppu_ctrl1_cpy
	sta PPU_CTRL1

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Wait starting vblank
; @PARAM	None
; @BREAK	None
; @RETURN	Non
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _waitVblank
		bit $2002
		bpl _waitVblank
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Disp status text
; @PARAM	None
; @BREAK	A X Y
; @RETURN	None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _dispStatus
		ldx bg_buff_pointer
		ldy #(@TEXT_END - @TEXT)
@STORE_PPU_DATA_LOOP:
		lda @TEXT, x
		beq @END_STORE
		sta BG_BUFF, x
		inx
		dey
		bne @STORE_PPU_DATA_LOOP
@END_STORE:
		stx bg_buff_pointer
		stx $80
		rts
		; ------------------------------

.rodata									; ----- data -----
@TEXT:
		.byte PPU_VERTICAL_MODE
		ADDR_BG_BE 2, 1, 0
		.byte "SCORE XXXXXX  C:YY  TIME ZZZ"
@TEXT_END:

.endproc


;*------------------------------------------------------------------------------
; Prepare plt data
; @PARAM	None
; @BREAK	A X Y
; @RETURN	None
;*------------------------------------------------------------------------------

.proc _preparePltData
		rts
.endproc


.endscope
