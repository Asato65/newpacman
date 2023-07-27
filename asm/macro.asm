;*------------------------------------------------------------------------------
; 割り込み等でレジスタの内容を保存する
; @PARAM void
; @BREAK void
; @RETURN void
;*------------------------------------------------------------------------------

.macro registerSave
		php
		pha
		txa
		pha
		tya
		pha
.endmacro

;*------------------------------------------------------------------------------
; 割り込み等終了時にレジスタの内容をリストアする
; @PARAM void
; @BREAK void
; @RETURN void
;*------------------------------------------------------------------------------

.macro registerLoad
		pla
		tay
		pla
		tax
		pla
		plp
.endmacro

;*------------------------------------------------------------------------------
; PPUの設定をコピーからリストアする
; @PARAM void
; @BREAK void
; @RETURN void
;*------------------------------------------------------------------------------

.macro restorePPUSet
		lda ppu_ctrl_cpy
		sta PPU_CTRL
		lda ppu_mask_cpy
		sta PPU_MASK
.endmacro