;*------------------------------------------------------------------------------
; ボタン入力を促すテキストを表示する
; @PARAM void
; @BREAK A
; @RETURN void
;*------------------------------------------------------------------------------

restorePPUSet:
		lda ppu_ctrl_cpy
		sta PPU_CTRL
		lda ppu_mask_cpy
		sta PPU_MASK
		rts	; --------------------------
