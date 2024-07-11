.scope Subfunc

;*------------------------------------------------------------------------------
; Restore PPU setting
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
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
; Set scroll position & change disp
; Use during NMI or executing raster scroll.
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _setScroll
		; lda is_scroll_locked
		; bne @EXIT

		lda scroll_x
		sta PPU_SCROLL
		lda #0
		sta PPU_SCROLL

		lda ppu_ctrl1_cpy
		and #%1111_1110
		ora main_disp
		sta ppu_ctrl1_cpy
		sta PPU_CTRL1

@EXIT:
		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; Wait starting vblank
; @PARAMS		None
; @CLOBBERS		None
; @RETURNS		None
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
; @PARAMS		None
; @CLOBBERS		A X Y
; @RETURNS		None
;*------------------------------------------------------------------------------

.code									; ----- code -----

.proc _dispStatus
		ldx bg_buff_pointer
		ldy #(@TEXT_END - @TEXT)
@STORE_PPU_DATA_LOOP:
		lda @TEXT, x
		beq @END_STORE
		sta bg_buff, x
		inx
		dey
		bne @STORE_PPU_DATA_LOOP
@END_STORE:
		stx bg_buff_pointer
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
; Sleep for one frame
; @PARAMS		None
; @CLOBBERS		A
; @RETURNS		None (A = 1)
;*------------------------------------------------------------------------------

.proc _sleepOneFrame
		lda #0
		sta is_processing_main
:
		lda is_processing_main
		beq :-

		rts
		; ------------------------------
.endproc


;*------------------------------------------------------------------------------
; 基本パレットデータをRAM上のバッファに転送する
; @PARAMS		X: パレット番号
;*------------------------------------------------------------------------------
.proc _trfPltDataToBuff
	ldy #0
:
	ldarr PALETTES
	sta plt_datas, y
	iny
	cpy #$3*8
	bne :-
	rts
	; ------------------------------
.endproc


.endscope
